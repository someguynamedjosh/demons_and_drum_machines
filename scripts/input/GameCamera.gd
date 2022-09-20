extends Camera

const Crosshair = preload("Crosshair.gd")
const HoverState = preload("HoverState.gd")
const InputHandler = preload("InputHandler.gd")
const InteractState = preload("InteractState.gd")

var crosshair: Crosshair = Crosshair.new(self)
var hover_state: HoverState = HoverState.new()
var interact_state: InteractState = InteractState.new()
var input_handler: InputHandler = InputHandler.new(self, interact_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event: InputEvent):
	input_handler.input(event)

func _physics_process(_delta):
	var raycast_result = crosshair.raycast()
	hover_state.process(raycast_result)
	interact_state.process(raycast_result)
