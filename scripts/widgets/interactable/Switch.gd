extends "Activatable.gd"

func on_interact_start():
	if activated:
		deactivate()
	else:
		activate()
