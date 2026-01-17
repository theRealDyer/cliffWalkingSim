## Script to set the basic functionality of all interactables in the game
extends Node3D
class_name Interactable

@export var interaction_text: String = "Interact"

func can_interact(_interactor: Node) -> bool:
	return true
	
func interact(_interactor: Node) -> void:
	pass
