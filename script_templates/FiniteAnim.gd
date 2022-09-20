extends "res://scripts/animation/FiniteAnimation.gd"

func duration():
	return 1.0

func on_start():
	pass

func evaluate(target: Spatial):
	target.translation.x = progress()

func on_finish():
	pass
