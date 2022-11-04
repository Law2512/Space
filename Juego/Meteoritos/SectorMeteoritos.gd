#SectorMeteoritos.gd
class_name SectorMeteoritos
extends Node2D

##Atributos Export

##Atributos
var spawners:Array
var cantidadMeteoritos:int = 10
var intervaloSpawn:float = 1.2

##Metodos
func _ready() -> void:
	$Timer.wait_time = intervaloSpawn
	almacenarSpawners()
	conectarSenialesDetectores()


##Metodos Custom
func conectarSenialesDetectores() -> void:
	for detector in $DetectorFueraZona.get_children():
		detector.connect("body_entered", self, "_on_detector_on_body_entered")

func almacenarSpawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)

func spawnerAleatorio() -> int:
	randomize()
	return randi() % spawners.size()

##Constructor
func crear(pos: Vector2, meteoritos: int) -> void:
	global_position = pos
	cantidadMeteoritos = meteoritos

##Señales internas
func _on_Timer_timeout() -> void:
	if cantidadMeteoritos == 0:
		$Timer.stop()
		return
	
	spawners[spawnerAleatorio()].spawnearMeteorito()
	cantidadMeteoritos -= 1

func _on_detector_on_body_entered(body: Node) -> void:
	body.setEstaEnSector(false)
