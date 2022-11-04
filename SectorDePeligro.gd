#SectorDePeligro.gd
extends Area2D

##Atributos export
export(String, "vacio", "Meteorito", "Enemigo") var tipoPeligro
export var numeroPeligros:int = 10

##Señales
func _on_body_entered(_body: Node) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.1), "timeout")
	enviarSenial()

func enviarSenial() -> void:
	Eventos.emit_signal("naveSectorPeligro", $PositionCentroSector.global_position, tipoPeligro, numeroPeligros)
	queue_free()
