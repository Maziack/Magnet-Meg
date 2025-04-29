class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed:float = 475
@export var ground_accel_speed:float = 60
@export var ground_decel_speed:float = 45
@export var air_accel_speed:float = 20
@export var air_decel_speed:float = 2

func handle_horizontal_movement(body:CharacterBody2D, direction:float):
	var velocity_change_speed:float = 0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
	
	body.velocity.x = move_toward(body.velocity.x, speed * direction, velocity_change_speed)
