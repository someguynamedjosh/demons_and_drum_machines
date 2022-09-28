extends Spatial

const Cassette = preload("Cassette.gd")

signal inserted(obj)
signal removed(obj)

var holding = null
export var start_with: PackedScene

func _ready():
	if start_with != null:
		var instance = start_with.instance()
		get_tree().root.call_deferred("add_child", instance)
		# TODO: This is manually doing stuff that the input system would
		# normally do automatically if the player clicked to put an object in
		# this slot.
		assert(can_take(instance))
		instance.transform = $InsertionPoint.global_transform
		instance.contained_in = self
		on_insert(instance)

func can_take(object: Spatial) -> bool:
	return object is Cassette and not holding

func on_insert(obj):
	assert(obj != null)
	holding = obj
	assert(obj != null)
	emit_signal('inserted', obj)

func on_remove(obj):
	holding = null
	emit_signal('removed', obj)
