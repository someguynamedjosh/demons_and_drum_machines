extends Spatial

const Dummy = preload("res://Dummy.gdns")

var dummy: Dummy

func _ready():
	dummy = Dummy.new()
	dummy = dummy.make()
