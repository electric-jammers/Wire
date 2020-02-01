using Godot;

public class WeakRef<T> where T: Node
{
    private WeakRef InternalRef;

    public WeakRef(Node node)
    {
        InternalRef = Godot.Object.WeakRef(node);
    }

    public T GetRef()
    {
        return (T)InternalRef?.GetRef();
    }

    public static implicit operator WeakRef<T>(WeakRef reference) => new WeakRef<T>((Node)reference.GetRef());
}

public static class WeakRefTools
{
    public static WeakRef<T> ToWeakRef<T> (this Node node) where T : Node => new WeakRef<T>(node);
}