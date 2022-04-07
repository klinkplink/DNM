extends Control

export var Level1:PackedScene

func _on_Start_pressed():
	get_tree().change_scene_to(Level1)


func _on_Quit_pressed():
	get_tree().quit()
