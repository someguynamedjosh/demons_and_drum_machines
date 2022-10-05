extends Reference

var snappiness: float = 0.0
var anim_progress = 0.0

func process(delta: float, forward: bool):
	var exponent = pow(2, snappiness)
	if forward:
		anim_progress = 1.0 - pow(1.0 - anim_progress, 1.0 / exponent)
		anim_progress = min(anim_progress + delta, 1.0)
		anim_progress = 1.0 - pow(1.0 - anim_progress, exponent)
	else:
		anim_progress = pow(anim_progress, 1.0 / exponent)
		anim_progress = max(anim_progress - delta, 0.0)
		anim_progress = pow(anim_progress, exponent)
	return anim_progress
