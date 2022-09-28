extends Camera

const HandState = preload("HandState.gd")
const HoverState = preload("HoverState.gd")
const InputHandler = preload("InputHandler.gd")
const InteractState = preload("InteractState.gd")
const RaycastResult = preload("RaycastResult.gd")
const ZoomState = preload("ZoomState.gd")

export var place_cursor_mat: Material

var place_cursor = MeshInstance.new()
var interact_state: InteractState = InteractState.new()
onready var zoom_state: ZoomState = ZoomState.new(self, $Crosshair, $HeldParent)
onready var hand_state: HandState = HandState.new($HeldParent, place_cursor)
onready var hover_state: HoverState = HoverState.new(hand_state)
onready var input_handler: InputHandler \
	= InputHandler.new(self, hand_state, interact_state, zoom_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	place_cursor.set_name("PlaceCursor")
	place_cursor.material_override = place_cursor_mat
	get_tree().root.get_child(0).call_deferred("add_child", place_cursor)
	input_handler.ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hand_state.process(delta)
	
func _input(event: InputEvent):
	input_handler.input(event)

func get_raycast_result(from: RayCast) -> RaycastResult:
	from.force_raycast_update()
	return RaycastResult.new(from.get_collider(), from.get_collision_point())

func _physics_process(_delta):
	input_handler.physics_update()
	var object = get_raycast_result($ObjectRayCast)
	var container = get_raycast_result($ContainerRayCast)
	hover_state.physics_process(object)
	interact_state.physics_process(object)
	hand_state.physics_process(object, container)
