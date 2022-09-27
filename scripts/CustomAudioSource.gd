extends "res://scripts/AudioSource.gd"

var buffer: PoolVector2Array = PoolVector2Array([])

func get_samples(start: int, length: int) -> PoolVector2Array:
	return buffer

# Returns the length of the original audio source in samples.
func length() -> int:
	return buffer.size()
