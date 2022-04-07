extends RayCast2D

signal hitdetected(collider)

func _physics_process(delta):
	if is_colliding():

		emit_signal("hitdetected",get_collider())
		get_parent().queue_free()
