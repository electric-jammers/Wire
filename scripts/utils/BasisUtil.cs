using Godot;

public static class BasisUtil
{
    public static Vector3 GetRight(this Basis basis) => basis.x;
    public static Vector3 GetUp(this Basis basis) => basis.y;
    public static Vector3 GetForward(this Basis basis) => -basis.z;

    public static Vector3 GetRight(this Transform tform) => tform.basis.GetRight();
    public static Vector3 GetUp(this Transform tform) => tform.basis.GetUp();
    public static Vector3 GetForward(this Transform tform) => tform.basis.GetForward();
}
