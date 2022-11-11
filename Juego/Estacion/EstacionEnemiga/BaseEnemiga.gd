#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

##Atributos Export
export var hitpoints:float = 30.0
export var enemigoOrbital:PackedScene = null

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

func spawnearOrbital() -> void:
	var posSpawn:Vector2 = deteccionCuadrante()
	
	var newOrbital:EnemigoOrbital = enemigoOrbital.instance()
	newOrbital.crear(
		global_position + posSpawn,
		self
	)
	
	Eventos.emit_signal("spawnOrbital", newOrbital)

func deteccionCuadrante() -> Vector2:
	var playerObjetivo:Player = DatosJuego.getPlayerActual()
	
	if not playerObjetivo:
		return Vector2.ZERO
	
	var dirPlayer:Vector2 = playerObjetivo.global_position - global_position
	var anguloPlayer:float = rad2deg(dirPlayer.angle())
	
	if abs(anguloPlayer) <= 45.0:
		#Player entra por la izquierda
		return $PosicionesSpawn/PositionOeste.position
	elif abs(anguloPlayer) > 135.0 and abs(anguloPlayer) <= 180.0:
		#Player entra por la derecha
		return $PosicionesSpawn/PositionEste.position
	elif abs(anguloPlayer) > 45.0 and abs(anguloPlayer) <= 135.0:
		#Player entra por arriba o por abajo
		if sign(anguloPlayer) > 0:
			#Player entra por abajo
			return $PosicionesSpawn/PositionSur.position
		else:
			#Player entra por arriba
			return $PosicionesSpawn/PositionNorte.position
	
	return $PosicionesSpawn/Norte.position

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
	
	Eventos.emit_signal("baseDestruida", self, posicionPartes)
	queue_free()

##Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	spawnearOrbital()

