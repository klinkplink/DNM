extends Node2D
export var bulletspeed = 900

#signal bulletstrike #Unused 

func _process(delta):
	move_local_x(delta*bulletspeed)
	
func _on_death_timeout(): #times out after a bit 
	queue_free()

func _on_BulletCollision_hitdetected(collider):
	print(collider)
	#lit just scrapped these together instead of a signal handler dont sue me
	#checks for naming conventions and then triggers appropriate setting 
	
	if "Enemy" in collider.name:
		print("Enemy hit")
		collider.bingus_dead()
		
	if "Door" in collider.name:
		print("Door Hit")
		collider.door_flip()
	
