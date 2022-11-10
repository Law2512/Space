#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

##Atributos Export
export var hitpoints:float = 30.0

##Atributos Onready
onready var impactoSFX:AudioStreamPlayer2D = $ImpactoSFX

##Atributos
var estaDestruida:bool = false

##Metodos
func _ready() -> void:
	$AnimationPlayer.play(elegirAnimacionAleatoria())

##Metodos Custom
func recibirDanio(danio:float) -> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not estaDestruida:
		estaDestruida = true
		destruir()
	
	impactoSFX.play()

func elegirAnimacionAleatoria() -> String:
	randomize()
	var numAnim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indiceAnimAleatoria:int = randi() % numAnim + 1
	var listaAnimacion:Array = $AnimationPlayer.get_animation_list()
	
	return listaAnimacion[indiceAnimAleatoria]

func destruir() -> void:
	var posicionPartes = [
		$Sprites/Sprite.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite4.global_position
	]
	
	Eventos.emit_signal("baseDestruida", posicionPartes)
	queue_free()

##Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
