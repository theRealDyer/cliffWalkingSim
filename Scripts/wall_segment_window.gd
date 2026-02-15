@tool
extends Node3D

# Overall wall size
@export var wall_length: float = 3.0:
	set(v):
		wall_length = maxf(v, 0.2)
		_apply()

@export var wall_height: float = 2.4:
	set(v):
		wall_height = maxf(v, 0.2)
		_apply()

@export var thickness: float = 0.2:
	set(v):
		thickness = maxf(v, 0.02)
		_apply()

# Window opening size + placement
@export var window_width: float = 1.2:
	set(v):
		window_width = maxf(v, 0.2)
		_apply()

@export var window_height: float = 1.0:
	set(v):
		window_height = maxf(v, 0.2)
		_apply()

# Height from floor to bottom of window opening (sill height)
@export var sill_height: float = 1.0:
	set(v):
		sill_height = maxf(v, 0.0)
		_apply()

# Minimum frame/border thickness so we never end up with zero-size pieces
@export var min_frame: float = 0.05:
	set(v):
		min_frame = maxf(v, 0.01)
		_apply()

@onready var left_vis: MeshInstance3D = $Visual/Left
@onready var right_vis: MeshInstance3D = $Visual/Right
@onready var below_vis: MeshInstance3D = $Visual/Below
@onready var above_vis: MeshInstance3D = $Visual/Above

@onready var left_col: CollisionShape3D = $Body/LeftCol
@onready var right_col: CollisionShape3D = $Body/RightCol
@onready var below_col: CollisionShape3D = $Body/BelowCol
@onready var above_col: CollisionShape3D = $Body/AboveCol

func _ready() -> void:
	_apply()

func _apply() -> void:
	if not is_inside_tree():
		return

	# Clamp window to fit inside wall with a small safety margin
	var max_open_width: float = maxf(wall_length - (min_frame * 2.0), min_frame)
	var usable_window_width: float = minf(window_width, max_open_width)

	# Vertical: ensure sill + window fits under top with a minimum above piece
	var max_open_height: float = maxf(wall_height - (min_frame * 2.0), min_frame)
	var usable_window_height: float = minf(window_height, max_open_height)

	# Clamp sill so there is room above and below
	var max_sill: float = maxf(wall_height - usable_window_height - min_frame, 0.0)
	var usable_sill: float = minf(sill_height, max_sill)

	var window_bottom: float = usable_sill
	var window_top: float = usable_sill + usable_window_height

	# Frame piece sizes
	var side_width: float = maxf((wall_length - usable_window_width) * 0.5, min_frame)
	var below_height: float = maxf(window_bottom, min_frame)
	var above_height: float = maxf(wall_height - window_top, min_frame)

	# Centers (bottom of wall at y=0, wall centered on origin in X)
	var y_center_wall: float = wall_height * 0.5
	var x_left: float = -(usable_window_width * 0.5 + side_width * 0.5)
	var x_right: float = (usable_window_width * 0.5 + side_width * 0.5)

	# Left/right pieces span full height
	var left_size := Vector3(side_width, wall_height, thickness)
	var right_size := Vector3(side_width, wall_height, thickness)

	# Below piece spans between left/right, up to window bottom
	var below_size := Vector3(usable_window_width, below_height, thickness)
	var y_center_below: float = below_height * 0.5

	# Above piece spans between left/right, from window top to wall top
	var above_size := Vector3(usable_window_width, above_height, thickness)
	var y_center_above: float = window_top + above_height * 0.5

	_set_box(left_vis, left_size, Vector3(x_left, y_center_wall, 0.0))
	_set_box(right_vis, right_size, Vector3(x_right, y_center_wall, 0.0))
	_set_box(below_vis, below_size, Vector3(0.0, y_center_below, 0.0))
	_set_box(above_vis, above_size, Vector3(0.0, y_center_above, 0.0))

	_set_col(left_col, left_size, Vector3(x_left, y_center_wall, 0.0))
	_set_col(right_col, right_size, Vector3(x_right, y_center_wall, 0.0))
	_set_col(below_col, below_size, Vector3(0.0, y_center_below, 0.0))
	_set_col(above_col, above_size, Vector3(0.0, y_center_above, 0.0))

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
