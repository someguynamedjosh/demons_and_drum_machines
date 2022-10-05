extends Reference

var snappiness: float = 1.0
var was_forward: bool = false
var anim_progress = 0.0

func process(delta: float, forward: bool):
	var exponent = pow(2, -snappiness)
	anim_progress = 1.0 - pow(1.0 - anim_progress, 1.0 / exponent)
	anim_progress = min(anim_progress + delta, 1.0)
	anim_progress = 1.0 - pow(1.0 - anim_progress, exponent)
	if was_forward != forward:
		anim_progress = 1.0 - anim_progress
		was_forward = forward
	if forward:
		return anim_progress
	else:
		return 1.0 - anim_progress
