extends CharacterBody2D

@export_subgroup("Player Settings")
@export var mass:float = 50
@export var max_velocity:float = 40

@export_subgroup("Nodes")
@export var gravity_component:GravityComponent
@export var input_component:InputComponent
@export var movement_component:MovementComponent
@export var jump_component:JumpComponent

var is_magnetized = 0
var originalGravity
var magVelocity:Vector2
###############################################################################

func player():
	pass

func _ready() -> void:
	originalGravity = gravity_component.gravity

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		is_magnetized = 1
	if Input.is_action_just_released("jump") and is_magnetized == 1:
		is_magnetized = 0
		gravity_component.gravity = originalGravity
	
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jumping(self, input_component.get_jump_input())
	velocity = (velocity + magVelocity).clamp(Vector2(-1*max_velocity,-1*max_velocity),Vector2(max_velocity,max_velocity))
	print("Gravity: ", gravity_component.gravity)
	move_and_slide()
