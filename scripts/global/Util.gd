extends Node

func enable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody:
			(child as StaticBody).collision_layer = 1

func disable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody:
			(child as StaticBody).collision_layer = 0
