extends Node2D

@export var enemyScene: PackedScene
@export var enemyScript: Script
@export var HealthComponentScene: PackedScene
@export var health := 10

@onready var camera = %Player/Camera2D
@onready var screenSize = get_viewport_rect().size/camera.zoom

func _spawn_enemy():
	var enemy := enemyScene.instantiate()
	
	enemy.set_script(enemyScript)
	enemy.player = %Player
	enemy.bulletsManager = %Bullets
	
	var camPos = camera.get_screen_center_position()
	
	var x_min = camPos.x - (screenSize.x / 2)
	var x_max = camPos.x + (screenSize.x / 2)
	var y_min = camPos.y - (screenSize.y / 2)
	var y_max = camPos.y + (screenSize.y / 2)
	
	enemy.position = Vector2(
		randf_range(x_min, x_max),
		randf_range(y_min, y_max)
	)
	
	var HealthComponent = enemy.get_node("HealthComponent")
	HealthComponent.health = self.health
	
	var notifier = enemy.get_node("VisibleOnScreenNotifier2D")
	notifier.screen_exited.connect(_on_enemy_outside.bind(enemy))

	enemy.modulate = Color(randf(), randf(), randf(), 1.0)
	
	add_child(enemy)

func _on_enemy_outside(enemy: RigidBody2D):
	enemy.queue_free()

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(0.5, 2.0)
	if %Player == null:
		$Timer.stop()
		return
	_spawn_enemy()
