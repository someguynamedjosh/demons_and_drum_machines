extends Reference

const HandState = preload("HandState.gd")
const Hoverable = preload("res://scripts/widgets/Hoverable.gd")
const RaycastResult = preload("RaycastResult.gd")
const Slot = preload("res://scripts/widgets/slot/Slot.gd")

var hand_state: HandState
var last_hovered: Array = []

func _init(h: HandState):
	hand_state = h

func physics_process(ray: RaycastResult):
	var now_hovering_root = get_hovering_root(ray)
	var now_hovering = collect_object_and_holding(now_hovering_root)
	set_hovering(now_hovering)
	
func get_hovering_root(ray: RaycastResult):
	if hand_state.holding != null:
		if not ray.target is Slot:
			return null
		elif not (ray.target as Slot).can_insert(hand_state.holding):
			return null
	elif ray.target is Slot and ray.target.locked:
		return null
	return ray.target

func collect_object_and_holding(obj: Hoverable):
	if obj == null:
		return []
	elif hand_state.animations.currently_animating(obj):
		return []
	elif obj is Slot:
		var result = collect_object_and_holding((obj as Slot).contents)
		result.append(obj)
		return result
	else:
		return [obj]

func set_hovering(now_hovering: Array):
	for obj in now_hovering:
		if not last_hovered.has(obj):
			start_hovering(obj)
	for obj in last_hovered:
		if not now_hovering.has(obj):
			stop_hovering(obj)
	last_hovered = now_hovering

func start_hovering(obj: Hoverable):
	obj.on_hover_start()

func stop_hovering(obj: Hoverable):
	obj.on_hover_end()
