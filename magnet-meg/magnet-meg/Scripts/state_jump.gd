class_name StateJump
extends Node

@export_subgroup("Settings")
@export var jump_velocity:float = -400

var is_jumping = false

func handle_jumping(body:CharacterBody2D, jump_input):
	if jump_input and body.is_on_floor():
		body.velocity.y = jump_velocity

	is_jumping = body.velocity.y < 0 and not body.is_on_floor()
