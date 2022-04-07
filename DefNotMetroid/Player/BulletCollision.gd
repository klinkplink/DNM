extends RayCast2D

signal hitdetected(collider)

#signals the parent bullet what it hit and then kills the bullet
func _physics_process(delta):
	if is_colliding():

		emit_signal("hitdetected",get_collider())
		get_parent().queue_free()
