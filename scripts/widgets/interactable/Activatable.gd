extends "Interactable.gd"

var activated: bool = false
signal activated()
signal deactivated()

func activate():
	if not activated:
		activated = true
		emit_signal("activated")

func deactivate():
	if activated:
		activated = false
		emit_signal("deactivated")
