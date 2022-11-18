#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

##Atributos Export
export var hitpoints:float = 30.0
export var enemigoOrbital:PackedScene = null
export var numOrbitales:int = 10
export var intervaloSpawn:float = 0.8

##Atributos Onready
onready var impactoSFX:AudioStreamPlayer2D = $ImpactoSFX
onready var timerSpawner:Timer = $TimerSpawnerEnemigo 
onready var barraSalud:ProgressBar = $Sprites/BarraSalud

##Atributos
var estaDestruida:bool = false
var posicionSpawn:Vector2 = Vector2.ZERO

##Metodos
func _ready() -> void:
	barraSalud.setValores(hitpoints)
	timerSpawner.wait_time = intervaloSpawn
	$AnimationPlayer.play(elegirAnimacionAleatoria())

##Metodos Custom
func recibirDanio(danio:float) -> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not estaDestruida:
		estaDestruida = true
		destruir()
	
	barraSalud.setHitpointsActual(hitpoints)
	impactoSFX.play()

func spawnearOrbital() -> void:
	numOrbitales -= 1
	$RutaEnemiga.global_position = global_position
	var posSpawn:Vector2 = deteccionCuadrante()
	
	var newOrbital:EnemigoOrbital = enemigoOrbital.instance()
	newOrbital.crear(
		global_position + posSpawn,
		self,
		$RutaEnemiga
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
			$RutaEnemiga.rotation_degrees = 270.0
			return $PosicionesSpawn/PositionSur.position
		else:
			#Player entra por arriba
			$RutaEnemiga.rotation_degrees = 90.0
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
	Eventos.emit_signal("minimapaObjetoDestruido", self)
	queue_free()

##Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	posicionSpawn = deteccionCuadrante()
	spawnearOrbital()
	timerSpawner.start()

func _on_TimerSpawnerEnemigo_timeout() -> void:
	if numOrbitales == 0:
		timerSpawner.stop()
		return
	spawnearOrbital()
