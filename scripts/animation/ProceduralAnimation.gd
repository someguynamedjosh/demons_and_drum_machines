extends Reference

var target: Spatial
var time = 0.0
var started = false

func on_start():
	pass

func process(delta):
	if not started:
		on_start()
		started = true
	time += delta
	evaluate()

func evaluate():
	pass

func is_finished():
	return false
