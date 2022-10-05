extends Node

const Activatable = preload("res://scripts/widgets/interactable/Activatable.gd")
const Hoverable = preload("res://scripts/widgets/Hoverable.gd")
const Slot = preload("res://scripts/widgets/slot/Slot.gd")

func enable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody:
			(child as StaticBody).collision_layer = 1

func disable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody:
			(child as StaticBody).collision_layer = 0

func get_parent_with_class_impl(search_start: Node, clas) -> Node:
	if search_start == null:
		return null
	elif search_start is clas:
		return search_start
	else:
		return get_parent_with_class_impl(search_start.get_parent(), clas)
		
func get_parent_with_class(search_start: Node, clas, clas_name: String) -> Node:
	var result = get_parent_with_class_impl(search_start, clas)
	assert(result != null, str(search_start) + " does not have a " \
		 + clas_name + " as a parent.")
	return result

func get_parent_activatable(search_start: Node) -> Activatable:
	return get_parent_with_class(search_start, Activatable, "Activatable") as Activatable

func get_parent_hoverable(search_start: Node) -> Hoverable:
	return get_parent_with_class(search_start, Hoverable, "Hoverable") as Hoverable

func get_parent_mesh(search_start: Node) -> MeshInstance:
	return get_parent_with_class(search_start, MeshInstance, "MeshInstance") as MeshInstance

func get_parent_slot(search_start: Node) -> Slot:
	return get_parent_with_class(search_start, Slot, "Slot") as Slot

func get_parent_spatial(search_start: Node) -> Spatial:
	return get_parent_with_class(search_start, Spatial, "Spatial") as Spatial
