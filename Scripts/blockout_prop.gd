@tool
extends Node3D

@export var width: float = 1.0:
	set(v):
		width = maxf(v, 0.05)
		_apply()

@export var height: float = 1.0:
	set(v):
		height = maxf(v, 0.05)
		_apply()

@export var depth: float = 1.0:
	set(v):
		depth = maxf(v, 0.05)
		_apply()

@onready var mesh_instance: MeshInstance3D = $Mesh
@onready var body: StaticBody3D = $Body
@onready var collision: CollisionShape3D = $Body/Collision


func _ready() -> void:
	_apply()


func _apply() -> void:
	if not is_inside_tree():
		return

	# Visual
	var box_mesh := BoxMesh.new()
	box_mesh.size = Vector3(width, height, depth)
	mesh_instance.mesh = box_mesh

	# Collision
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(width, height, depth)
	collision.shape = box_shape

	# Sit on floor (bottom at y = 0)
	mesh_instance.position.y = height * 0.5
	body.position.y = height * 0.5
