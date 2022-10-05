extends Reference

var zoom_factor = 1.0
var base_fov = 30.0
var camera: Camera
var crosshair: Spatial
var held_parent: Spatial
var held_translation: Vector3
var increment: float = 1.2

func _init(c: Camera, cr: Spatial, h: Spatial):
	camera = c
	crosshair = cr
	held_parent = h
	held_translation = held_parent.translation

func offset_zoom_factor(delta):
	zoom_factor *= pow(increment, delta)
	zoom_factor = clamp(zoom_factor, pow(increment, -4), pow(increment, 7))
	update_camera()

func update_camera():
	camera.fov = base_fov / zoom_factor
	crosshair.scale = Vector3.ONE / zoom_factor
	var slight_zoom_factor = lerp(zoom_factor, 1.0, 0.6)
	held_parent.translation = held_translation / slight_zoom_factor
	held_parent.translation.z = held_translation.z
	held_parent.scale = Vector3.ONE / slight_zoom_factor
