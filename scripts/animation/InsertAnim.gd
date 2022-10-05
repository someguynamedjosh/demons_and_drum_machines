extends "res://scripts/animation/FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")

var start: Transform
var destination: Node

func _init(d: Node):
	assert(d != null)
	destination = d

func duration():
	return 0.2

func on_start():
	start = target.transform

func evaluate():
	target.transform = start.interpolate_with(destination.global_transform, progress())

func on_finish():
	target.get_parent().remove_child(target)
	destination.add_child(target)
	target.transform = Transform.IDENTITY
