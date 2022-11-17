# Casts a laser along a raycast, emitting particles on the impact point.
# Use `is_casting` to make the laser fire and stop.
# You can attach it to a weapon or a ship; the laser will rotate with its parent.
#LaserBeam2D.gd
class_name RayoLaser
extends RayCast2D

export var cast_speed := 7000.0
export var max_length := 1400.0
export var growth_time := 0.1
##Custom
export var radioDanio:float = 4.0
export var energia:float = 4.0
export var radioDesgaste:float = -1.0

# If `true`, the laser is firing.
# It plays appearing and disappearing animations when it's not animating.
# See `appear()` and `disappear()` for more information.
var is_casting := false setget set_is_casting
var energiaOriginal:float

onready var fill := $FillLine2D
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D
onready var laserSFX: AudioStreamPlayer2D = $LaserSFX
onready var line_width: float = fill.width


func _ready() -> void:
	energiaOriginal = energia
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO


func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam(delta)


func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		laserSFX.play() #Ejecuta el sonido 
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		Eventos.emit_signal("ocultarEnergiaLaser")
		laserSFX.stop() #Si se suelta se detiene el sonido
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting


# Controls the emission of particles and extends the Line2D to `cast_to` or the ray's 
# collision point, whichever is closest.
func cast_beam(delta: float) -> void:
	if energia <= 0.0:
		print("SIN ENERGIA")
		set_is_casting(false)
		return
	
	controlarEnergia(radioDesgaste * delta)
	
	var cast_point := cast_to
	
	energia += radioDesgaste * delta
	
	force_raycast_update()
	collision_particles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		if get_collider().has_method("recibirDanio"):
			get_collider().recibirDanio(radioDanio * delta)

	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func controlarEnergia(consumo: float) -> void:
	energia += consumo
	if energia > energiaOriginal:
		energia = energiaOriginal
	
	Eventos.emit_signal("cambioEnergiaLaser", energiaOriginal, energia)

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()


func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
