using System;
using Godot;

public static class Maths
{
	public static Basis MakeBasis(Vector3 fwd)
	{
		return MakeBasis(fwd, Vector3.Up);
	}
	public static Basis MakeBasis(Vector3 fwd, Vector3 up)
	{
		if (fwd == Vector3.Zero)
		{
			fwd = new Vector3(1.0f, 0.0f, 0.0f);
		}

		// Right = fwd x up
		Vector3 right = fwd.Cross(up);
		
		// Up = right x fwd
		up = right.Cross(fwd);

		return new Basis(right, up, fwd);
	}

	public static float RandRange(float mini, float maxi)
	{
		return (float)GD.RandRange(mini, maxi);
	}

	//jwf: extension method?!
	public static Color DarkenColour(Color colour, float amount = 0.2f)
	{
		float darkenFactor = Mathf.Clamp(1.0f - amount, 0.0f, 1.0f);
		return new Color(colour.r * darkenFactor, colour.g * darkenFactor, colour.b * darkenFactor);
	}

	public static Basis GetCameraFlatBasis(SceneTree tree)
	{
		Camera camera = tree.Root.GetCamera();
		if (camera == null)
		{
			return Basis.Identity;
		}

		float angle = camera.GlobalTransform.basis.GetEuler().y;
		return new Basis(Vector3.Up, angle);
	}

	public static Vector3 SafeNormalise(Vector3 v)
	{
		float len = v.Length();
		if (len == 0.0f)
		{
			return Vector3.Zero;
		}

		return v / len;
	}

	public static Vector2 SafeNormalise(Vector2 v)
	{
		float len = v.Length();
		if (len == 0.0f)
		{
			return Vector2.Zero;
		}

		return v / len;
	}

	public static Basis Slerp(Basis b1, Basis b2, float alpha)
	{
		return new Basis(b1.Quat().Normalized().Slerp(b2.Quat().Normalized(), alpha));
	}

	public static float GetTime()
	{
		return ((float)OS.GetTicksMsec()) / 1000.0f;
	}
}