class_name Interactable
extends Node3D
## Script to set the basic functionality of all interactables in the game

@export var interaction_text: String = "Interact"
@export var preview_scene: PackedScene


func can_interact(_interactor: Node) -> bool:
	return true


func interact(_interactor: Node):
	pass


func get_combined_aabb(root: Node3D, first := true):
	# Gets the total bounding box of the mesh instance for better camera framing
	var aabb := AABB()

	for node in root.get_children():
		if node is MeshInstance3D:
			# Only MeshInstances have an aabb value we care about
			var node_aabb = node.get_aabb()
			if first:
				aabb = node_aabb
				first = false
			else:
				aabb = aabb.merge(node_aabb)

		if node.get_child_count() > 0:
			# Check if node has children, if so recursively get all aabbs for each MeshInstance
			var child_aabb = get_combined_aabb(node, first)

			if not first:
				aabb = aabb.merge(child_aabb)
			else:
				aabb = child_aabb
				first = false
	return aabb
