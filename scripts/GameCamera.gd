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
		rotation.y -= event.relative.x * 0.003
		rotation.x -= event.relative.y * 0.003
	elif event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
	elif event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				mouse_clicked = true
			else:
				if last_pressed != null and last_pressed.has_method("on_release"):
					last_pressed.on_release()
					last_pressed = null

func _physics_process(delta):
	if mouse_clicked:
		mouse_clicked = false
		var pos = get_viewport().get_visible_rect().size / 2
		var from = project_ray_origin(pos)
		var to = from + project_ray_normal(pos) * 1000
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to)
		if 'collider' in result:
			var root_obj = result.collider.get_parent_spatial()
			if root_obj.has_method("on_press"):
				root_obj.on_press()
			last_pressed = root_obj
