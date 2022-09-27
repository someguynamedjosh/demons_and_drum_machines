extends Spatial

const AudioSource = preload("AudioSource.gd")
const CustomAudioSource = preload("CustomAudioSource.gd")
const ExistingAudioSource = preload("ExistingAudioSource.gd")

export var hovered_mat: Material
export var plain_mat: Material
var contained_in
export var initial_content: AudioStreamSample
var beat_duration: int = 1312989 - 1297775
var beat_offset: int = 1297775 % beat_duration
var audio: AudioSource

func _ready():
	if initial_content == null:
		audio = CustomAudioSource.new()
	else:
		audio = ExistingAudioSource.new(initial_content)

func on_hover_start():
	$Mesh.set_surface_material(0, hovered_mat)
	
func on_hover_end():
	$Mesh.set_surface_material(0, plain_mat)

func on_pick_up():
	pass
