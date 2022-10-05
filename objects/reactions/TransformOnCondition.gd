extends Node

var target: Spatial
var anim_progress = 0.0
var base: Transform
export var anim_time: float = 0.2
export(float, -5, 5) var snappiness: float = 0.0
export var translation: Vector3 = Vector3.ZERO
export var rotation: float = 0.0
export var rotation_axis: Vector3 = Vector3.RIGHT

func _ready():
	target = Util.get_parent_spatial(self.get_parent())
	base = target.transform

func condition_met() -> bool:
	return false

func _process(delta):
	delta = delta / anim_time
	var position = 0.0
	var exponent = pow(2, snappiness)
	if condition_met():
		anim_progress = min(anim_progress + delta, 1.0)
		position = 1.0 - pow(1.0 - anim_progress, exponent)
	else:
		anim_progress = max(anim_progress - delta, 0.0)
		position = pow(anim_progress, exponent)
	var offset = Transform.IDENTITY \
		.translated(translation).rotated(rotation_axis, rotation)
	target.transform = base.interpolate_with(base * offset, position)
