extends Reference

# Do not instantiate this class directly. Use ExistingAudioSource or 
# CustomAudioSource instead.

func get_sample(sample: int) -> Vector2:
	return Vector2.ZERO

# Returns the length of the original audio source in samples.
func length() -> int:
	return 0
