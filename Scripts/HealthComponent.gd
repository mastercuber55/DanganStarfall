extends Node2D

signal health_changed(val)

@export var health := 100:
	set(value):
		health = value
		health_changed.emit(value)
