extends Area2D

var movespeed = 100 
var bingusgravity = 100 

func _physics_process(delta):
	position.x += movespeed * delta 
	
	#If neither corner checker is touching ground, bingus falls and stops moving sideways
	if !$CornerCheckLeft.is_colliding() and !$CornerCheckRight.is_colliding():
		position.y += bingusgravity * delta
		movespeed = 0
		$BingusMove.stop()
	elif $CornerCheckLeft.is_colliding() and $CornerCheckRight.is_colliding() and $BingusMove.is_stopped():
		#Starts bingus move once he lands 
		$BingusMove.start()
		movespeed = 100
		
	if ((!$CornerCheckLeft.is_colliding() and $ReverseCooldown.is_stopped()) 
		or (!$CornerCheckRight.is_colliding() and $ReverseCooldown.is_stopped())):
			#Reverses bingus when he hits an edge as long as hes not on turn cd
			bingus_reverse()
			$ReverseCooldown.start()
			$BingusMove.start()

func _on_BingusMove_timeout():
	bingus_reverse() 

func bingus_reverse():
	movespeed = -movespeed #reverse 

func bingus_dead(): #bingus is kill 
	print("bingus has died")
	queue_free()

func bingus_god(): # hehe secret
	print("Bingus Is God")
