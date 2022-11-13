extends Spatial

const MusicClip = preload("res://native/MusicClip.gdns")
const Cassette = preload("res://scenes/objects/cassette/Cassette.gd")

onready var sample_sources = [$Input/Slot1,$Input/Slot2,$Input/Slot3,$Input/Slot4,$Input/Slot5,$Input/Slot6,$Input/Slot7,$Input/Slot8]
onready var players = [$Player1,$Player2,$Player3,$Player4,$Player5,$Player6,$Player7,$Player8]
var queued_samples = [null, null, null, null, null, null, null, null]
var pitch_scale = 1.0
var exact_beat = 0.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	var metronome_beat = $Metronome1.get_playback_position() * 100.0 / 60.0
	if fmod(exact_beat, 4.0) > metronome_beat + 2.0:
		exact_beat += 4.0
	exact_beat = exact_beat - fmod(exact_beat, 4.0) + metronome_beat
	for index in 8:
		if queued_samples[index] != null:
			queued_samples[index] += delta
			if queued_samples[index] >= 0.0 \
				&& quantized_play_offset() < quantized_play_snapping() / 2:
				queued_samples[index] = null
				actually_play_sample(index)

func actually_play_sample(index: int):
	var player: AudioStreamPlayer3D = players[index]
	player.stop()
	var c: Cassette = sample_sources[index].get_cassette()
	if c == null:
		return
	c.audio.play_audio(player)
	if index < 4:
		c.audio.set_looping($Sampler/LoopA.activated)
	else:
		c.audio.set_looping($Sampler/LoopB.activated)
	var offset = quantized_play_offset()
	var pitch = c.audio.beat_time() * tempo() / 60.0
	player.pitch_scale = pitch
	player.play(c.audio.start_time() \
		+ offset * c.audio.beat_time() / (60.0 / 100))
	var target = $Output.get_cassette()
	if target != null:
		var at = exact_beat - fmod(exact_beat, 1.0 / snapping_divisor())
		target.audio.write_sample(at, c.audio, 0.0, c.audio.beats(), pitch)

func fire_sample(index: int):
	queue_sample(index)

func queue_sample(index: int):
	if not $Metronome1.playing:
		$Sampler/PausePlay.activate()
	var c: Cassette = sample_sources[index].get_cassette()
	var offset = quantized_play_offset()
	if c == null:
		return
	if c.audio.is_looping() and players[index].is_playing():
		players[index].stop()
	elif offset > quantized_play_snapping() / 2:
		offset -= quantized_play_snapping()
		queued_samples[index] = offset
	else:
		actually_play_sample(index)
	
func insert_cassette(cassette):
	update_tempo()

func remove_cassette(cassette, index: int):
	var player: AudioStreamPlayer3D = players[index]
	player.stop()

func tempo():
	var tempo = $Sampler/TempoKnob.display_value
	tempo = pow(2, (tempo - 2) / 2) * 100.0
	return tempo

func snapping_divisor():
	var snapping = 1
	if tempo() < 90.0:
		snapping = 2
	if tempo() < 65.0:
		snapping = 6
	return snapping

# The time interval that button presses should be snapped to to make them in
# time with the beat selected by the user.
func quantized_play_snapping():
	return 60.0 / 100 / snapping_divisor()

# How far in we should skip from the start of a sample to make it sync up with
# the beat selected by the user.
func quantized_play_offset():
	var step = quantized_play_snapping()
	var offset = fmod($Metronome1.get_playback_position(), step)
	return offset

func update_tempo():
	var tempo = tempo()
	pitch_scale = tempo / 100.0
	$Metronome1.pitch_scale = pitch_scale
	var target = $Output.get_cassette()
	if target != null:
		target.audio.set_beat_time(60.0 / tempo)
	for index in 8:
		var c = sample_sources[index].get_cassette()
		var player = players[index]
		if c != null:
			player.pitch_scale = c.audio.beat_time() * tempo() / 60.0
		

func start_recording():
	update_tempo()
	$Metronome1.play()
	var target = $Output.get_cassette()
	exact_beat = 0.0
	if target != null:
		target.audio.clear()

func stop_recording():
	update_tempo()
	var target = $Output.get_cassette()
	if target != null:
		target.audio.extend(exact_beat - fmod(exact_beat, 4.0) + 4.0)
	if $Sampler/PausePlay.activated:
		$Sampler/PausePlay.deactivate()
	$Metronome1.stop()
	$Metronome1.seek(0.0)
	print($Metronome1.get_playback_position())
	for index in 8:
		players[index].stop()

func _on_TempoKnob_display_value_updated(new_display_value):
	update_tempo()
