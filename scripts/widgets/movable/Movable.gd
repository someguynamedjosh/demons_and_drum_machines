extends "../Hoverable.gd"

const Slot = preload("res://scripts/widgets/slot/Slot.gd")

signal picked_up()
signal put_down()
signal inserted(slot)
signal removed(slot)

var contained_in: Slot

func on_pick_up():
	emit_signal("picked_up")

func on_put_down():
	emit_signal("put_down")

func on_insert_start(slot: Slot):
	contained_in = slot
	emit_signal("inserted", slot)

func on_insert_end():
	pass

func on_remove():
	emit_signal("removed", contained_in)
	contained_in = null
