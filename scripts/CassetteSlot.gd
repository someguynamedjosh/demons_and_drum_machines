extends Spatial

const Cassette = preload("Cassette.gd")

signal inserted(obj)
signal removed(obj)

var holding = null

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
