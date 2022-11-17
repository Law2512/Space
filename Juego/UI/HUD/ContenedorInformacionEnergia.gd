#ContenedorInformacionEnergia.gd
class_name ContenedorInformacionEnergia
extends ContenedorInformacion

##Atributos onready
onready var medidor:ProgressBar = $ProgressBar

##Metodos Custom
func actualizarEnergia(energiaMax: float, energiaActual: float) -> void:
	var energiaPorcentual:int = (energiaActual * 100) / energiaMax
	medidor.value = energiaPorcentual
