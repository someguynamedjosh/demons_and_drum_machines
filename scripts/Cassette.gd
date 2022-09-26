extends Spatial

export var hovered_mat: Material
export var plain_mat: Material
export var audio_source: AudioStreamSample
var contained_in
var audio_data: PoolVector2Array
var beat_duration: int = 1312989 - 1297775
var beat_offset: int = 1297775 % beat_duration

func _ready():
	if audio_source != null:
		audio_data = PoolVector2Array([])
		var i = 44
		var d = audio_source.data
		while i < d.size() - 3:
			var l1 = d[i + 1]
			if l1 >= 128:
				l1 -= 256
			var left = l1 / 256.0 + d[i] / 65536.0
			var r1 = d[i + 3]
			if r1 >= 128:
				r1 -= 256
			var right = r1 / 256.0 + d[i + 2] / 65536.0
			audio_data.append(Vector2(left, right))
			i += 4

func on_hover_start():
	$Mesh.set_surface_material(0, hovered_mat)
	
func on_hover_end():
	$Mesh.set_surface_material(0, plain_mat)

func on_pick_up():
	pass
