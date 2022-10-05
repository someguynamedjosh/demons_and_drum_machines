extends "../Hoverable.gd"

signal inserted(obj)
signal removed(obj)

var contents = null
var insertion_in_progress = false
var locked = false
export var start_with: PackedScene
export var insertion_point_path: NodePath = "InsertionPoint"

func _ready():
	if start_with != null:
		var instance = start_with.instance()
		get_tree().root.call_deferred("add_child", instance)
		# TODO: This is manually doing stuff that the input system would
		# normally do automatically if the player clicked to put an object in
		# this slot.
		assert(can_insert(instance))
		instance.transform = get_insertion_point().global_transform
		Util.disable_colliders(instance)
		on_insert_start(instance)
		on_insert_end()

func get_insertion_point() -> Spatial:
	return get_node(insertion_point_path) as Spatial

func can_insert(object: Spatial) -> bool:
	return contents == null and not locked

func can_remove() -> bool:
	return contents != null and not locked

func on_insert_start(object: Spatial):
	assert(object != null)
	contents = object
	insertion_in_progress = true
	emit_signal('inserted', object)

func on_insert_end():
	insertion_in_progress = false

func on_remove():
	emit_signal('removed', contents)
	contents = null
