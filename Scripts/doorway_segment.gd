@tool
extends Node3D

# Overall wall size
@export var wall_length: float = 3.0:
	set(v):
		wall_length = max(v, 0.2)
		_apply()
@export var wall_height: float = 2.4:
	set(v):
		wall_height = max(v, 0.2)
		_apply()
@export var thickness: float = 0.2:
	set(v):
		thickness = max(v, 0.02)
		_apply()
# Door opening size
@export var door_width: float = 0.9:
	set(v):
		door_width = max(v, 0.2)
		_apply()
@export var door_height: float = 2.0:
	set(v):
		door_height = max(v, 0.2)
		_apply()

@onready var left_vis: MeshInstance3D = $Visual/Left
@onready var right_vis: MeshInstance3D = $Visual/Right
@onready var header_vis: MeshInstance3D = $Visual/Header
@onready var left_col: CollisionShape3D = $Body/LeftCol
@onready var right_col: CollisionShape3D = $Body/RightCol
@onready var header_col: CollisionShape3D = $Body/HeaderCol


func _ready() -> void:
	_apply()


func _apply() -> void:
	if not is_inside_tree():
		return

	# Clamp door to fit inside wall
	var usable_door_width = min(door_width, wall_length - 0.2)
	var usable_door_height = min(door_height, wall_height - 0.2)

	var side_width = (wall_length - usable_door_width) * 0.5
	side_width = max(side_width, 0.05)

	var header_height = wall_height - usable_door_height
	header_height = max(header_height, 0.05)

	# Sizes
	var left_size := Vector3(side_width, wall_height, thickness)
	var right_size := Vector3(side_width, wall_height, thickness)
	var header_size := Vector3(usable_door_width, header_height, thickness)

	# Positions (centered wall, bottom at y=0)
	var y_center_wall := wall_height * 0.5
	var y_center_header = usable_door_height + header_height * 0.5

	var x_left = -(usable_door_width * 0.5 + side_width * 0.5)
	var x_right = (usable_door_width * 0.5 + side_width * 0.5)

	_set_box(left_vis, left_size, Vector3(x_left, y_center_wall, 0.0))
	_set_box(right_vis, right_size, Vector3(x_right, y_center_wall, 0.0))
	_set_box(header_vis, header_size, Vector3(0.0, y_center_header, 0.0))

	_set_col(left_col, left_size, Vector3(x_left, y_center_wall, 0.0))
	_set_col(right_col, right_size, Vector3(x_right, y_center_wall, 0.0))
	_set_col(header_col, header_size, Vector3(0.0, y_center_header, 0.0))


func _set_box(mi: MeshInstance3D, size: Vector3, pos: Vector3) -> void:
	var bm := BoxMesh.new()
	bm.size = size
	mi.mesh = bm
	mi.position = pos


func _set_col(cs: CollisionShape3D, size: Vector3, pos: Vector3) -> void:
	var shape := BoxShape3D.new()
	shape.size = size
	cs.shape = shape
	cs.position = pos
