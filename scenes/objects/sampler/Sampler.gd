extends Spatial

const MusicClip = preload("res://native/MusicClip.gdns")
const Cassette = preload("res://scenes/objects/cassette/Cassette.gd")

onready var sample_sources = [$Input/Slot1,$Input/Slot2,$Input/Slot3,$Input/Slot4,$Input/Slot5,$Input/Slot6,$Input/Slot7,$Input/Slot8]
onready var players = [$Player1,$Player2,$Player3,$Player4,$Player5,$Player6,$Player7,$Player8]
var queued_samples = [null, null, null, null, null, null, null, null]
var pitch_scale = 1.0

func _ready():
	pass # Replace with function body.

func _process(delta):
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
	player.pitch_scale = c.audio.beat_time() * tempo() / 60.0
	player.play(c.audio.start_time() \
		+ offset * c.audio.beat_time() / (60.0 / 100))

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

# The time interval that button presses should be snapped to to make them in
# time with the beat selected by the user.
func quantized_play_snapping():
	var snapping = 1
	if tempo() < 90.0:
		snapping = 2
	if tempo() < 65.0:
		snapping = 6
	return 60.0 / 100 / snapping


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
	for index in 8:
		var c = sample_sources[index].get_cassette()
		var player = players[index]
		if c != null:
			player.pitch_scale = c.audio.beat_time() * tempo() / 60.0
		

func start_recording():
	update_tempo()
	$Metronome1.play()

func stop_recording():
	$Metronome1.stop()
	for index in 8:
		players[index].stop()

func _on_TempoKnob_display_value_updated(new_display_value):
	update_tempo()
