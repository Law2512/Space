#ReleMasa.gd
class_name ReleMasa
extends Node2D

##Metodos Custom
func atraerPlayer(body: Node) -> void:
	$Tween.interpolate_property(
		body,
		"global_position",
		body.global_position,
		global_position,
		1.0,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	
	$Tween.start()

##Señales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		$AnimationPlayer.play("activada")
		$DetectorPlayer/CollisionShape2D.set_deferred("disabled", false)

func _on_DetectorPlayer_body_entered(body: Node) -> void:
	$DetectorPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("superActivada")
	body.desactivarControl()
	atraerPlayer(body)


func _on_Tween_tween_all_completed() -> void:
	print("bien hecho cabron, alguien traigame unas alitas de pollo con fruta wey, cuchau, 441122 medios y estrategias")
