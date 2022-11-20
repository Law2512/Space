#ExplosionMeteorito.gd
class_name ExplosionMeteorito
extends Node2D

func _ready() -> void:
	$AnimationPlayer.play(elegirExplosionAleatoria())

func elegirExplosionAleatoria() -> String:
	randomize()
	var numAnim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indiceAnimAleatoria:int = randi() % numAnim 
	var listaAnimacion:Array = $AnimationPlayer.get_animation_list()
	
	return listaAnimacion[indiceAnimAleatoria]

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
