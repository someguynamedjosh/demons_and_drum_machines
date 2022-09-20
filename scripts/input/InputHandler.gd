extends Reference

const InteractState = preload("InteractState.gd")

var camera: Node
var interact_state: InteractState

func _init(c: Node, i: InteractState):
	camera = c
	interact_state = i

func input(event: InputEvent):
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
		handle_escape(camera)

func handle_escape(camera):
	camera.get_tree().quit()

func handle_mouse_button(event):
	if event.button_index == 1 and event.is_pressed():
		handle_left_press()
	elif event.button_index == 1 and not event.is_pressed():
		handle_left_release()

func handle_left_press():
	interact_state.request_interaction()

func handle_left_release():
	interact_state.stop_interacting()
