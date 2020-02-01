using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Godot;

public static class AsyncUtil
{
    public static async Task<T> LoadAsync<T>(string resourcePath) where T : Resource
    {
        if (ResourceLoader.HasCached(resourcePath))
        {
            return ResourceLoader.Load<T>(resourcePath);
        }

        T returnedResource = null;

        await Task.Run(() => 
        {
            lock(typeof(AsyncUtil))
            {
                // Don't use the cache for threading reasons!
                returnedResource = GD.Load<T>(resourcePath);
            }
        });

        return returnedResource;
    }
}