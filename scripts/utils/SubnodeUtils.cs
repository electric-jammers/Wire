using System;
using System.Reflection;
using Godot.Collections;

[AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
class SubnodeAttribute : System.Attribute
{
	public string NodePath { get; private set; }

	public SubnodeAttribute(string nodePath = null)
	{
		NodePath = nodePath;
	}
}

public static class NodeExtensions
{
    public static Array<T> FindAllNodesOf<T>(this Godot.Node node) where T : Godot.Node
    {
		var matching = new Array<T>();
        foreach (Godot.Node child in node.GetChildren())
        {
            if (child is T)
            {
                matching.Add((T)child);
            }

			Array<T> kids = child.FindAllNodesOf<T>();
			foreach (T kid in kids)
			{
				matching.Add(kid);
			}
        }

        return matching;
    }

	public static T FindFirstNodeOf<T>(this Godot.Node node) where T : Godot.Node
	{
		foreach (Godot.Node child in node.GetChildren())
		{
			if (child is T)
			{
				return (T)child;
			}
		}

		return null;
	}

	public static void FindSubnodes(this Godot.Node node)
	{
		foreach (PropertyInfo prop in node.GetType().GetProperties(BindingFlags.DeclaredOnly | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
        {
            SubnodeAttribute Subnode = (SubnodeAttribute)Attribute.GetCustomAttribute(prop, typeof(SubnodeAttribute));
			if (Subnode != null)
			{
				string nodePath = Subnode.NodePath == null ? prop.Name : Subnode.NodePath;
				var subnode = node.GetNode(nodePath);
				prop.SetValue(node, subnode);
			}
        }

		foreach (FieldInfo field in node.GetType().GetFields(BindingFlags.DeclaredOnly | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
		{
			SubnodeAttribute Subnode = (SubnodeAttribute)Attribute.GetCustomAttribute(field, typeof(SubnodeAttribute));
			if (Subnode != null)
			{
				string nodePath = Subnode.NodePath == null ? field.Name : Subnode.NodePath;
				var subnode = node.GetNode(nodePath);
				field.SetValue(node, subnode);
			}
		}
	}
}
