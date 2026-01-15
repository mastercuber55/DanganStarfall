extends Node2D

signal fuel_changed(val)

@export var fuel : float = 100.0:
	set(value):
		fuel = value
		fuel_changed.emit(value)
