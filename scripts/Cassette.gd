extends Spatial

const MusicClip = preload("res://native/MusicClip.gdns")

export var hovered_mat: Material
var contained_in
export var audio: Resource#: MusicBuffer#, actual annotation gives a segfault and cannot be exported.
var spin: bool = false
var speed: float = 0.0

func _init():
	if audio == null:
		audio = MusicClip.new()

func _ready():
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

func on_hover_start():
	$Mesh.material_override = hovered_mat
	
func on_hover_end():
	$Mesh.material_override = null

func on_pick_up():
	pass
