extends Reference

const HandAnimationSystem = preload('HandAnimationSystem.gd')
const InsertAnim = preload('res://scripts/animation/InsertAnim.gd')
const Movable = preload('res://scripts/widgets/movable/Movable.gd')
const PickUpAnim = preload('res://scripts/animation/PickUpAnim.gd')
const PutDownAnim = preload('res://scripts/animation/PutDownAnim.gd')
const RaycastResult = preload("RaycastResult.gd")
const RemoveAnim = preload('res://scripts/animation/RemoveAnim.gd')
const Slot = preload('res://scripts/widgets/slot/Slot.gd')

var camera: Spatial
var held_parent: Spatial
var place_cursor: MeshInstance
var holding: Movable
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
		if ray.target_slot() != null:
			remove_object_from_slot(ray.target_slot())
		elif ray.target_movable() != null:
			if ray.target_movable().contained_in != null:
				remove_object_from_slot(ray.target_movable().contained_in)
			else:
				pick_up_object(ray.target_movable())
	var target_transform = object_place_transform(ray)
	update_cursor(target_transform)
	if put_down_requested:
		put_down_requested = false
		put_down_object(target_transform, ray.target_slot())

func pick_up_object(obj: Movable):
	if obj != null:
		animations.start(PickUpAnim.new(held_parent), obj)
		set_holding(obj)

func remove_object_from_slot(slot: Slot):
	var obj: Movable = slot.contents
	if obj == null:
		return
	if not slot.can_remove():
		return
	slot.on_remove()
	obj.on_remove()
	animations.start(RemoveAnim.new(held_parent), obj)
	set_holding(obj)
	
func set_holding(obj: Movable):
	obj.on_pick_up()
	holding = obj
	Util.disable_colliders(obj)

func object_place_transform(ray: RaycastResult):
	if ray.target_slot() != null and ray.target_slot().can_insert(holding):
		return ray.target_slot().get_insertion_point().global_transform
	elif ray.collider != null:
		return Transform.IDENTITY.translated(ray.position) \
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

func put_down_object(target_transform: Transform, slot: Slot):
	assert(holding != null)
	if target_transform == null:
		return
	holding.on_put_down()
	var anim
	if slot == null or not slot.can_insert(holding):
		anim = PutDownAnim.new(target_transform)
		Util.enable_colliders(holding)
	else:
		holding.contained_in = slot
		slot.on_insert_start(holding)
		anim = InsertAnim.new(slot)
	animations.start(anim, holding)
	holding = null
