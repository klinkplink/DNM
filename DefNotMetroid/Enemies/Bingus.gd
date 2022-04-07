extends Area2D

var movespeed = 100 
var bingusgravity = 100 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	position.x += movespeed * delta 
	
	if !$CornerCheckLeft.is_colliding() and !$CornerCheckRight.is_colliding():
		position.y += bingusgravity * delta
		movespeed = 0
		$BingusMove.stop()
	elif $CornerCheckLeft.is_colliding() and $CornerCheckRight.is_colliding() and $BingusMove.is_stopped():
		$BingusMove.start()
		movespeed = 100
		
	if ((!$CornerCheckLeft.is_colliding() and $ReverseCooldown.is_stopped()) 
		or (!$CornerCheckRight.is_colliding() and $ReverseCooldown.is_stopped())):
			bingus_reverse()
			$ReverseCooldown.start()
			$BingusMove.start()

func _on_BingusMove_timeout():
	bingus_reverse()

func bingus_reverse():
	movespeed = -movespeed

func bingus_dead():
	print("bingus has died")
	queue_free()

func bingus_god():
	print("Bingus Is God")
