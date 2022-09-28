extends Spatial

const MusicClip = preload("res://native/MusicClip.gdns")

export var hovered_mat: Material
export var plain_mat: Material
var contained_in
export var audio: Resource#: MusicBuffer#, actual annotation gives a segfault and cannot be exported.

func on_hover_start():
	$Mesh.set_surface_material(0, hovered_mat)
	
func on_hover_end():
	$Mesh.set_surface_material(0, plain_mat)

func on_pick_up():
	pass
