#OSTJuego.gd
extends Node

##Atributos Export
export var tiempoTransicion:float = 4.0
export(float, -50.0, -20.0, 5.0) var volumenApagado = -40.0

##Atributos Onready
onready var musicaNivel:AudioStreamPlayer = $MusicaNivel
onready var musicaCombate:AudioStreamPlayer = $MusicaCombate 
onready var listaMusicas:Dictionary = {"menuPrincipal": $MusicaMenu} setget , getListaMusicas

onready var tweenON:Tween = $TweenMusicaON
onready var tweenOFF:Tween = $TweenMusicaOFF

##Atributos
var volOriginalMusicaOFF:float = 0.0

##Setters y Getters
func getListaMusicas() -> Dictionary:
	return listaMusicas

##Metodos Custom
func playMusica(musica: AudioStreamPlayer) -> void:
	stopTodo()
	musica.play()

func playBoton() -> void:
	$MusicaBoton.play()

func transicionMusicas() -> void:
	if musicaNivel.playing:
		fadeIN(musicaCombate)
		fadeOUT(musicaNivel)
	else:
		fadeIN(musicaNivel)
		fadeOUT(musicaCombate)

func fadeIN(musicaFadeIn: AudioStreamPlayer) -> void:
	var volumenOriginal = musicaFadeIn.volume_db
	musicaFadeIn.volume_db = volumenApagado
	musicaFadeIn.play()
	tweenON.interpolate_property(
		musicaFadeIn,
		"volume_db",
		volumenApagado,
		volumenOriginal,
		tiempoTransicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tweenON.start()

func fadeOUT(musicaFadeOut: AudioStreamPlayer) -> void:
	volOriginalMusicaOFF = musicaFadeOut.volume_db
	tweenOFF.interpolate_property(
		musicaFadeOut,
		"volume_db",
		musicaFadeOut.volume_db,
		volumenApagado,
		tiempoTransicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tweenOFF.start()

func setStreams(streamMusica: AudioStream, streamCombate: AudioStream) -> void:
	musicaNivel.stream = streamMusica
	musicaCombate.stream = streamCombate

func playMusicaNivel() -> void:
	stopTodo()
	musicaNivel.play()

func stopTodo() -> void:
	for nodo in get_children():
		if nodo is AudioStreamPlayer:
			nodo.stop()

##Conexion Seniales internas
func _on_TweenMusicaOFF_tween_completed(object: Object, _key: NodePath) -> void:
	object.stop()
	object.volume_db = volOriginalMusicaOFF
