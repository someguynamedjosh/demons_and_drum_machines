extends "res://scripts/widgets/movable/Movable.gd"

const MusicClip = preload("res://native/MusicClip.gdns")

export var initial_audio: Resource#: ProvidedMusicClip#, actual annotation gives a segfault and cannot be exported.
var audio = null
var spin: bool = false
var speed: float = 0.0

func _init():
	pass

func _ready():
	if initial_audio != null:
		audio = initial_audio.as_music_clip()
		print(audio.beats())
	else:
		audio = MusicClip.new()
	if $Mesh.get_surface_material_count() == 3:
		var mat = $Mesh.get_surface_material(1)
		var mat2 = mat.duplicate()
		mat2.set_shader_param("Distress", rand_range(0.2, 1.0))
		mat2.set_shader_param("Offset", Vector2(rand_range(0.0, 1.0), rand_range(0.0, 1.0)))
		# "ItS nOt UnIfOrMlY dIsTrIbUtEd" literally no one will notice
		mat2.set_shader_param("Variant", randi() % 3)
		$Mesh.set_surface_material(1, mat2)

func _process(delta):
	var max_speed = 3.0
	var acceleration = 8.0
	if spin and contained_in != null:
		speed = min(speed + acceleration * delta, max_speed)
	else:
		speed = max(speed - acceleration * delta, 0.0)
	$LeftSpool.rotation.y += delta * speed
	$RightSpool.rotation.y += delta * speed
