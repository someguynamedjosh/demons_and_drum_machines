extends Reference

const ANIM_NONE = 0
const ANIM_PICK_UP = 1
const ANIM_PUT_DOWN = 2

const ANIM_TIME = 0.2

var held_parent: Spatial
var holding: Spatial
var pick_up_requested = false
var put_down_requested = false

var animation = ANIM_NONE
var animation_time = 0.0
var object_put_down_transform = null

func _init(h: Spatial):
	assert(h != null)
	held_parent = h

func request_pick_up():
	pick_up_requested = true

func request_put_down():
	put_down_requested = true

func is_holding_anything():
	return holding != null

func process(delta: float):
	if animation != ANIM_NONE:
		assert(holding != null)
		animation_time += delta / ANIM_TIME
		var source: Transform = object_put_down_transform
		var target: Transform = source
		if animation == ANIM_PICK_UP:
			target = held_parent.global_transform
		if animation == ANIM_PUT_DOWN:
			source = held_parent.global_transform
		if animation_time >= 1.0:
			animation_time = 1.0
			if animation == ANIM_PICK_UP:
				holding.get_parent_spatial().remove_child(holding)
				held_parent.add_child(holding)
				holding.transform = Transform.IDENTITY
			elif animation == ANIM_PUT_DOWN:
				holding.transform = target
				holding = null
			animation = ANIM_NONE
		else:
			holding.transform = source.interpolate_with(target, animation_time)

func physics_process(crosshair_raycast_result: Dictionary):
	if pick_up_requested:
		pick_up_requested = false
		var obj = object_hit_by_raycast_result(crosshair_raycast_result)
		pick_up_object(obj)
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
		object_put_down_transform = holding.transform
		animation = ANIM_PICK_UP
		animation_time = 0.0

func put_down_object(crosshair_raycast_result):
	if holding.has_method("on_put_down"):
		holding.on_put_down()
	object_put_down_transform = Transform.IDENTITY \
		.translated(crosshair_raycast_result.position)
	var root = holding.get_node("/root/Spatial")
	print(root)
	if held_parent.is_a_parent_of(holding):
		held_parent.remove_child(holding)
		root.add_child(holding)
	animation = ANIM_PUT_DOWN
	animation_time = 0.0
