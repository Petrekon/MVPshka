extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var playerImg = get_node("player_model")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("go_left", "go_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.x<0:
		$player_model.play("walkin")
		playerImg.flip_h=true
	elif velocity.x>0:
		$player_model.play("walkin")
		playerImg.flip_h=false
	elif velocity.x==0:
		$player_model.play("idle")
		
	if is_on_wall():
		$player_model.play("idle")
		
	
	move_and_slide()
