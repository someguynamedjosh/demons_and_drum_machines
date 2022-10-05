extends "res://scripts/animation/FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")
const Slot = preload("res://scripts/widgets/slot/Slot.gd")

var start: Transform
var slot: Slot
var destination: Spatial

func _init(s: Slot):
	assert(s != null)
	slot = s
	destination = slot.get_insertion_point()

func on_start():
	start = target.transform

func evaluate():
	target.transform = start.interpolate_with(destination.global_transform, progress())

func on_finish():
	target.get_parent().remove_child(target)
	destination.add_child(target)
	target.transform = Transform.IDENTITY
	slot.on_insert_end()
	Util.enable_colliders(target)
