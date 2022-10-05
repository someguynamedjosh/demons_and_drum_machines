extends "res://scripts/animation/FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")

var start: Transform
var destination: Spatial

func _init(d: Spatial):
	destination = d

func duration():
	return 0.3

func on_start():
	start = target.transform

func evaluate():
	target.transform = \
		start.interpolate_with(destination.global_transform, progress())

func on_finish():
	return HoldAnim.new(destination)
