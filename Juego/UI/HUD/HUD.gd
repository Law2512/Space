#HUD.gd
extends CanvasLayer

##Atributos Onready
onready var infoZonaRecarga:ContenedorInformacion = $InfoZonaRecarga
onready var infoMeteoritos:ContenedorInformacion = $InfoMeteoritos
onready var infoTiempoRestante:ContenedorInformacion = $InfoTiempoRestante
onready var infoLaser:ContenedorInformacionEnergia = $InfoLaser
onready var infoEscudo:ContenedorInformacionEnergia = $InfoEscudo

##Metodos
func _ready() -> void:
	conectarSeniales()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("nivelIniciado", self, "fadeOUT")
	Eventos.connect("nivelTerminado", self, "fadeIN")
	Eventos.connect("detectorZonaRecarga", self, "_on_detectorZonaRecarga")
	Eventos.connect("cambioNumeroMeteoritos", self, "_on_cambioNumeroMeteoritos")
	Eventos.connect("actualizarTiempo", self, "_on_actualizarTiempo")
	Eventos.connect("cambioEnergiaLaser", self, "_on_cambioEnergiaLaser")
	Eventos.connect("ocultarEnergiaLaser", infoLaser, "ocultarSuavizado")
	Eventos.connect("cambioEnergiaEscudo", self, "_on_cambioEnergiaEscudo")
	Eventos.connect("ocultarEnergiaEscudo", infoEscudo, "ocultarSuavizado")
	Eventos.connect("nave_destruida", self, "_on_naveDestruida")

func fadeIN() -> void:
	$FadeCanvas/AnimationPlayer.play("fadeIN")

func fadeOUT() -> void:
	$FadeCanvas/AnimationPlayer.play_backwards("fadeIN")

##Conexion Seniales Externas
func _on_naveDestruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		get_tree().call_group("contenedorInfo", "setEstaActivado", false)
		get_tree().call_group("contenedorInfo", "ocultar")

func _on_cambioEnergiaEscudo(energiaMax: float, energiaActual: float) -> void:
	infoEscudo.mostrar()
	infoEscudo.actualizarEnergia(energiaMax, energiaActual)

func _on_cambioEnergiaLaser(energiaMax: float, energiaActual: float) -> void:
	infoLaser.mostrar()
	infoLaser.actualizarEnergia(energiaMax, energiaActual)

func _on_detectorZonaRecarga(enZona: bool) -> void:
	if enZona:
		infoZonaRecarga.mostrarSuavizado()
	else:
		infoZonaRecarga.ocultarSuavizado()

func _on_cambioNumeroMeteoritos(numero: int) -> void:
	infoMeteoritos.mostrarSuavizado()
	infoMeteoritos.modificarTexto(
		"Meteoritos Restantes\n {cantidad}".format({"cantidad": numero})
	)

func _on_actualizarTiempo(tiempo: int) -> void:
	var minutos:int = floor(tiempo * 0.1666666666667)
	var segundos:int = tiempo % 60
	infoTiempoRestante.modificarTexto(
		"Tiempo restante\n%02d:%02d" % [minutos, segundos]
	)
	
	if tiempo % 10 == 0:
		infoTiempoRestante.mostrarSuavizado()
	
	if tiempo == 11:
		infoTiempoRestante.setAutoOcultar(false)
	elif tiempo == 0:
		infoTiempoRestante.ocultar()
