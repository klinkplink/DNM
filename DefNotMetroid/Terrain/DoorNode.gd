extends Node2D

export var NextLevel:PackedScene


func _on_LevelLoader_body_entered(body):
	get_tree().change_scene_to(NextLevel)
