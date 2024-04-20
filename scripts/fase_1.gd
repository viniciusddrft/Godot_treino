extends Node3D

var dino: PackedScene = preload('res://scenes/dinossauro.tscn')
var listPositions : Array = []
@export var amount_dino :int=10

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
