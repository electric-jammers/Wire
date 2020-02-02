extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("animation_in")

func _play_game():
	get_tree().change_scene("res://scenes/MainScene.tscn")
