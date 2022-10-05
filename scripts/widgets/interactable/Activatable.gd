extends "Interactable.gd"

var active: bool = false
signal activated()
signal deactivated()

func activate():
	if not active:
		active = true
		emit_signal("activated")

func deactivate():
	if active:
		active = false
		emit_signal("deactivated")
