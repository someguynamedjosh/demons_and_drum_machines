extends Reference

const HandAnimationSystem = preload('HandAnimationSystem.gd')
const PickUpAnim = preload('res://scripts/animation/PickUpAnim.gd')
const PutDownAnim = preload('res://scripts/animation/PutDownAnim.gd')
const RaycastResult = preload("RaycastResult.gd")

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

func physics_process(object: RaycastResult, container: RaycastResult):
	if pick_up_requested:
		pick_up_requested = false
		var obj = object_hit_by_raycast_result(object)
		pick_up_object(obj)
	var target_transform = object_place_transform(object, container)
	update_cursor(target_transform)
	if put_down_requested:
		put_down_requested = false
		put_down_object(target_transform)

func object_hit_by_raycast_result(result):
	if result.collider != null:
		return object_with_collider(result.collider)
	else:
		return null

func object_with_collider(collider):
	return collider.get_parent_spatial()

func pick_up_object(obj):
	if obj != null and obj.has_method("on_pick_up"):
		obj.on_pick_up()
		holding = obj
		animations.start(PickUpAnim.new(held_parent), obj)

func object_place_transform(object: RaycastResult, container: RaycastResult):
	if container.collider != null:
		return object_with_collider(container.collider)\
			.get_node("InsertionPoint") \
			.global_transform
	elif object.collider != null:
		return Transform.IDENTITY.translated(object.position)
	else:
		return null

func update_cursor(target_transform):
	if holding == null or target_transform == null:
		place_cursor.hide()
	else:
		place_cursor.show()
		var mesh_obj = holding.get_node("Mesh")
		place_cursor.mesh = mesh_obj.mesh
		place_cursor.transform = target_transform * mesh_obj.transform

func put_down_object(target_transform):
	assert(holding != null)
	if target_transform == null:
		return
	if holding.has_method("on_put_down"):
		holding.on_put_down()
	animations.start(PutDownAnim.new(target_transform), holding)
	holding = null
