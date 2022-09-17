extends Camera3D


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
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
