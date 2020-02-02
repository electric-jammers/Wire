extends Control
class_name RoundComplete

var main_scene: MainScene

func _ready():
	$AnimationPlayer.play("animate_in")

func _on_click_restart():
	main_scene.reload_level()
	
func _on_click_next_level():
	main_scene.load_next_level()
