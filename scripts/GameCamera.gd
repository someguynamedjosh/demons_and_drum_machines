extends Camera

var mouse_clicked = false
var last_pressed = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_movement(event.relative)
	elif event is InputEventKey:
		handle_key_press(event.scancode)
	elif event is InputEventMouseButton:
		handle_mouse(event)

func _physics_process(delta):
	if mouse_clicked:
		mouse_clicked = false
		click_object_under_crosshair()

func handle_mouse_movement(delta):
	rotation.y -= delta.x * 0.003
	rotation.x -= delta.y * 0.003

func handle_key_press(scancode):
	if scancode == KEY_ESCAPE:
		handle_escape()

func handle_escape():
	get_tree().quit()

func handle_mouse(event):
	if event.button_index == 1 and event.is_pressed():
		handle_left_press()
	elif event.button_index == 1 and not event.is_pressed():
		handle_left_release()

func handle_left_press():
	mouse_clicked = true

func handle_left_release():
	if last_pressed != null and last_pressed.has_method("on_release"):
		last_pressed.on_release()
		last_pressed = null

func screen_center():
	return get_viewport().get_visible_rect().size / 2

func crosshair_ray():
	var pos = screen_center()
	var from = project_ray_origin(pos)
	var to = from + project_ray_normal(pos) * 1000
	return { 'from': from, 'to': to }

func raycast_from_crosshair():
	var ray = crosshair_ray()
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray.from, ray.to)

func click_collider(collider):
	var root_obj = collider.get_parent_spatial()
	if root_obj.has_method("on_press"):
		root_obj.on_press()
	last_pressed = root_obj

func click_object_under_crosshair():
	var result = raycast_from_crosshair()
	if 'collider' in result:
		click_collider(result.collider)
