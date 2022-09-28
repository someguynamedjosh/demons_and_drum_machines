extends MeshInstance

export var hovered_mat: Material
export var default_mat: Material
var active = false
signal activated()
signal deactivated()

func activate():
	if not active:
		active = true
		translation.y -= 0.01
		emit_signal("activated")
	
func deactivate():
	if active:
		active = false
		translation.y += 0.01
		emit_signal("deactivated")

func on_interact_start():
	if active:
		deactivate()
	else:
		activate()
	
func on_hover_start():
	set_surface_material(0, hovered_mat)

func on_hover_end():
	set_surface_material(0, default_mat)
