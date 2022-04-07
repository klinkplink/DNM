extends KinematicBody2D

# Add states 

const GRAV = 1800.0
const WALK_SPEED = 500.0
const JUMP_SPEED = 650
const DAMP_SPEED = WALK_SPEED * 2.5 

export var playerhp:int = 20
var playergravity = GRAV
var jump_damp_modifier = 1 
var velocity = Vector2()
var jumped = false
var doublejumped  = false 
var gracetime = false
var printer = 0
var bulletscene = load("res://Player/Bullet.tscn")

func _ready():
	pass

func _physics_process(delta):
	#print(velocity)
	
	if $"walldetector (left)".is_colliding() and velocity.x < 0:
		velocity.x = 1
		print("wall bounce left")
	elif $"walldetector (right)".is_colliding() and velocity.x > 0:
		velocity.x = -1		
		print("wall bounce right")		
	if is_on_floor():
		#Resets double jump
		if doublejumped:
			doublejumped = false
		#Negates any additional downwards velocity 
		if velocity.y > 1:
			velocity.y = 1
	else:
		velocity.y += delta * playergravity # Triggers gravity
		
	if is_on_ceiling(): #Stops you when you hit a ceiling
		velocity.y = 1
		
	#input handler 
	if $Stunned.is_stopped():
		if Input.is_action_pressed("ui_left"):
			if velocity.x >= -WALK_SPEED:
				velocity.x += -(WALK_SPEED*delta*2)
				if !is_on_floor():
					velocity.x += -(WALK_SPEED*delta*0.5)
				if velocity.x > 0:
					velocity.x += -(WALK_SPEED*delta*0.5)
					#print("Adding stopping power during opposite move input")
			#velocity.x = -WALK_SPEED
			if Input.is_action_pressed("ui_up"):
				$Gun.rotation_degrees = -135
			else:
				$Gun.rotation_degrees = -180
			$Gun/GunSprite.flip_v = true 
		elif Input.is_action_pressed("ui_right"):
			if velocity.x <= WALK_SPEED:
				velocity.x += (WALK_SPEED*delta*2)
				if !is_on_floor():
					velocity.x += (WALK_SPEED*delta*0.5)
				if velocity.x < 0:
					velocity.x += (WALK_SPEED*delta*0.5)
					#print("Adding stopping power during opposite move input")
			if Input.is_action_pressed("ui_up"):
				$Gun.rotation_degrees = -45
			else:
				$Gun.rotation_degrees = 0
			$Gun/GunSprite.flip_v = false
		elif Input.is_action_pressed("ui_up"):
			$Gun.rotation_degrees = -90
			dampen(delta)
		else:
			dampen(delta)
			

			
		if Input.is_action_pressed("fire") and $FireDelay.is_stopped():
			firebullet()
			$FireDelay.start()
			print("Started firedelay")
			
		if Input.is_action_just_released("fire"):
			$FireDelay.stop()

		if jumped and is_on_floor():
			#print("Reset jump")
			jumped = false
			
		#Jump if youre on the floor, doublejump otherwise
		if Input.is_action_just_pressed("ui_jump"):
			if is_on_floor():
				jump(1)
			elif !is_on_floor() and !doublejumped:
				jump(2)
			elif doublejumped and !is_on_floor():
				$JumpGracetime.start()
				gracetime = true 
				
		if Input.is_action_pressed("ui_jump") and gracetime and is_on_floor():
			#print("grace jump")
			jump(1)
			
	if jumped and velocity.y > 0 and playergravity < GRAV:
		print("Falling")
		gravitytoggle()
	
	move_and_slide(velocity, Vector2(0, -1),true)

func dampen(delt):
	var damp_force_direction:int # -1 stops right movement, 1 stops left movement, 0 does nothing
	
	if is_on_floor() and jump_damp_modifier != 1:
		jump_damp_modifier = 1
		#print("Landed, setting jump dampener back to " + str(jump_damp_modifier))
	elif !is_on_floor() and jump_damp_modifier == 1:
		#print("Airborne, setting jump dampener back to " + str(jump_damp_modifier))
		jump_damp_modifier = 0.1
		
	if (velocity.x < 10 and velocity.x > -10):
		velocity.x = 0
		damp_force_direction = 0 
	elif velocity.x < 0:
		damp_force_direction = 1
	else:
		damp_force_direction = -1
	velocity.x += (DAMP_SPEED * jump_damp_modifier) * damp_force_direction * delt 

	
func gravitytoggle(override:bool = false):
	if playergravity == GRAV or override:
		playergravity = GRAV * 0.7
	else:
		playergravity = GRAV
	#print("Gravity toggled, current value is " + str(playergravity))

func jump(jumpnum):
	if jumpnum == 1:
		velocity.y = -(JUMP_SPEED * 0.8)
		#print("Jumped")
		jumped = true 
		$MidJump.start()
		$LongJump.start()
	elif jumpnum == 2:
		#print("Doublejump activated")
		velocity.y = -JUMP_SPEED * 0.8
		doublejumped = true 
	gravitytoggle(true)
	
func _on_JumpGracetime_timeout():
	gracetime = false
	#print("Gracetime ended")
	
func _on_DEATHPLANE_body_entered(body):
	print("Deathplane Entered")
	pass

func firebullet():
	var bullet = bulletscene.instance()
	bullet.global_position = $Gun/GunSprite.global_position
	bullet.rotation = $Gun.rotation	
	get_parent().add_child(bullet)

func _on_FireDelay_timeout():
	print("spawning bullet")
	firebullet()

func _on_LongJump_timeout():
	if Input.is_action_pressed("ui_jump") and !doublejumped:
		velocity.y += -(JUMP_SPEED/8)
		print("Long jump")
	else:
		print("Key released, no longjump")


func _on_MidJump_timeout():
	if Input.is_action_pressed("ui_jump") and !doublejumped:
		velocity.y += -(JUMP_SPEED/8)
		print("Mid jump")
	else:
		print("Key released, no midjump")


func _on_Hitbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area.global_position)
	$Stunned.start()
	$OOF.play()
	print("Stunned from collision")

	playerhp -= 2 
	$HPBase/HPGreen.margin_right = playerhp
	$HPBase.visible = true 
	$HPBase/Fadetimer.start()
	
	if area.global_position.x > global_position.x:
		velocity.x = -300
	else:
		velocity.x = 300
		
	if area.global_position.y > global_position.y - 50:
		velocity.y = -400
	else:
		velocity.y = 400


func _on_Stunned_timeout():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	print("FLOOR DETECTED")
	position.y -= 2


func _on_Fadetimer_timeout():
	$HPBase.visible = false 
