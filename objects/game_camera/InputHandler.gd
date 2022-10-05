extends Reference

const HandState = preload("HandState.gd")
const InteractState = preload("InteractState.gd")
const ZoomState = preload("ZoomState.gd")

var camera: Node
var hand_state: HandState
var interact_state: InteractState
var zoom_state: ZoomState
var input_queue = []

func _init(c: Node, h: HandState, i: InteractState, z: ZoomState):
	camera = c
	hand_state = h
	interact_state = i
	zoom_state = z

func ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func input(event: InputEvent):
	input_queue.push_back(event)

func physics_update():
	for event in input_queue:
		handle_event(event)
	input_queue.clear()

func handle_event(event: InputEvent):
	if event is InputEventMouseMotion:
		handle_mouse_movement(event.relative)
	elif event is InputEventKey:
		handle_key_press(event.scancode)
	elif event is InputEventMouseButton:
		handle_mouse_button(event)

func handle_mouse_movement(delta: Vector2):
	delta = 0.003 * delta
	if interact_state.captured:
		interact_state.last_interacted.on_interact_move(delta)
	else:
		var camera_speed = 0.4 / zoom_state.zoom_factor
		camera.rotation.y -= delta.x * camera_speed
		camera.rotation.x -= delta.y * camera_speed

func handle_key_press(scancode):
	if scancode == KEY_ESCAPE:
		handle_escape()

func handle_escape():
	camera.get_tree().quit()

func handle_mouse_button(event):
	if event.button_index == 1 and event.is_pressed():
		handle_left_press()
	elif event.button_index == 1 and not event.is_pressed():
		handle_left_release()
	elif event.button_index == BUTTON_WHEEL_UP:
		zoom_state.offset_zoom_factor(1)
	elif event.button_index == BUTTON_WHEEL_DOWN:
		zoom_state.offset_zoom_factor(-1)

func handle_left_press():
	if hand_state.is_holding_anything():
		hand_state.request_put_down()
	else:
		# An individual object will only respond to one of these.
		interact_state.request_interaction()
		hand_state.request_pick_up()

func handle_left_release():
	interact_state.stop_interacting()
