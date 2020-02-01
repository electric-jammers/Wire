using Godot;

public static class VectorUtil
{
    public static Vector3 SetX(this Vector3 vector, float newX) => new Vector3(newX, vector.y, vector.z);
    public static Vector3 SetY(this Vector3 vector, float newY) => new Vector3(vector.x, newY, vector.z);
    public static Vector3 SetZ(this Vector3 vector, float newZ) => new Vector3(vector.x, vector.y, newZ);

    public static Vector3 AddX(this Vector3 vector, float addX) => new Vector3(vector.x + addX, vector.y, vector.z);
    public static Vector3 AddY(this Vector3 vector, float addY) => new Vector3(vector.x, vector.y + addY, vector.z);
    public static Vector3 AddZ(this Vector3 vector, float addZ) => new Vector3(vector.x, vector.y, vector.z + addZ);
}