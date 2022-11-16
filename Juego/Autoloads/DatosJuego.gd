#DatosJuego.gd
extends Node

##Atributos
var playerActual:Player = null setget setPlayerActual, getPlayerActual

##Setters y Getters
func setPlayerActual(player: Player) -> void:
	playerActual = player

func getPlayerActual() -> Player:
	return playerActual

##Metodos
func _ready() -> void:
	Eventos.connect("nave_destruida", self, "_on_naveDestruida")

func _on_naveDestruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		playerActual = null
