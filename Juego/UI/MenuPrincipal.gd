#MenuPrincipal.gd
extends Node

export(String, FILE, "*.tscn") var nivelInicial = ""

func _ready() -> void:
	OS.set_window_fullscreen(true)
	OstJuego.playMusica(OstJuego.getListaMusicas().menuPrincipal)

##Conexion Seniales Internas
func _on_botonJugar_pressed() -> void:
	OstJuego.playBoton()
	get_tree().change_scene(nivelInicial)

func _on_botonSalir_pressed() -> void:
	get_tree().quit()
