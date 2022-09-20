extends Reference

var last_hovered = null

func physics_process(crosshair_raycast_result: Dictionary):
	if 'collider' in crosshair_raycast_result:
		hover_collider(crosshair_raycast_result.collider)
	else:
		start_hovering(null)

func hover_collider(collider):
	var new_hovered = collider.get_parent_spatial()
	if last_hovered != new_hovered:
		start_hovering(new_hovered)

func start_hovering(new_hovered):
	if new_hovered != null and new_hovered.has_method("on_hover_start"):
		new_hovered.on_hover_start()
	if last_hovered != null and last_hovered.has_method("on_hover_end"):
		last_hovered.on_hover_end()
	last_hovered = new_hovered
