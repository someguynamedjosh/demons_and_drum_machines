extends Spatial

const AudioContainer = preload("res://native/AudioContainer.gdns")

export var hovered_mat: Material
export var plain_mat: Material
var contained_in
export var initial_content: AudioStreamSample
var beat_duration: float = (1312981 - 1297775) / 44100.0 * 2.0
var beat_offset: float = fmod(1297710 / 44100.0 - 0.5 * beat_duration, beat_duration)
var audio: AudioContainer

func _ready():
	audio = AudioContainer.new()
	if initial_content != null:
		audio.load_sample_data(initial_content)

func on_hover_start():
	$Mesh.set_surface_material(0, hovered_mat)
	
func on_hover_end():
	$Mesh.set_surface_material(0, plain_mat)

func on_pick_up():
	pass
