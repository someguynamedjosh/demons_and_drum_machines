extends Spatial

const Cassette = preload("Cassette.gd")

var source_data: Array = []
var playback: AudioStreamPlayback
var playback_index = 0
var source: Cassette

# Called when the node enters the scene tree for the first time.
func _ready():
	playback = $Player.get_stream_playback()

func _process(delta):
	if source != null:
		var empty_frames = playback.get_frames_available()
		while empty_frames > 0:
			playback.push_frame(source.audio_data[playback_index])
			playback_index += 1
			empty_frames -= 1

func _on_source_insert(new_source: Cassette):
	source = new_source
	print(source.audio_data[10000])
	$Player.play()
