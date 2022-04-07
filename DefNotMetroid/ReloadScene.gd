extends Node

func _ready():
	get_tree().change_scene("res://MainMenu.tscn")

#Loading the main menu directly in a packed scene causes a crash, unsure why
#Load this on the last level to go back to main menu
