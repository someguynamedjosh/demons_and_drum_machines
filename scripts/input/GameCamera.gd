extends Camera

const Crosshair = preload("Crosshair.gd")
const HandState = preload("HandState.gd")
const HoverState = preload("HoverState.gd")
const InputHandler = preload("InputHandler.gd")
const InteractState = preload("InteractState.gd")

export var place_cursor: NodePath = "PlaceCursor"

var crosshair: Crosshair = Crosshair.new(self)
var interact_state: InteractState = InteractState.new()
onready var hand_state: HandState \
	= HandState.new($HeldParent, get_node(place_cursor))
onready var hover_state: HoverState = HoverState.new(hand_state)
onready var input_handler: InputHandler \
	= InputHandler.new(self, hand_state, interact_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	input_handler.ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hand_state.process(delta)
	
func _input(event: InputEvent):
	input_handler.input(event)

func _physics_process(_delta):
	input_handler.physics_update()
	var raycast_result = crosshair.raycast()
	hover_state.physics_process(raycast_result)
	interact_state.physics_process(raycast_result)
	hand_state.physics_process(raycast_result)
