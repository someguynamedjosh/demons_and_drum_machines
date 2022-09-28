extends Spatial

const MusicBuffer = preload("res://native/MusicBuffer.gdns")

export var hovered_mat: Material
export var plain_mat: Material
var contained_in
export var initial_content: Resource
var audio#: MusicBuffer#, actual annotation gives a segfault.

func _ready():
	audio = MusicBuffer.new()
	if initial_content != null:
		audio.load_sample_data(initial_content)
		audio = audio.trim(32.0, 48.0)
		print(audio.duration())

func on_hover_start():
	$Mesh.set_surface_material(0, hovered_mat)
	
func on_hover_end():
	$Mesh.set_surface_material(0, plain_mat)

func on_pick_up():
	pass
