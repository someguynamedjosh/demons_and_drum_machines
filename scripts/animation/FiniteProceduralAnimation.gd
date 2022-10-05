extends "res://scripts/animation/ProceduralAnimation.gd"

func snappiness():
	return -1.0

func duration():
	return 0.5

func progress():
	var exponent = pow(2, -snappiness())
	return 1.0 - pow(1.0 - min(time / duration(), 1.0), exponent)

func is_finished():
	return progress() == 1.0

func evaluate():
	pass

func on_finish():
	pass
