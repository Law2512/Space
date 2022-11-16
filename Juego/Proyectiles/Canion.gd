#Canion.gd
class_name Canion
extends Node2D


##Atributos export
export var proyectil:PackedScene = null
export var cadenciaDisparo:float = 0.8
export var velocidadProyectil:int = 100
export var danioProyectil:int = 1

##Atributos onready
onready var timerEnfriamiento:Timer = $Enfriamiento
onready var disparoSFX:AudioStreamPlayer2D = $DisparosSFX
onready var estaEnfriado:bool = true
onready var estaDisparando:bool = false setget setEstaDisparando
onready var puedeDisparar:bool = false setget setPuedeDisparar

##Atributos
var puntosDisparo:Array = []

##Setters y Getters
func setEstaDisparando(disparando: bool) -> void:
	estaDisparando = disparando

func setPuedeDisparar(duenioPuede: bool) -> void:
	puedeDisparar = duenioPuede

##Metodos
func _ready() -> void:
	almacenarPuntosDisparo()
	timerEnfriamiento.wait_time = cadenciaDisparo

func _process(delta: float) -> void:
	if estaDisparando and estaEnfriado and puedeDisparar:
		disparar()

##Metodos Custom
func almacenarPuntosDisparo() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntosDisparo.append(nodo)

func disparar() -> void:
	estaEnfriado = false
	disparoSFX.play()
	timerEnfriamiento.start()
	for puntoDisparo in puntosDisparo:
		var newProyectil:Proyectil = proyectil.instance()
		newProyectil.crear(
			puntoDisparo.global_position,
			get_owner().rotation, velocidadProyectil,
			danioProyectil
		)
		Eventos.emit_signal("disparo", newProyectil)


func _on_Enfriamiento_timeout() -> void:
	estaEnfriado = true
