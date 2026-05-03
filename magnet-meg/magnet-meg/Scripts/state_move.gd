class_name StateMove
extends Node

@export_subgroup("Settings")
@export var top_input_speed:float = 475
@export var ground_accel_speed:float = 60
@export var ground_decel_speed:float = 45
@export var air_accel_speed:float = 20
@export var air_decel_speed:float = 2

func handle_horizontal_movement(body:CharacterBody2D, direction:float):
	var velocity_change_speed:float = 0
	var final_move_speed = 0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
		final_move_speed = top_input_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
		final_move_speed = maxf(top_input_speed,body.velocity.x)
	body.velocity.x = move_toward(body.velocity.x, final_move_speed * direction, velocity_change_speed)
