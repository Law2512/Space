#Escudo.gd
class_name Escudo
extends Area2D

##Atributos Export
export var energia:float = 8.0
export var radioDesgaste:float = -1.6

##Atributos
var estaActivado:bool = false setget ,getEstaActivado

##Setters y Getters
func getEstaActivado() -> bool:
	return estaActivado
	
##Metodos
func _ready() -> void:
	set_process(false)
	controlarColisionador(true)

func _process(delta: float) -> void:
	energia += radioDesgaste * delta
	
	if energia <= 0.0:
		desactivar()

##Metodos Custom
func activar() -> void:
	if energia <= 0.0:
		return
	
	estaActivado = true
	controlarColisionador(false)
	$AnimationPlayer.play("activando")

func desactivar() -> void:
	set_process(false)
	estaActivado = false
	controlarColisionador(true)
	$AnimationPlayer.play_backwards("activando")

func controlarColisionador(estaDesactivado: bool) -> void:
	$CollisionShape2D.set_deferred("disabled", estaDesactivado)


##Señales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activando" and estaActivado:
		$AnimationPlayer.play("activado")
		set_process(true)


func _on_body_entered(body: Node) -> void:
	body.queue_free()
