extends Node3D

var bloco: PackedScene = preload('res://scenes/bloco.tscn')
var rampa: PackedScene = preload('res://scenes/rampa.tscn')
var listPositions : Array = []

@export var amount_bloco: int = 100
@export var amount_rampa: int = 100

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for i in range(0, amount_bloco):
		bloco.instantiate()
		var newBloco:Node3D = bloco.instantiate()
		$NavigationRegion3D/Blocos.add_child(newBloco)
		var new_position: Vector2 = _generatePosition() 
		newBloco.set_position(Vector3(new_position.x,0,new_position.y))
		listPositions.append(Vector2(new_position.x,new_position.y))
	for i in range(0, amount_rampa):
		rampa.instantiate()
		var newRampa:Node3D = rampa.instantiate()
		$NavigationRegion3D/Blocos.add_child(newRampa)
		var new_position: Vector2 = _generatePosition() 
		newRampa.set_position(Vector3(new_position.x,0.5,new_position.y))
		newRampa.rotate_y(randi_range(-180,180))
		listPositions.append(Vector2(new_position.x,new_position.y))
	$NavigationRegion3D.bake_navigation_mesh()

func _generatePosition() -> Vector2:
	var x: int = randi_range(-45,45)
	var z: int = randi_range(-45,45)
	if listPositions.has(Vector2(x,z)):
		return _generatePosition()
	else:
		return Vector2(x,z)
