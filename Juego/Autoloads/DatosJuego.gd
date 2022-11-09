#DatosJuego.gd
extends Node

##Atributos
var playerActual:Player = null setget setPlayerActual, getPlayerActual

##Setters y Getters
func setPlayerActual(player: Player) -> void:
	playerActual = player

func getPlayerActual() -> Player:
	return playerActual
