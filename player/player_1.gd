extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var anim: AnimatedSprite2D = $player_model as AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	anim.play("idle")

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
	
	change_anim()
	move_and_slide()

func change_anim():
	if velocity.x>0:
		anim.flip_h = false
	elif velocity.x<0:
		anim.flip_h = true
	if velocity.x == 0:
		anim.play("idle")
	else:
		anim.play("walkin")
	if is_on_wall():
		anim.play("idle")


func _on_player_area_area_entered(area: Area2D) -> void:
	if area.has_method("mirror"):
		$dialogue.show()
		$dialogue.update_message("Зеркало")
		await get_tree().create_timer(1.0).timeout
		$dialogue.hide()
