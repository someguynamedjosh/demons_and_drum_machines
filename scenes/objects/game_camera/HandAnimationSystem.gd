extends Reference

const ProceduralAnimation = preload("res://scripts/animation/ProceduralAnimation.gd")

var active_animations: Dictionary = {}

func start(anim: ProceduralAnimation, on: Spatial):
	if on in active_animations:
		finish(active_animations[on], on)
	anim.target = on
	anim.on_start()
	active_animations[on] = anim

func currently_animating(obj: Spatial) -> bool:
	return obj in active_animations

func process(delta: float):
	for anim_target in active_animations.keys():
		var anim: ProceduralAnimation = active_animations[anim_target]
		process_anim(anim, delta)
		if anim.is_finished():
			finish(anim, anim_target)

func process_anim(anim: ProceduralAnimation, delta: float):
	anim.time += delta
	anim.evaluate()

func finish(anim: ProceduralAnimation, anim_target: Spatial):
	var next = anim.on_finish()
	var _unused = active_animations.erase(anim_target)
	if next != null:
		start(next, anim_target)
