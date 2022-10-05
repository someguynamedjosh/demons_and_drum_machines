extends Reference

const Action = preload("../action/Action.gd")
const ProceduralAnimation = preload("../animation/ProceduralAnimation.gd")

var active_animations: Dictionary = {}
var finish_actions: Dictionary = {}

func start(anim: ProceduralAnimation, on: Spatial):
	if on in active_animations:
		finish(active_animations[on], on)
	anim.target = on
	anim.on_start()
	active_animations[on] = anim

func start_w_finish_action(anim: ProceduralAnimation, on: Spatial, finish_action: Action):
	start(anim, on)
	finish_actions[on] = finish_action

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
	do_finish_action(anim_target)
	var _unused = active_animations.erase(anim_target)
	if next != null:
		start(next, anim_target)

func do_finish_action(anim_target: Spatial):
	if anim_target in finish_actions:
		finish_actions[anim_target].perform_action()
		var _unused = finish_actions.erase(anim_target)
