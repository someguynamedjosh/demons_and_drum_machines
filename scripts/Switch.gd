extends Node

export var hovered_mat: Material
export var active_transform: Transform
var active = false
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

func on_interact_start():
	if active:
		deactivate()
	else:
		activate()

func on_hover_start():
	for mesh in get_children():
		if mesh is MeshInstance:
			mesh.material_override = hovered_mat

func on_hover_end():
	for mesh in get_children():
		if mesh is MeshInstance:
			mesh.material_override = null
