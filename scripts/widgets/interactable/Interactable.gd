extends "../Hoverable.gd"

var interacting = false

signal interact_started()
signal interact_ended()

func on_interact_move(delta: Vector2):
	pass

func captures_cursor() -> bool:
	return false

func on_interact_start():
	interacting = true
	emit_signal("interact_started")

func on_interact_end():
	interacting = false
	emit_signal("interact_ended")
