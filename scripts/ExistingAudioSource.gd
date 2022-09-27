extends "res://scripts/AudioSource.gd"

var original_audio: AudioStreamSample

func _init(o: AudioStreamSample):
	assert(o != null)
	original_audio = o

func decode_16_bit_sample(byte1, byte2):
	if byte2 >= 128:
		byte2 -= 256
	return byte2 / 256.0 + byte1 / 65536.0

func get_sample(sample: int) -> Vector2:
	var index = sample * 4 + 44
	var data = original_audio.data
	var left = decode_16_bit_sample(data[index], data[index + 1])
	var right = decode_16_bit_sample(data[index + 2], data[index + 3])
	return Vector2(left, right)

# Returns the length of the original audio source in samples.
func length() -> int:
	return (original_audio.data.size() - 44) / 4
