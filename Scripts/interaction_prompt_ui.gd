class_name InteractablePromptUI
extends CanvasLayer
## Controls to popup UI for any interactable object in the game

@export var camera: Camera3D

var _last_world_position: Vector3

@onready var label = $PanelContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	visible = false
	
	
func _process(_delta) -> void:
	if visible:
		# Keep it close to the object
		update_position(_last_world_position)


func set_camera(cam: Camera3D) -> void:
	camera = cam


func show_prompt(text: String, world_position: Vector3) -> void:
	label.text = "Press [E] to %s" % text
	visible = true
	update_position(world_position)


func hide_prompt() -> void:
	visible = false


func update_position(world_position: Vector3) -> void:
	_last_world_position = world_position
	var screen_position = camera.unproject_position(world_position)
	#print(screen_position)
	$PanelContainer.global_position = screen_position
