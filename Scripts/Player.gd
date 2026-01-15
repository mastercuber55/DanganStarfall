extends RigidBody2D

const THRUST := 300.0
const RECOIL := -50 
const FUEL_CONSUMTION := 0.01

const cooldownMS := 250
var nextTime := 0.0

@export var HealthBar : ProgressBar
@export var FuelBar : ProgressBar

func _ready() -> void:
	$HealthComponent.health_changed.connect(updateHealthBar)
	$FuelComponent.fuel_changed.connect(updateFuelBar)
	
	updateHealthBar($HealthComponent.health)
	updateFuelBar($FuelComponent.fuel)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("Thrust") and $FuelComponent.fuel > 0:
		$Tail.visible = true
		state.apply_central_force(transform.x * THRUST)
		$FuelComponent.fuel -= FUEL_CONSUMTION
	else:
		$Tail.visible = false
		
	if Input.is_action_pressed("Shoot"):
		var currentTime = Time.get_ticks_msec()
		
		if currentTime >= nextTime:
			%Bullets.shootBullet(self)
			state.apply_central_impulse(transform.x * RECOIL)
			nextTime = currentTime + cooldownMS
		
func updateHealthBar(val: float) -> void:
	HealthBar.value = val
	
func updateFuelBar(val: float) -> void:
	FuelBar.value = val


func _on_pickuper_area_entered(area: Area2D) -> void:
	$FuelComponent.fuel += 10
	area.get_parent().call_deferred("queue_free")
