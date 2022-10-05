extends "Slot.gd"

const Cassette = preload("res://scenes/objects/cassette/Cassette.gd")

func can_insert(object: Spatial) -> bool:
	return object is Cassette and .can_insert(object)

func get_cassette() -> Cassette:
	return contents
