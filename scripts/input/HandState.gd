extends Reference

const HandAnimationSystem = preload('HandAnimationSystem.gd')
const PickUpAnim = preload('res://scripts/animation/PickUpAnim.gd')
const PutDownAnim = preload('res://scripts/animation/PutDownAnim.gd')

var held_parent: Spatial
var place_cursor: MeshInstance
var holding: Spatial
var pick_up_requested = false
var put_down_requested = false
var animations = HandAnimationSystem.new()

func _init(h: Spatial, c: MeshInstance):
	assert(h != null)
	held_parent = h
	place_cursor = c

func request_pick_up():
	pick_up_requested = true

func request_put_down():
	put_down_requested = true

func is_holding_anything():
	return holding != null

func process(delta: float):
	animations.process(delta)

func physics_process(crosshair_raycast_result: Dictionary):
	if pick_up_requested:
		pick_up_requested = false
		var obj = object_hit_by_raycast_result(crosshair_raycast_result)
		pick_up_object(obj)
	update_cursor(crosshair_raycast_result)
	if put_down_requested:
		put_down_requested = false
		put_down_object(crosshair_raycast_result)

func object_hit_by_raycast_result(result):
	if 'collider' in result:
		return object_with_collider(result.collider)
	else:
		return null

func object_with_collider(collider):
	return collider.get_parent_spatial()

func pick_up_object(obj):
	if obj.has_method("on_pick_up"):
		obj.on_pick_up()
		holding = obj
		animations.start(PickUpAnim.new(held_parent), obj)

func update_cursor(crosshair_raycast_result: Dictionary):
	if holding == null or not('position' in crosshair_raycast_result):
		place_cursor.hide()
	else:
		place_cursor.show()
		var mesh_obj = holding.get_node("Mesh")
		place_cursor.mesh = mesh_obj.mesh
		place_cursor.transform \
			= Transform.IDENTITY.translated(crosshair_raycast_result.position) \
				* mesh_obj.transform

func put_down_object(crosshair_raycast_result):
	assert(holding != null)
	if holding.has_method("on_put_down"):
		holding.on_put_down()
	animations.start(PutDownAnim.new(crosshair_raycast_result.position), holding)
	holding = null
