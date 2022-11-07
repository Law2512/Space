#EnemigoBase.gd
class_name EnemigoBase
extends NaveBase

##Metodos
func _ready() -> void:
	canion.setEstaDisparando(true)

##Señales Internas
func _on_body_entered(body: Node) -> void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir() 
