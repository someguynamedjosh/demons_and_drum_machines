extends Reference

const HandState = preload("HandState.gd")
const RaycastResult = preload("RaycastResult.gd")

var hand_state: HandState
var last_hovered: Array = []

func _init(h: HandState):
	hand_state = h

func physics_process(ray: RaycastResult):
	var now_hovering_root = get_hovering_root(ray)
	var now_hovering = collect_object_and_holding(now_hovering_root)
	set_hovering(now_hovering)
	
func get_hovering_root(ray: RaycastResult):
	if ray.collider != null:
		var root = ray.collider.get_parent_spatial()
		if hand_state.holding != null:
			if not root.has_method("can_take"):
				return null
			elif not root.can_take(hand_state.holding):
				return null
		return root

func collect_object_and_holding(obj):
	if obj == null:
		return []
	elif hand_state.animations.currently_animating(obj):
		return []
	elif "holding" in obj:
		var result = collect_object_and_holding(obj.holding)
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

func start_hovering(obj):
	if obj.has_method("on_hover_start"):
		obj.on_hover_start()

func stop_hovering(obj):
	if obj.has_method("on_hover_end"):
		obj.on_hover_end()
