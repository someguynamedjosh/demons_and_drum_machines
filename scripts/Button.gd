extends "res://scripts/Interactable.gd"

export var on_mat: Material
export var off_mat: Material

func on_press():
	set_surface_material(0, on_mat)
	
func on_release():
	set_surface_material(0, off_mat)
