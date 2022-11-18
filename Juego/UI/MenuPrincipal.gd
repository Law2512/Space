#MenuPrincipal.gd
extends Node

func _ready() -> void:
	OstJuego.playMusica(OstJuego.getListaMusicas().menuPrincipal)

func _on_botonJugar_pressed() -> void:
	OstJuego.playBoton()
	get_tree().change_scene("res://Juego/Niveles/NivelTest.tscn")
