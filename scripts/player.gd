class_name Player
extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const pre_blood:Resource = preload('res://scenes/particles_3d.tscn')
@onready var camera : Camera3D = $Camera3D
@onready var flash : GPUParticles3D = $Camera3D/armas/GPUParticles3D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var rayCast : RayCast3D = $Camera3D/RayCast3D
var health:int=3
var hit:bool=false


func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta:float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	_controll_animation_player(input_dir)
	if(health > 0):
		move_and_slide()

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == 'shoot':
		animation.stop()
	elif anim_name == 'damage':
		hit = false

func _controll_animation_player(input_dir: Vector2)->void:
	if Input.is_action_just_pressed("shoot"):
		animation.stop()
		animation.play('shoot')
		flash.restart()
		if rayCast.is_colliding():
			var collider : Object = rayCast.get_collider()
			if (collider.has_method('hitted')):
				collider.hitted()
				var blood = pre_blood.instantiate()
				camera.add_child(blood)
				blood.global_position = rayCast.get_collision_point()
				blood.emitting = true
			else:
				if collider.get_parent().get_parent().get_parent() != null:
					var parent_collider = collider.get_parent().get_parent().get_parent().get_parent()
					if collider.get_class() == 'Area3D' and parent_collider and parent_collider.has_method('hitted'):
						collider.get_parent().get_parent().get_parent().get_parent().hitted()
						var blood = pre_blood.instantiate()
						camera.add_child(blood)
						blood.global_position = rayCast.get_collision_point()
						blood.emitting = true

	elif Input.is_action_just_pressed("mira"):
		animation.stop()
		animation.play('mira')
	elif input_dir != Vector2.ZERO:
		if input_dir and is_on_floor():
			animation.play('walk')
		else:
			animation.play('idle')
	elif animation.current_animation != 'shoot' and animation.current_animation != 'mira':
		if input_dir and is_on_floor():
			animation.play('walk')
		else:
			animation.play('idle')

func player_hit():
	health -= 1
	hit = true
	if health < 1:
		get_tree().reload_current_scene()
	else:
		$AnimationPlayer.stop()
		$AnimationPlayer.play('damage')
