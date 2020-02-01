using System;
using System.Threading.Tasks;
using Godot;

public class AssetRef<T> where T : Resource
{
    public string ResourcePath { get; private set; }
    private bool HoldRef = true;

    private T Object;
    public bool IsLoaded => Object != null;

    public AssetRef(string path, bool holdRef = true)
    {
        ResourcePath = path;
        HoldRef = holdRef;

        if (OS.IsDebugBuild() && !ResourceLoader.Exists(path))
        {
            GD.Print($"*** ERROR: Broken AssetRef: {path} ***");
        }
    }
    public static implicit operator AssetRef<T>(string path) => new AssetRef<T>(path);

    public T Load()
    {
        if (HoldRef && Object == null)
        {
            Object = GD.Load<T>(ResourcePath);
            return Object;
        }
        
        return GD.Load<T>(ResourcePath);
    }

    public async Task<T> LoadAsync()
    {
        if (HoldRef && Object == null)
        {
            Object = await AsyncUtil.LoadAsync<T>(ResourcePath);
            return Object;
        }        
        
        return await AsyncUtil.LoadAsync<T>(ResourcePath);
    }

    public void Reload()
    {
        Object = null;
        Load();
    }
}

public class SceneRef : AssetRef<PackedScene>
{
    public SceneRef(string scenePath, bool holdRef = true) : base(scenePath, holdRef) 
    {

    }
    public static implicit operator SceneRef(string path) => new SceneRef(path);
}