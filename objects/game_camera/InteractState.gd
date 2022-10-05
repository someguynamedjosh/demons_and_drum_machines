extends Reference

const Interactable = preload("res://scripts/widgets/interactable/Interactable.gd")
const RaycastResult = preload("RaycastResult.gd")

var last_interacted: Interactable = null
var captured = false
var interaction_requested = false

func request_interaction():
	interaction_requested = true

func stop_interacting():
	if last_interacted != null:
		last_interacted.on_interact_end()
		captured = false
		last_interacted = null

func physics_process(ray: RaycastResult):
	if interaction_requested:
		interaction_requested = false
		if ray.target_interactable() != null:
			start_interacting_with_object(ray.target_interactable())

func start_interacting_with_object(obj: Interactable):
	obj.on_interact_start()
	captured = obj.captures_cursor() == true
	last_interacted = obj
