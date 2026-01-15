extends Node2D

@export var asteroidScene: PackedScene

@onready var camera = %Player/Camera2D
@onready var screenSize = get_viewport_rect().size/camera.zoom

func _spawn_asteroid():
	var asteroid := asteroidScene.instantiate()
		
	var camPos = camera.get_screen_center_position()
	
	var x_min = camPos.x - (screenSize.x / 2)
	var x_max = camPos.x + (screenSize.x / 2)
	var y_min = camPos.y - (screenSize.y / 2)
	var y_max = camPos.y + (screenSize.y / 2)
	
	asteroid.position = Vector2(
		randf_range(x_min, x_max),
		randf_range(y_min, y_max)
	)
	
	var s = randf_range(0.5, 2.0)
	
	for child in asteroid.get_children():	
		child.scale = Vector2(s, s)
	
	var notifier = asteroid.get_node("VisibleOnScreenNotifier2D")
	notifier.screen_exited.connect(_on_asteroid_outside.bind(asteroid))
	
	asteroid.modulate = Color(randf(), randf(), randf(), 1.0)
	asteroid.get_node("HealthComponent").health = s * 10
	
	add_child(asteroid)

func _on_asteroid_outside(asteroid: RigidBody2D):
	asteroid.queue_free()

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	if %Player == null:
		$Timer.stop()
		return
	$Timer.wait_time = randf_range(0.5, 2.0)
	_spawn_asteroid()
