class_name StateMagnetize
extends Node

@export_subgroup("Settings")
@export_range(0.01, 0.1, 0.01) var fluxDensityLo:float = 0.02
@export_range(50, 200, 25) var maxAccelerationLo:float = 150
@export_range(0.01, 0.1, 0.01) var fluxDensityMed:float = 0.02
@export_range(50, 200, 25) var maxAccelerationMed:float = 150
@export_range(0.5, 10, 0.5) var fluxDensityHi:float = 5.0
@export_range(200, 500, 25) var maxAccelerationHi:float = 250

var is_magnetic = 0
var magToggle = 0
var fluxDensity = {"Lo":fluxDensityLo, "Med":fluxDensityMed, "Hi":fluxDensityHi}
var maxAcceleration = {"Lo":maxAccelerationLo, "Med":maxAccelerationMed, "Hi":maxAccelerationHi}

func handle_magnetization(body:CharacterBody2D, jump_input, jump_release, mag_toggle):
	if jump_input and not body.is_on_floor():
		is_magnetic = 1
	if jump_release and is_magnetic == 1:
		is_magnetic = 0
	if mag_toggle and magToggle == 0:
		magToggle = 1
	elif mag_toggle and magToggle == 1:
		magToggle = 0
