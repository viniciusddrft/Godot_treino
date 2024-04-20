class_name Dinossauro

extends CharacterBody3D

var health = 10
const SPEED = 8.0
const ACCEl = 20.0
const JUMP_VELOCITY = 4.5
var buscar : bool = false
var die : bool = false
var dieAnimationDone: bool = false
var canAttack: bool = false
var posInicial : Vector3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var player = $"../Player"
@onready var navigation: NavigationAgent3D = $NavigationAgent3D


func _ready():
	posInicial = global_position

func hitted() -> void:
	health -= 1
	if health <= 0:
		die = true

func _physics_process(delta:float) -> void:
	var direction = Vector3.ZERO
	velocity.y -= 20 * delta
	if not is_on_floor():
		velocity.y -= gravity * delta
	if buscar:
		navigation.target_position = player.global_position
	else:
		navigation.target_position = posInicial
	direction = (navigation.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * SPEED, ACCEl * delta)
	
	
	if !canAttack and !die:
		if velocity.z > 1.5 or velocity.z < -1.5 or velocity.x > 1.5 or velocity.x < -1.5:
			$AnimationPlayer.play('running')
		else:
			$AnimationPlayer.play('idle')
	else:
		if !die:
			$AnimationPlayer.play('attack')
			canAttack = false
		else:
			if not dieAnimationDone:
				$AnimationPlayer.play('die')

	if !die:
		if buscar:
			rotation.y = lerp_angle(rotation.y, atan2(velocity.x,velocity.z),delta * 4)
		else:
			if abs(global_position.z - posInicial.z) > 0.05:
				rotation.y = lerp_angle(posInicial.y, atan2(velocity.x,velocity.z),delta * 2)
	in_attack()
	if !canAttack and !die:
		move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body == $"../Player"):
		buscar = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body == $"../Player"):
		buscar = false

func in_attack():
	if global_position.distance_to(player.global_position) < 4:
		canAttack = true


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == 'die'):
		dieAnimationDone = true


func _on_area_3d_body_entered_attack(body)->void:
	if body is Player and $AnimationPlayer.current_animation == 'attack':
		body.player_hit()
