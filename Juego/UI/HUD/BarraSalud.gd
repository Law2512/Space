#BarraSalud.gd
class_name BarraSalud
extends ProgressBar

##Atributos Export
export var siempreVisible:bool = false

##Atributos Onready
onready var tweenVisible:Tween = $Tween

##Metodos
func _ready() -> void:
	modulate = Color(1, 1, 1, siempreVisible)

##Metodos Custom
func setHitpointsActual(hitpoints: float) -> void:
	value = hitpoints

func setValores(hitpoints: float) -> void:
	max_value = hitpoints
	value = hitpoints

func controlarBarra(hitpointsNave: float, mostrar: bool) -> void:
	value = hitpointsNave
	
	if not tweenVisible.is_active() and modulate.a != int(mostrar):
		tweenVisible.interpolate_property(
			self,
			"modulate",
			Color(1, 1, 1, not mostrar),
			Color(1, 1, 1, mostrar),
			1.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		
		tweenVisible.start()

func _on_Tween_tween_all_completed() -> void:
	if modulate.a == 1.0:
		controlarBarra(value, false)
