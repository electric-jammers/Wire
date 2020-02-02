extends Control
class_name RoundComplete

var main_scene: MainScene

func _ready():
	$AnimationPlayer.play("animate_in")

func _on_click_restart():
	main_scene.reload_level()
	$AnimationPlayer.play_backwards("animate_in")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func _on_click_next_level():
	main_scene.load_next_level()
	$AnimationPlayer.play_backwards("animate_in")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
