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

@onready var in_view := false
@onready var item_instance = null

signal closed


func _ready() -> void:
	connect("visibility_changed", update_inspector)


func frame_model(model: Node3D):
	model.rotate(Vector3(1, 0, 0), PI / 3)
	var aabb = model.get_combined_aabb(model)
	var size = aabb.size.length()
	camera_3d.global_position = Vector3(0, 0, size * 1.5)
	camera_3d.look_at(Vector3.ZERO)


func update_inspector():
	if item != null:
		if (visible == true) and (item_instance == null):
			# If item not in the window, add it
			item_instance = item.instantiate()
			item_viewer.add_child(item_instance)

			frame_model(item_instance)
			update_text()
		elif visible == false:
			item_viewer.remove_child(item_instance)
			item_instance = null
		else:
			push_error("No item to update with")


func update_text():
	item_name_label.text = "[b]" + item_name + "[/b]"
	item_description_label.text = item_description


func _on_exit_toggled(_sig) -> void:
	##
	closed.emit()


func _on_button_toggled(_toggled_on: bool) -> void:
	## Resets the rotation of the model in viewport
	item_instance = item_viewer.get_child(-1)
	item_instance.rotation = Vector3(PI / 3, 0, 0)
