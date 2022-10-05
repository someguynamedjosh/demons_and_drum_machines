extends "res://scripts/action/Action.gd"

var container
var object

func _init(c, o):
	assert(c != null)
	assert(o != null)
	container = c
	object = o

func perform_action():
	container.insertion_in_progress = false
	Util.enable_colliders(object)
