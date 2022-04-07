extends StaticBody2D

export var NextLevel:PackedScene

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
