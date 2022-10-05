extends Reference

const RaycastResult = preload("RaycastResult.gd")

var last_interacted = null
var locked = false
var interaction_requested = false

func request_interaction():
	interaction_requested = true

func stop_interacting():
	if last_interacted != null:
		if last_interacted.has_method("on_interact_end"):
			last_interacted.on_interact_end()
		locked = false
		last_interacted = null

func physics_process(ray: RaycastResult):
	if interaction_requested:
		interaction_requested = false
		if ray.collider != null:
			start_interacting_with_collider(ray.collider)

func start_interacting_with_collider(collider):
	var root_obj = collider.get_parent_spatial()
	start_interacting_with_object(root_obj)

func start_interacting_with_object(root_obj):
	if root_obj.has_method("on_interact_start"):
		locked = root_obj.on_interact_start() == true
		last_interacted = root_obj
