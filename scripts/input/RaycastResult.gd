extends Reference

var collider: StaticBody
var position: Vector3

func _init(c: StaticBody, p: Vector3):
	collider = c
	position = p
