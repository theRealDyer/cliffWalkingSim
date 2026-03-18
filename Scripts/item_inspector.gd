extends CanvasLayer

@export var item: PackedScene
@export var item_name: String
@export var item_description: String

@onready var item_viewer: SubViewport = \
$CenterContainer/HBoxContainer/MarginContainer/ItemInspect/SubViewportContainer/SubViewport
@onready var item_name_label: RichTextLabel = \
$CenterContainer/HBoxContainer/MarginContainer2/ItemDescription/VBoxContainer/ItemName
@onready var item_description_label: RichTextLabel = \
$CenterContainer/HBoxContainer/MarginContainer2/ItemDescription/VBoxContainer/ItemDescription
@onready var camera_3d: Camera3D = \
$CenterContainer/HBoxContainer/MarginContainer/ItemInspect/SubViewportContainer/SubViewport/Camera3D
@onready var button: Button = $MarginContainer/Button

signal closed

func _ready() -> void:
	connect("visibility_changed", update_inspector)
	if item != null:
		var item_instance = item.instantiate()
		item_viewer.add_child(item_instance)
		frame_model(item_instance)
	
func frame_model(model: Node3D):
	model.rotate(Vector3(1,0,0), PI/3)
	var aabb = model.get_combined_aabb(model)
	print(aabb)
	var size = aabb.size.length()
	camera_3d.global_position = Vector3(0, 0, size*1.5)
	camera_3d.look_at(Vector3.ZERO)


func update_inspector():
	if item != null:
		var item_instance = item.instantiate()
		item_viewer.add_child(item_instance)
		if visible == true:
			frame_model(item_instance)
		elif visible == false:
			item_viewer.remove_child(item_instance)
		else:
			push_error("No item to update with")
	

func _on_exit_toggled(_sig) -> void:
	##
	print("trying to exit")
	closed.emit()
