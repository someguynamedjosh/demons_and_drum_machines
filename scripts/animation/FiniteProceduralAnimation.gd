extends "res://scripts/animation/ProceduralAnimation.gd"

var finished = false

func duration():
	return 1.0

func progress():
	return min(time / duration(), 1.0)

func is_finished():
	return finished

func process(delta):
	handle_start()
	time += delta
	evaluate()
	return handle_finish()

func handle_start():
	if not started:
		on_start()
		started = true

func evaluate():
	pass

func handle_finish():
	if not finished and progress() == 1.0:
		finished = true
		return on_finish()

func on_finish():
	pass
