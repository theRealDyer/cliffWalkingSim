@tool
extends Node3D
## This is just a designer tool that helps keep the MeshInstance and
## CollisionShape the same size (using exported inspector variables whilst we’re
## using simple greybox assets. Later, we’ll bring in our own (or downloaded)
## assets and CollisionShape will get resized as its own thing.

@export var length: float:
	get:
		return _length
	set(value):
		_length = max(value, 0.01)
		_apply()
@export var height: float:
	get:
		return _height
	set(value):
		_height = max(value, 0.01)
		_apply()
@export var thickness: float:
	get:
		return _thickness
	set(value):
		_thickness = max(value, 0.01)
		_apply()

var _length := 2.0
var _height := 2.3
var _thickness := 0.2


func _ready() -> void:
	_apply()


func _apply() -> void:
	if not is_inside_tree():
		return

	var mesh_instance := get_node_or_null("Mesh") as MeshInstance3D
	var collision_shape := get_node_or_null("Body/Collision") as CollisionShape3D
	var body := get_node_or_null("Body") as Node3D

	if mesh_instance == null or collision_shape == null or body == null:
		return

	# Visual mesh
	var box_mesh := mesh_instance.mesh as BoxMesh
	if box_mesh == null:
		box_mesh = BoxMesh.new()
		mesh_instance.mesh = box_mesh
	else:
		## This ensures per-instance edits don't affect other walls when the
		## resource is shared.
		if not box_mesh.resource_local_to_scene:
			box_mesh = box_mesh.duplicate()
			box_mesh.resource_local_to_scene = true
			mesh_instance.mesh = box_mesh

	box_mesh.size = Vector3(_length, _height, _thickness)

	# Collision
	var box_shape := collision_shape.shape as BoxShape3D
	if box_shape == null:
		box_shape = BoxShape3D.new()
		collision_shape.shape = box_shape
	else:
		if not box_shape.resource_local_to_scene:
			box_shape = box_shape.duplicate()
			box_shape.resource_local_to_scene = true
			collision_shape.shape = box_shape

	box_shape.size = Vector3(_length, _height, _thickness)

	# make the wall sit on the floor (bottom at y = 0)
	mesh_instance.position.y = _height * 0.5
	body.position.y = _height * 0.5
