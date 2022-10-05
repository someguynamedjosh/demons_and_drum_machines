extends "res://scripts/animation/ProceduralAnimation.gd"

func duration():
	return 1.0

func progress():
	return min(time / duration(), 1.0)

func is_finished():
	return progress() == 1.0

func evaluate():
	pass

func on_finish():
	pass
