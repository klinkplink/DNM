extends Node2D
export var bulletspeed = 900

signal bulletstrike

func _process(delta):
	move_local_x(delta*bulletspeed)
	
func _on_death_timeout():
	queue_free()

func _on_BulletCollision_hitdetected(collider):
	print(collider)
	if "Enemy" in collider.name:
		print("Enemy hit")
		collider.bingus_dead()
		
	if "Door" in collider.name:
		print("Door Hit")
		collider.door_flip()
	
