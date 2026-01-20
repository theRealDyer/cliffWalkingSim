@tool
extends Node3D
## This is just a designer tool that helps keep the MeshInstance and
## CollisionShape the same size (using exported inspector variables whilst we’re
## using simple greybox assets. Later, we’ll bring in our own (or downloaded)
## assets and CollisionShape will get resized as its own thing.

@export var width: float = 2.0:
	set(v):
		width = max(v, 0.01)
		_apply()
@export var depth: float = 2.0:
	set(v):
		depth = max(v, 0.01)
		_apply()
# Collision thickness
@export var thickness: float = 0.2:
	set(v):
		thickness = max(v, 0.01)
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
	var box := BoxMesh.new()
	box.size = Vector3(width, thickness, depth)
	mesh_instance.mesh = box

	# Collision
	var shape := BoxShape3D.new()
	shape.size = Vector3(width, thickness, depth)
	collision.shape = shape
