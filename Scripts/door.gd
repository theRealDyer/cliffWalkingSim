## Controls the door interactable, when the player is within the interactable area of the door
## it is marked as "interactable". If the player then presses `e` to interact, the door then opens
extends Interactable

@export_group("Door Motion")
@export var door_motion_angle: float = 85 # Degrees
@export var door_motion_speed: float = 1.0 # Seconds
@export var door_opened := false
var can_move := true


func _ready() -> void:
	if door_opened:
		# Open door if initilised open
		rotate(Vector3.UP, PI / 2)


func get_interaction_text() -> String:
	return "Close" if door_opened else "Open"

func interact(_interactor) -> void:
	if not can_move:
		return
	
	# Restrict further interactions
	can_move = false
	
	# Creating a tween to ease the door rotation rather than quick snaps
	var tween = get_tree().create_tween()
	if not door_opened:
		tween.tween_property(
			self,
			"rotation_degrees:y",
			door_motion_angle,
			door_motion_speed,
		).as_relative()
		door_opened = true
	else:
		tween.tween_property(
			self,
			"rotation_degrees:y",
			-door_motion_angle,
			door_motion_speed,
		).as_relative()
		door_opened = false

	# Reset door to active after finished moving
	tween.tween_callback(on_tween_finished)
	
	
func on_tween_finished() -> void:
	# Allows the door to be interacted with again
	can_move = true
