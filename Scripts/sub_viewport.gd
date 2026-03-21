extends SubViewport

var last_mouse_pos := Vector2.ZERO
var dragging := false
var sensitivity := 0.1
var model = null
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	connect("child_entered_tree", get_item_reference)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed # Only dragging if holding button
			last_mouse_pos = event.position
	
	elif event is InputEventMouseMotion and dragging and model:
		var delta = event.position - last_mouse_pos
		last_mouse_pos = event.position
		
		# Rotate the object
		model.rotate_y(-delta.x * sensitivity)
		model.rotate_x(delta.y * sensitivity)
		
		
func get_item_reference(_sig):
	model = get_child(-1)
	print(model)
	
