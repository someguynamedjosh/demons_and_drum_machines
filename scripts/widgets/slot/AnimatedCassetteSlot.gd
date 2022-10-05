extends "CassetteSlot.gd"

var opened_amount = 0.0
var opened_amount_target = 0.0
const OPEN_ANGLE = -0.7
const CLOSED_ANGLE = 0.0
const ANIM_TIME = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered or insertion_in_progress:
		opened_amount_target = 1.0
	else:
		opened_amount_target = 0.0
	var movement = delta / ANIM_TIME
	if abs(opened_amount - opened_amount_target) < movement:
		opened_amount = opened_amount_target
	elif opened_amount_target > opened_amount:
		opened_amount += movement
	elif opened_amount_target < opened_amount:
		opened_amount -= movement
		
	var angle = lerp(CLOSED_ANGLE, OPEN_ANGLE, opened_amount)
	$Hinge.rotation.z = angle
	$MovingCollision.rotation.z = angle

func get_insertion_point() -> Spatial:
	return $Hinge/InsertionPoint as Spatial
