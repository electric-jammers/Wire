using System;
using Godot;

public class TweenInfo
{
    public Godot.Object Object;
    public string PropertyOrMethod;

    public object InitialValue = null;
    public object FinalValue = 1.0f;

    public float Duration = 1.0f;

    public Tween.TransitionType TransitionType = Tween.TransitionType.Linear;
    public Tween.EaseType EaseType = Tween.EaseType.InOut;
    public float Delay = 0.0f;
}

public static class TweenUtil
{
    public static Tween TweenInstance = new Tween();

    public static float RunEquation(Tween.TransitionType transitionType, Tween.EaseType easeType, float alpha, float initialValue, float finalValue)
    {
        return TweenInstance.RunEquation(transitionType, easeType, alpha, initialValue, finalValue);
    }
    public static async void FireInterpolateProperty(Node node, TweenInfo info)
    {
        Tween tween = new Tween();
        node.AddChild(tween);

        tween.InterpolateProperty(info.Object ?? node, new NodePath(info.PropertyOrMethod), info.InitialValue, info.FinalValue, info.Duration, info.TransitionType, info.EaseType);
        tween.Start();
        await node.ToSignal(tween, "tween_completed");
        tween.QueueFree();
    }

    public static async void FireInterpolateMethod(Node node, TweenInfo info)
    {
        Tween tween = new Tween();
        node.AddChild(tween);

        tween.InterpolateMethod(info.Object ?? node, info.PropertyOrMethod, info.InitialValue, info.FinalValue, info.Duration, info.TransitionType, info.EaseType);
        tween.Start();
        await node.ToSignal(tween, "tween_completed");
        tween.QueueFree();
    }
}