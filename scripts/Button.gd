extends MeshInstance

export var on_mat: Material
export var off_mat: Material

func on_interact_start():
	set_surface_material(0, on_mat)
	
func on_interact_end():
	set_surface_material(0, off_mat)
