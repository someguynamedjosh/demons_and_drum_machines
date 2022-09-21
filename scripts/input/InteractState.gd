extends Reference

const RaycastResult = preload("RaycastResult.gd")

var last_interacted = null
var interaction_requested = false

func request_interaction():
	interaction_requested = true

func stop_interacting():
	if last_interacted != null \
	and last_interacted.has_method("on_interact_end"):
		last_interacted.on_interact_end()
		last_interacted = null

func physics_process(object: RaycastResult):
	if interaction_requested:
		interaction_requested = false
		if object.collider != null:
			start_interacting_with_collider(object.collider)

func start_interacting_with_collider(collider):
	var root_obj = collider.get_parent_spatial()
	start_interacting_with_object(root_obj)

func start_interacting_with_object(root_obj):
	if root_obj.has_method("on_interact_start"):
		root_obj.on_interact_start()
		last_interacted = root_obj
