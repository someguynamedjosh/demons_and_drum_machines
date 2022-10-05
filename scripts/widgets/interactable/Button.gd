extends "Activatable.gd"

func on_interact_start():
	activate()
	
func on_interact_end():
	deactivate()
