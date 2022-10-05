extends Reference

const Hoverable = preload("res://scripts/widgets/Hoverable.gd")
const Interactable = preload("res://scripts/widgets/interactable/Interactable.gd")
const Movable = preload("res://scripts/widgets/movable/Movable.gd")
const Slot = preload("res://scripts/widgets/slot/Slot.gd")

var collider: StaticBody
var position: Vector3
var target: Hoverable = null

func _init(c: StaticBody, p: Vector3):
	collider = c
	position = p
	if collider == null:
		return
	var candidate = collider.get_parent_spatial()
	if candidate is Hoverable:
		target = candidate

func target_movable() -> Movable:
	if target is Movable:
		return target as Movable
	else:
		return null

func target_interactable() -> Interactable:
	if target is Interactable:
		return target as Interactable
	else:
		return null

func target_slot() -> Slot:
	if target is Slot:
		return target as Slot
	else:
		return null
