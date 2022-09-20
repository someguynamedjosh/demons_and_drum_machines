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
		if animation_time >= 1.0:
			animation_time = 1.0
			animation = ANIM_NONE
			holding.get_parent_spatial().remove_child(holding)
			held_parent.add_child(holding)
			holding.transform = Transform.IDENTITY
		else:
			holding.transform = source.interpolate_with(target, animation_time)

func physics_process(crosshair_raycast_result: Dictionary):
	if pick_up_requested:
		pick_up_requested = false
		pick_up_raycast_result(crosshair_raycast_result)

func pick_up_raycast_result(result):
	if 'collider' in result:
		pick_up_collider(result.collider)

func pick_up_collider(collider):
	var root_obj = collider.get_parent_spatial()
	pick_up_object(root_obj)

func pick_up_object(root_obj):
	if root_obj.has_method("on_pick_up"):
		root_obj.on_pick_up()
		holding = root_obj
		object_put_down_transform = holding.transform
		animation = ANIM_PICK_UP
		animation_time = 0.0
