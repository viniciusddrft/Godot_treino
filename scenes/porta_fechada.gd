extends MeshInstance3D

func _on_area_3d_body_entered(body:Node3D)->void:
	if(body is Player):
		print('passou')
		print(body)
		$AnimationPlayer.play('open')


func _on_area_3d_body_exited(body:Node3D)->void:
	if(body is Player):
		$AnimationPlayer.play('close')
