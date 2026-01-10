'''
this script snaps the house and landscape together in the main
(world) environment so they stay connected where we want them.
'''

@tool
extends Node3D

@export var house_root: NodePath
@export var house_anchor: NodePath
@export var pad_anchor: NodePath

'''
Clicking this check box in the inspector will snap the anchors to their specified place (as 
defined in their own scenes); it will then reset back to false immediately.
'''
@export var snap_now: bool = false : set = _do_snap

func _do_snap(v: bool) -> void:
	snap_now = false
	if not v:
		return
	if not is_inside_tree():
		return

	var house := get_node_or_null(house_root) as Node3D
	var h_anchor := get_node_or_null(house_anchor) as Node3D
	var p_anchor := get_node_or_null(pad_anchor) as Node3D

	if house == null or h_anchor == null or p_anchor == null:
		push_warning("Snap failed: assign house_root, house_anchor, pad_anchor.")
		return

	# Transform of house_anchor in house_root local space
	var house_to_anchor: Transform3D = house.global_transform.affine_inverse() * h_anchor.global_transform

	# We want: house.global = pad.global * inverse(house_to_anchor)
	house.global_transform = p_anchor.global_transform * house_to_anchor.affine_inverse()
