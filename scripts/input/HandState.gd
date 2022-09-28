extends Reference

const HandAnimationSystem = preload('HandAnimationSystem.gd')
const PickUpAnim = preload('res://scripts/animation/PickUpAnim.gd')
const PutDownAnim = preload('res://scripts/animation/PutDownAnim.gd')
const RaycastResult = preload("RaycastResult.gd")

var camera: Spatial
var held_parent: Spatial
var place_cursor: MeshInstance
var holding: Spatial
var pick_up_requested = false
var put_down_requested = false
var animations = HandAnimationSystem.new()

func _init(h: Spatial, c: MeshInstance):
	assert(h != null)
	camera = h.get_parent_spatial()
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

func physics_process(object_ray: RaycastResult, container_ray: RaycastResult):
	if pick_up_requested:
		pick_up_requested = false
		var obj = object_hit_by_raycast_result(object_ray)
		pick_up_object(obj)
	var container = get_targeted_container(container_ray)
	var target_transform = object_place_transform(object_ray, container)
	update_cursor(target_transform)
	if put_down_requested:
		put_down_requested = false
		put_down_object(target_transform, container)

func object_hit_by_raycast_result(result):
	if result.collider != null:
		return object_with_collider(result.collider)
	else:
		return null

func object_with_collider(collider):
	return collider.get_parent_spatial()

func pick_up_object(obj):
	if obj != null and obj.has_method("on_pick_up"):
		if not try_remove_object_from_container(obj):
			return
		obj.contained_in = null
		obj.on_pick_up()
		holding = obj
		animations.start(PickUpAnim.new(held_parent), obj)

func try_remove_object_from_container(obj):
	if obj.contained_in != null:
		if obj.contained_in.has_method("can_remove"):
			if not obj.contained_in.can_remove(obj):
				return false
		if obj.contained_in.has_method("on_remove"):
			obj.contained_in.on_remove(obj)
	return true

func get_targeted_container(container_ray: RaycastResult):
	if container_ray.collider != null:
		var container = object_with_collider(container_ray.collider)
		if container.has_method("can_take"):
			if container.can_take(holding):
				return container
	return null

func object_place_transform(object_ray: RaycastResult, container):
	if container != null:
		return container.get_node("InsertionPoint").global_transform
	elif object_ray.collider != null:
		return Transform.IDENTITY.translated(object_ray.position) \
			* Transform.IDENTITY.rotated(Vector3.UP, camera.rotation.y)
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

func put_down_object(target_transform, container):
	assert(holding != null)
	if target_transform == null:
		return
	if holding.has_method("on_put_down"):
		holding.on_put_down()
	if container != null:
		holding.contained_in = container
		if container.has_method("on_insert"):
			container.on_insert(holding)
	animations.start(PutDownAnim.new(target_transform), holding)
	holding = null
