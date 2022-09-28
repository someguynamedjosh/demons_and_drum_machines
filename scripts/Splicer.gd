extends Spatial

const Cassette = preload("Cassette.gd")

export var screen_mat: ShaderMaterial
var source_data: Array = []
var last_start_beat = 64

func _process(_delta):
	update_knob_limits()
	update_screen()
	stop_if_past_end()
	var should_play = $PlaybackSwitch.active and source() != null
	if should_play and not $Player.playing:
		play()
	if not should_play and $Player.playing:
		stop()
	animate_cassettes()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func snapping():
	if $DurationKnob.get_target_value() >= 8.125:
		return 0.5
	else:
		return 0.25

func snap(value):
	return round(value / snapping()) * snapping()

func source() -> Cassette:
	return $InputSlot.holding

func source_beats() -> float:
	if source() != null:
		return source().audio.beats()
	else:
		return 9e9

func source_duration() -> float:
	if source() != null:
		return source().audio.duration()
	else:
		return 0.0

func animate_cassettes():
	var spin = $PlaybackSwitch.active
	if $InputSlot.holding != null:
		$InputSlot.holding.spin = spin
	if $OutputSlot.holding != null:
		$OutputSlot.holding.spin = spin

func update_knob_limits():
	$StartKnob.set_range(0.0, source_beats() - 0.25)
	$StartKnob.set_snapping(snapping())
	$DurationKnob.set_range(0.25, min(source_beats() - $StartKnob.get_display_value(), 16.0))
	$DurationKnob.set_snapping(snapping())

func update_screen():
	screen_mat.set_shader_param("Start", snap($StartKnob.get_display_value()))
	screen_mat.set_shader_param("Duration", snap($DurationKnob.get_display_value()))

func stop():
	var end = position_to_beat($Player.get_playback_position())
	var exact_end = last_start_beat + $DurationKnob.get_target_value()
	if abs(beat_to_position(end) - beat_to_position(exact_end)) <= 0.1:
		print(last_start_beat, ' Full!')
		end = exact_end
	if $InputSlot.holding != null and $OutputSlot.holding != null:
		$OutputSlot.holding.audio = $InputSlot.holding.audio.trim(last_start_beat, end)
	$Player.stop()
	$Player.seek(0.0)
	$PlaybackSwitch.deactivate()

func stop_if_past_end():
	var end = beat_to_position(last_start_beat + $DurationKnob.get_target_value())
	# Stop it slightly early so we don't overshoot and play part of the next
	# beat, which will not show up in the recording.
	var buffer = 0.1
	if $DurationKnob.get_target_value() < 1.0:
		buffer = 0.05
	var past_end = $Player.get_playback_position() >= min(end, source_duration()) - buffer
	if past_end and $PlaybackSwitch.active:
		stop()

func play():
	source().audio.play_audio($Player)
	last_start_beat = $StartKnob.get_target_value()
	$Player.play(beat_to_position(last_start_beat))

func beat_to_position(beat: float):
	if source() == null:
		return 0
	else:
		return beat * source().audio.beat_time() + source().audio.start_time()

func position_to_beat(position: float):
	if source() == null:
		return 0
	else:
		return (position - source().audio.start_time()) / source().audio.beat_time()

func _on_source_insert(_new_source):
	$StartKnob.set_animated(0.0)
