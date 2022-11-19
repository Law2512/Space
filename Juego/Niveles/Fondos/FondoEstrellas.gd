#FondoEstrellas.gd
tool
extends ParallaxBackground

##Atributos Export
export var colorFondo:Color = Color.black

func _ready() -> void:
	$ColorRect.color = colorFondo

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		$ColorRect.color = colorFondo
