## Controls the door interactable, when the player is within the interactable area of the door
## it is marked as "interactable". If the player then presses `e` to interact, the door then opens
extends Node3D

@export_group("Door Motion")
@export var door_motion_angle: float = 85 # Degrees
@export var door_motion_speed: float = 1.0 # Seconds
@export var door_opened := false
@onready var interaction_area: Area3D = $InteractionArea


func _ready() -> void:
	interaction_area.connect("body_entered", _on_body_entered)
	interaction_area.connect("body_exited", _on_body_exited)

	if door_opened:
		# Open door if initilised open
		rotate(Vector3.UP, PI / 2)


var player_in_area = null


func _on_body_entered(body) -> void:
	# If the player enters the area, mark door as interactable
	if body.is_in_group("Player"):
		player_in_area = body
		body.set_current_interactable(self)


func _on_body_exited(body) -> void:
	# If the player exists the area, mark the door as not interactable
	if body.is_in_group("Player"):
		body.clear_current_interactable()
		player_in_area = null


func interact():
	print("Door Opened/Closed")
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
