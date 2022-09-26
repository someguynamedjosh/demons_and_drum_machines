extends Spatial

const Cassette = preload("Cassette.gd")

var source_data: Array = []
var playback: AudioStreamGeneratorPlayback
var start_position = 64
var duration = 8
var playback_index = 0
var source: Cassette

# Called when the node enters the scene tree for the first time.
func _ready():
	playback = $Player.get_stream_playback()

func _process(delta):
	if playback_index >= position_to_index(start_position + duration) + 4410 \
		and $PlaybackSwitch.active:
		$PlaybackSwitch.on_interact_start()
	var should_play = $PlaybackSwitch.active and source != null
	if should_play:
		var empty_frames = playback.get_frames_available()
		while empty_frames > 0:
			playback.push_frame(source.audio_data[playback_index])
			playback_index += 1
			empty_frames -= 1
	if should_play and not $Player.playing:
		$Player.play()
	if not should_play and $Player.playing:
		$Player.stop()
		set_playback_position(start_position)
		$Player.stream = AudioStreamGenerator.new()
		$Player.stream.buffer_length = 0.1
		playback = $Player.get_stream_playback()

func position_to_index(position: float):
	if source == null:
		return 0
	else:
		return int(position * source.beat_duration + source.beat_offset)

func set_playback_position(position: float):
	if source != null:
		playback_index = position_to_index(position)

func _on_source_insert(new_source: Cassette):
	source = new_source
	set_playback_position(start_position)

func _on_source_removed(old_source: Cassette):
	source = null
