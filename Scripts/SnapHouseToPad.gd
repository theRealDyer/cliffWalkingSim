@tool
extends Node3D

@export var house_root: NodePath
@export var house_anchor: NodePath
@export var pad_anchor: NodePath
@export var snap_now: bool = false:
	set = _do_snap


func _do_snap(v: bool) -> void:
	if not v:
		return
	_snap()
	# leave snap_now alone (untick/re-tick to run again)


func _snap() -> void:
	if not is_inside_tree():
		return

	var house := get_node_or_null(house_root) as Node3D
	var h_anchor := get_node_or_null(house_anchor) as Node3D
	var p_anchor := get_node_or_null(pad_anchor) as Node3D

	if house == null or h_anchor == null or p_anchor == null:
		push_warning("Snap failed: assign house_root, house_anchor, pad_anchor.")
		return

	if not house.is_ancestor_of(h_anchor):
		push_warning("Snap failed: house_anchor is not a child of house_root. Check NodePaths.")
		return

	var house_to_anchor: Transform3D = (
		house.global_transform.affine_inverse() * h_anchor.global_transform
	)
	house.global_transform = p_anchor.global_transform * house_to_anchor.affine_inverse()
