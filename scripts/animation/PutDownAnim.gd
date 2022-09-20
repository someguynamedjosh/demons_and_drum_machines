extends "res://scripts/animation/FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")

var start: Transform
var destination: Transform

func _init(d: Vector3):
	destination = Transform.IDENTITY.translated(d)

func duration():
	return 0.2

func on_start():
	start = target.transform

func evaluate():
	target.transform = start.interpolate_with(destination, progress())

func on_finish():
	pass
