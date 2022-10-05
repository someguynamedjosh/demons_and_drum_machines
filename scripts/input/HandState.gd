extends Reference

const FinishInsertingAction = preload("FinishInsertingAction.gd")
const HandAnimationSystem = preload('HandAnimationSystem.gd')
const InsertAnim = preload('res://scripts/animation/InsertAnim.gd')
const PickUpAnim = preload('res://scripts/animation/PickUpAnim.gd')
const PutDownAnim = preload('res://scripts/animation/PutDownAnim.gd')
const RaycastResult = preload("RaycastResult.gd")
const RemoveAnim = preload('res://scripts/animation/RemoveAnim.gd')

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

func physics_process(ray: RaycastResult):
	if pick_up_requested:
		pick_up_requested = false
		var obj_or_container = object_hit_by_raycast_result(ray)
		if "holding" in obj_or_container:
			pick_up_object(obj_or_container.holding)
		else:
			pick_up_object(obj_or_container)
	var container = get_targeted_container(ray)
	var target_transform = object_place_transform(ray, container)
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
		if obj.contained_in == null:
			animations.start(PickUpAnim.new(held_parent), obj)
		else:
			if not try_remove_object_from_container(obj):
				return
			animations.start(RemoveAnim.new(held_parent), obj)
		obj.on_pick_up()
		holding = obj
		Util.disable_colliders(obj)

func try_remove_object_from_container(obj):
	if obj.contained_in != null:
		if obj.contained_in.has_method("can_remove"):
			if not obj.contained_in.can_remove(obj):
				return false
		if obj.contained_in.has_method("on_remove"):
			obj.contained_in.on_remove(obj)
		obj.contained_in = null
	return true

func get_targeted_container(obj_ray: RaycastResult):
	if obj_ray.collider != null:
		var container = object_with_collider(obj_ray.collider)
		if container.has_method("can_take"):
			if container.can_take(holding):
				return container
	return null

func object_place_transform(object_ray: RaycastResult, container):
	if container != null:
		return container.get_insertion_point().global_transform
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
	if container == null:
		var anim = PutDownAnim.new(target_transform)
		Util.enable_colliders(holding)
		animations.start(anim, holding)
	else:
		holding.contained_in = container
		container.insertion_in_progress = true
		if container.has_method("on_insert"):
			container.on_insert(holding)
		var anim = InsertAnim.new(container.get_insertion_point())
		var action = FinishInsertingAction.new(container, holding)
		animations.start_w_finish_action(anim, holding, action)
	holding = null
