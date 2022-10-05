extends "Activatable.gd"

func on_interact_start():
	if active:
		deactivate()
	else:
		activate()
