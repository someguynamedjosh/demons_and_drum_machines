extends Node

const SnappyAnimTimer = preload("res://scripts/animation/SnappyAnimTimer.gd")

var target: Spatial
var anim_progress = 0.0
var base: Transform
export var anim_time: float = 0.2
export(float, -5, 5) var snappiness: float = 0.0
var timer = SnappyAnimTimer.new()
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
	timer.snappiness = snappiness
	var anim_progress = timer.process(delta, condition_met())
	var offset = Transform.IDENTITY \
		.translated(translation).rotated(rotation_axis, rotation)
	target.transform = base.interpolate_with(base * offset, anim_progress)
