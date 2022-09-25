extends Reference

const HandState = preload("HandState.gd")
const InteractState = preload("InteractState.gd")

var camera: Node
var hand_state: HandState
var interact_state: InteractState
var input_queue = []

func _init(c: Node, h: HandState, i: InteractState):
	camera = c
	hand_state = h
	interact_state = i

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

func handle_mouse_movement(delta):
	camera.rotation.y -= delta.x * 0.003
	camera.rotation.x -= delta.y * 0.003

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

func handle_left_press():
	if hand_state.is_holding_anything():
		hand_state.request_put_down()
	else:
		# An individual object will only respond to one of these.
		interact_state.request_interaction()
		hand_state.request_pick_up()

func handle_left_release():
	interact_state.stop_interacting()
