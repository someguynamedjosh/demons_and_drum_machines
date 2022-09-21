extends Spatial

const Cassette = preload("Cassette.gd")

var holding = false

func can_take(object: Spatial) -> bool:
	return object is Cassette

func on_insert(obj):
	holding = true

func on_remove(obj):
	holding = false

func _process(delta):
	if holding:
		$Mesh.rotation.y += delta
