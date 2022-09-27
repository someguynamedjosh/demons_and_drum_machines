extends Spatial

const Cassette = preload("Cassette.gd")

export var screen_mat: ShaderMaterial
var source_data: Array = []
var last_start_beat = 64
var source: Cassette

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func quantization():
	if $DurationKnob.value >= 8.125:
		return 2.0
	else:
		return 4.0

func start_beat():
	var q = quantization()
	return round(q * $StartKnob.value) / q

func duration():
	var q = quantization()
	return round(q * $DurationKnob.value) / q

func _process(_delta):
	if start_beat() < 0.0:
		$StartKnob.value = 0.0
	var source_duration = 100.0
	if start_beat() > source_duration:
		$StartKnob.value = source_duration
	if duration() < 0.25:
		$DurationKnob.value = 0.25
	if duration() > 16.0:
		$DurationKnob.value = 16.0
	screen_mat.set_shader_param("Duration", duration())
	screen_mat.set_shader_param("Start", start_beat())
	var end = beat_to_position(last_start_beat + duration())
	var past_end = $Player.get_playback_position() >= end
	if past_end and $PlaybackSwitch.active and $Player.playing:
		$PlaybackSwitch.on_interact_start()
	var should_play = $PlaybackSwitch.active and source != null
	if should_play and not $Player.playing:
		source.audio.play_audio($Player)
		last_start_beat = start_beat()
		$Player.play(beat_to_position(last_start_beat))
	if not should_play and $Player.playing:
		$Player.stop()

func beat_to_position(beat: float):
	if source == null:
		return 0
	else:
		return beat * source.beat_duration + source.beat_offset

func _on_source_insert(new_source: Cassette):
	source = new_source

func _on_source_removed(_old_source: Cassette):
	source = null
