#Proyectil.gd
class_name Proyectil
extends Area2D

##Atributos
var velocidad:Vector2 = Vector2.ZERO
var danio:float = 1.0

##Metodos
func _physics_process(delta: float) -> void:
	position += velocidad * delta 

func crear(pos: Vector2, dir: float, vel: float, danioP: int) -> void:
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)

##Metodos Custom
func daniar(otroCuerpo: CollisionObject2D) -> void:
	if otroCuerpo.has_method("recibirDanio"):
		otroCuerpo.recibirDanio(danio)
	
	queue_free()

##Señales internas
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	daniar(area)

func _on_body_entered(body: Node) -> void:
	daniar(body)
