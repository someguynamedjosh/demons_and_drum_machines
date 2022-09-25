extends "res://scripts/animation/ProceduralAnimation.gd"

var destination: Spatial

func _init(d: Spatial):
	destination = d

func on_start():
	pass

func evaluate():
	target.transform = destination.global_transform
