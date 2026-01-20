class_name InteractablePromptUI
extends CanvasLayer
## Controls to popup UI for any interactable object in the game

@export var camera: Camera3D

@onready var label: RichTextLabel = $CenterContainer/PanelContainer/MarginContainer/RichTextLabel
@onready var panel_container: PanelContainer = $CenterContainer/PanelContainer


func _ready() -> void:
	visible = false


func set_camera(cam: Camera3D) -> void:
	camera = cam


func show_prompt(text: String) -> void:
	label.text = "Press [E] to %s" % text
	visible = true


func hide_prompt() -> void:
	visible = false
