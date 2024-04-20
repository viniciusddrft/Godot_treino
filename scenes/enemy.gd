extends CharacterBody3D

var health = 10
const SPEED = 10.0
const ACCEl = 20.0
const JUMP_VELOCITY = 4.5
var buscar : bool = false
var posInicial : Vector3
var target = null

@onready var navigation: NavigationAgent3D = $NavigationAgent3D

func _ready():
	posInicial = global_position

func hitted() -> void:
	health -= 1
	if health <= 0:
		queue_free()

func _physics_process(delta:float) -> void:
	var direction = Vector3.ZERO
	if buscar:
		target = $"../Player"
		navigation.target_position = target.global_position
	else:
		navigation.target_position = posInicial
	direction = (navigation.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * SPEED, ACCEl * delta)
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body == $"../Player"):
		buscar = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body == $"../Player"):
		buscar = false
