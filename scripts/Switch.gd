extends MeshInstance

export var hovered_mat: Material
export var default_mat: Material
var active = false
signal activated()
signal deactivated()

func on_interact_start():
	active = !active
	if active:
		translation.y -= 0.05
		emit_signal("activated")
	else:
		translation.y += 0.05
		emit_signal("deactivated")
	
func on_hover_start():
	set_surface_material(0, hovered_mat)

func on_hover_end():
	set_surface_material(0, default_mat)
