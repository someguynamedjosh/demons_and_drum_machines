extends "Interactable.gd"

export var target_value = 0.0
var display_value = target_value
export var snapping: float = 0.0
export var minimum: float = -9e9
export var maximum: float = 9e9

signal display_value_updated(new_display_value)

func on_interact_move(delta: Vector2):
	var speed = 2.0
	set_instant(clamp_(target_value + speed * (delta.x - delta.y)))

func clamp_(value):
	# Yes, the functions used look backwards, but the logic is correct.
	if maximum < 9e9:
		# We want the smallest of these values because we should never go over the max.
		value = min(maximum, value)
	if minimum > -9e9:
		# We want the largest of these values because we should never go under the min.
		value = max(minimum, value)
	return value

func clamp_and_snap(value):
	value = clamp_(value)
	if snapping != 0.0:
		value = round(value / snapping) * snapping
	return value

func set_instant(value):
	target_value = value
	display_value = value
	emit_signal("display_value_updated", value)

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
		var old_display_value = display_value
		display_value = lerp(target_value, display_value, pow(2.0, -delta * speed))
		if abs(display_value - old_display_value) > 1e-5:
			emit_signal("display_value_updated", display_value)
	$Display.rotation.y = -display_value

func captures_cursor():
	return true

func on_interact_end():
	target_value = clamp_and_snap(target_value)
	.on_interact_end()
