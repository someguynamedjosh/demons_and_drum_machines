extends Reference

var camera: Camera

func _init(c: Camera):
	camera = c

func raycast():
	var ray = crosshair_ray()
	var space_state = camera.get_world().direct_space_state
	return space_state.intersect_ray(ray.from, ray.to)

func crosshair_ray():
	var pos = screen_center()
	var from = camera.project_ray_origin(pos)
	var to = from + camera.project_ray_normal(pos) * 1000
	return { 'from': from, 'to': to }

func screen_center():
	return camera.get_viewport().get_visible_rect().size / 2
