extends RigidBody2D

const THRUST := 300.0
const RECOIL := -100 

var player : RigidBody2D
var bulletsManager : Node2D

var chaseState := false
var cooldownMS := 500
var nextTime := 0.0

func _ready() -> void:
	$Tail.visible = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if player == null:
		return
	
	state.transform = state.transform.looking_at(player.global_position)
	
	var dist = global_position.distance_to(player.global_position) 
	
	if chaseState:
		$Tail.visible = true
		state.apply_central_force(transform.x * THRUST)
	else:
		$Tail.visible = false
		
	if dist < 150:
		var currentTime = Time.get_ticks_msec()
		
		if currentTime >= nextTime:
			bulletsManager.shootBullet(self)
			state.apply_central_impulse(transform.x * RECOIL)
			nextTime = currentTime + cooldownMS
			
	elif dist < 300 or dist > 200:
		chaseState = true
	else:
		chaseState = false	
