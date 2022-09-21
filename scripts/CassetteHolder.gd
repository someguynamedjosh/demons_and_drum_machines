extends Spatial

const Cassette = preload("Cassette.gd")

func can_take(object: Spatial) -> bool:
	return object is Cassette
