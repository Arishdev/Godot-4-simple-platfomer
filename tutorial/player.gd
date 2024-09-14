extends CharacterBody2D

#Important node refrence variables

@onready var cayote_timer: Timer = $Cayote_timer
@onready var dash_timer: Timer = $Dash_timer
@onready var can_dash_timer: Timer = $Can_dash_timer

#Constants 

const JUMP_VELOCITY = -500.0

#Varibales

var walk_speed : float = 150.0
var cayote_time : float = 0.1
var dash_speed : float = 600.0
var can_jump : bool = true
var dashing : bool = false
var can_dash : bool = true

#makes the player jump (change JUMP_VELOCITY and gravity in setting for different jump height and gravity)

func jump():
	velocity.y = JUMP_VELOCITY
	can_jump = false

#Cayote timer more explanation later

func _on_cayote_timer_timeout():
	can_jump = false
	print('hello w')

#on timeout the player state is changed to something else than dashing

func _on_dash_timer_timeout():
	dashing = false
	velocity.x = 0

#on timeout allows player to dash again

func _on_can_dash_timer_timeout():
	can_dash = true

#controls all the physicss stuff

func _physics_process(delta):
	
	#checks and set can jump to true if player is on ground
	
	if !can_jump and is_on_floor():
		can_jump = true
	
	#if the player leaves the floor then this will start the cayote timer and allows player to jump even after leaing the floor for a fraction of a second
	
	if can_jump and cayote_timer.is_stopped() and !is_on_floor():
		cayote_timer.start(cayote_time)
	
	#adds gravity 
	
	if not is_on_floor():
		velocity += get_gravity() * delta 
	
	#if jump button (key Z) is pressed then it will activate jump function
	if Input.is_action_just_pressed("jump") and can_jump:
		jump()
	
	#if the player relases the jump before reaching full height then it will stops the player from going heigher (good for precision platformer)
	
	if Input.is_action_just_released("jump") and !is_on_floor():
		velocity.y *= 0.5
	
	#this checks if player pressed dash button (key X) and changes to dashing
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		can_dash_timer.start()
	
	#direction var (this should be global tf??????)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	#movement
	
	if direction:
		
		#if player is in dash mode
		
		if dashing:
			velocity.x = direction * dash_speed
			velocity.y = 0
		
		#if player is not in dash mode
		
		else:
			velocity.x = direction * walk_speed
		
	#adds a bit of smoothness and also stops the player if player is not pressing any movement key
		
	else:
		velocity.x = move_toward(velocity.x, 0, delta * walk_speed * 4)
	
	move_and_slide()
