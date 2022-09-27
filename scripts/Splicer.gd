extends Spatial

const Cassette = preload("Cassette.gd")

var source_data: Array = []
var start_beat = 128
var duration = 4
var source: Cassette

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var end = beat_to_position(start_beat + duration)
	var past_end = $Player.get_playback_position() >= end
	if past_end and $PlaybackSwitch.active and $Player.playing:
		$PlaybackSwitch.on_interact_start()
	var should_play = $PlaybackSwitch.active and source != null
	if should_play and not $Player.playing:
		source.audio.play_audio($Player)
		$Player.play(beat_to_position(start_beat))
	if not should_play and $Player.playing:
		$Player.stop()

func beat_to_position(beat: float):
	if source == null:
		return 0
	else:
		return beat * source.beat_duration + source.beat_offset

func _on_source_insert(new_source: Cassette):
	source = new_source

func _on_source_removed(old_source: Cassette):
	source = null
