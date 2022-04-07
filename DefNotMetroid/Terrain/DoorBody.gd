extends StaticBody2D

export var NextLevel:PackedScene

#flips sprite visibility and lets the player go through the door
#this was supposed to open/close each time you hit it doesnt bc i didnt finish
#setting that up 
func door_flip():
	$OpenSprite.visible = !$OpenSprite.visible
	$ClosedSprite.visible = !$ClosedSprite.visible 
	$DoorCollisionPlayer.set_deferred("disabled",true)
	#$CloseTimer.start()
#
#
#func _on_CloseTimer_timeout():
#	$DoorCollisionPlayer.set_deferred("disabled",false)
#	$OpenSprite.visible = !$OpenSprite.visible
#	$ClosedSprite.visible = !$ClosedSprite.visible 
