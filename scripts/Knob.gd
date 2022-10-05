extends MeshInstance

export var hovered_mat: Material
var target_value = 0.0
var display_value = 0.0
var snapping = null
var minimum = null
var maximum = null
var interacting = false

func on_interact_move(delta):
	var speed = 2.0
	set_instant(clamp_(target_value + speed * (delta.x - delta.y)))

func clamp_(value):
	# Yes, the functions used look backwards, but the logic is correct.
	if maximum != null:
		# We want the smallest of these values because we should never go over the max.
		value = min(maximum, value)
	if minimum != null:
		# We want the largest of these values because we should never go under the min.
		value = max(minimum, value)
	return value

func clamp_and_snap(value):
	value = clamp_(value)
	if snapping != null:
		value = round(value / snapping) * snapping
	return value

func set_instant(value):
	target_value = value
	display_value = value

func set_animated(value):
	target_value = clamp_and_snap(value)

func set_range(new_min, new_max):
	minimum = new_min
	maximum = new_max
	target_value = clamp_(target_value)

func set_snapping(new_snap):
	snapping = new_snap
	if not interacting:
		target_value = clamp_and_snap(target_value)

func get_display_value():
	return display_value

func get_target_value():
	return clamp_and_snap(target_value)

func _process(delta):
	# Slowly move to target_value (this equation animates the same regardless
	# of the framerate)
	var speed = 10.0
	if not interacting:
		display_value = lerp(target_value, display_value, pow(2.0, -delta * speed))
	rotation.x = -display_value

func on_interact_start():
	interacting = true
	return true

func on_interact_end():
	interacting = false
	target_value = clamp_and_snap(target_value)
	
func on_hover_start():
	material_override = hovered_mat

func on_hover_end():
	material_override = null
