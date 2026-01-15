extends Node2D

@export var bulletSpeed := 1000
@export var bulletScene : PackedScene

@export var fuelScene : PackedScene 
@export var healthScene : PackedScene

var bullets : Array[Area2D] = []

func _process(delta: float) -> void:
	for bullet in bullets:	
		bullet.position += bullet.get_meta("direction") * bulletSpeed * delta

func shootBullet(shooter: RigidBody2D):
	var bullet = bulletScene.instantiate()
	var spawnPoint = shooter.get_node("BulletSpawnPoint").global_position
	
	bullet.global_position = spawnPoint
	bullet.set_meta("direction", Vector2.from_angle(shooter.global_rotation))
	bullet.body_entered.connect(_onBulletHit.bind(bullet))
	
	bullets.append(bullet)
	call_deferred("add_child", bullet)

func _onBulletHit(body: RigidBody2D, bullet: Area2D):	
	if not body.has_node("HealthComponent"):
		return
	
	var HealthComponent := body.get_node("HealthComponent")
	HealthComponent.health -= 1
	
	if HealthComponent.health <= 0:
		if randf() < 0.25:
			var pickup
			if randf() > 0.5:
				pickup = healthScene.instantiate()
			else:
				pickup = fuelScene.instantiate()
			pickup.position = body.position
			$"../Pickups".call_deferred("add_child", pickup)
		$Explosion.play()
		body.queue_free()
		
	bullets.erase(bullet)
	bullet.queue_free()
