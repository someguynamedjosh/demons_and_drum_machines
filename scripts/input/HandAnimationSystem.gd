extends Reference

const ProceduralAnimation = preload("../animation/ProceduralAnimation.gd")

var active_animations: Dictionary = {}

func process(delta):
	for anim_target in active_animations.keys():
		var anim: ProceduralAnimation = active_animations[anim_target]
		var next = anim.process(delta)
		if anim.is_finished():
			if next == null:
				active_animations.erase(anim_target)
			else:
				start(next, anim_target)

func start(anim: ProceduralAnimation, on: Spatial):
	anim.target = on
	active_animations[on] = anim
