@tool
extends Area2D

var px_to_m = 30.48
@export_subgroup("Settings")
@export var coreRadius:float:												#in meters	100pix = ~3m
	set(orbitRadius):
		coreRadius = orbitRadius
		if $Orbit/CollisionShape2D:
			$Orbit/CollisionShape2D.shape.radius = orbitRadius*px_to_m
@export var fieldRadius:float:													#in meters	100pix = ~3m
	set(newFieldRadius):
		fieldRadius = newFieldRadius
		if $Field:
			$Field.shape.radius = newFieldRadius*px_to_m
@export var fluxDensity:float													#in Tesla
@export var maxVelocityDelta:float												#in m/s

#var orbitRadius:
	#get:
		#return coreRadius*2	
	#set(value):
			#orbitRadius = value
			#if $Orbit/CollisionShape2D:
				#$Orbit/CollisionShape2D.shape.radius = orbitRadius*px_to_m
var magnet 
var player
var playerPos
var orbitPos
var orbitCenter
var orbit
var field
var orbitflag
var approachAngle
var targetVector:Vector2
var targetPos
var oldLookAtRot
var newLookAtRot
var oldDistance
var newDistance
var targetPoint
var coreRadiusPx

####################################################################################################

func _ready() -> void:
	if not Engine.is_editor_hint():
		player = %Player
		magnet = self
		coreRadiusPx = coreRadius*px_to_m
		orbitCenter = get_node("OrbitCenter")
		orbit = get_node("Orbit")
		field = get_node("Field")
		targetPoint = get_node("TargetPoint")


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		orbitCenter.look_at(player.get_global_position())
		player_orbit()
		oldLookAtRot = orbitCenter.rotation
		oldDistance = player.get_global_position().distance_to(orbitCenter.get_global_position())


func player_orbit():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			playerPos = player.get_global_position()
			orbitPos = orbitCenter.get_global_position()
			approachAngle = (playerPos-orbitPos).angle()
			newLookAtRot = orbitCenter.rotation
			if newLookAtRot > oldLookAtRot:
				targetVector = Vector2.DOWN.rotated(approachAngle)	#CW
			elif newLookAtRot < oldLookAtRot:
				targetVector = Vector2.UP.rotated(approachAngle)	#CCW
			targetPos = orbitPos+(1*targetVector * orbit.get_node("CollisionShape2D").shape.radius)
			targetPoint.set_global_position(targetPos)
			
			var magVector = playerPos.direction_to(targetPos)
			var distance = orbitPos.distance_to(playerPos) / px_to_m	#distance in meters
			var magStrength = fluxDensity * (1.33 * 3.14159 * (coreRadiusPx**3)) #field strength x volume of sphere
			var magForce = magStrength / (distance*(0.5*field.shape.radius/coreRadiusPx))
			var magAcceleration = magForce / player.mass
			var magVelocity = magVector * magAcceleration * player.is_magnetized
			### var orbitStability = Vector2.ZERO						### Future experiment: When traveling 
			### newDistance = playerPos.distance_to(orbitPos)			### past orbitCenter reduce forward 
			### if distance > (oldDistance / px_to_m):					### velocity and nudge into either CW  
			###		orbitStability = playerPos.direction_to(orbitPos)	### or CCW orbit direction, similar to
			###															### apogee/perigee orbit stabilization
			player.magVelocity = magVelocity.clamp(Vector2(-1*maxVelocityDelta,-1*maxVelocityDelta),Vector2(maxVelocityDelta,maxVelocityDelta))# -add orbitStability??
