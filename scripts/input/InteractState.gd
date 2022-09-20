extends Reference

var last_interacted = null
var interaction_requested = false

func request_interaction():
	interaction_requested = true

func stop_interacting():
	if last_interacted != null and last_interacted.has_method("on_release"):
		last_interacted.on_release()
		last_interacted = null

func process(crosshair_raycast_result: Dictionary):
	if interaction_requested:
		interaction_requested = false
		start_interacting_with_raycast_result(crosshair_raycast_result)

func start_interacting_with_raycast_result(result):
	if 'collider' in result:
		start_interacting_with_collider(result.collider)

func start_interacting_with_collider(collider):
	var root_obj = collider.get_parent_spatial()
	start_interacting_with_object(root_obj)

func start_interacting_with_object(root_obj):
	if root_obj.has_method("on_press"):
		root_obj.on_press()
	last_interacted = root_obj
