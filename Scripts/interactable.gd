class_name Interactable
extends Node3D
## Script to set the basic functionality of all interactables in the game

@export var interaction_text: String = "Interact"


func can_interact(_interactor: Node) -> bool:
	return true


func interact(_interactor: Node) -> void:
	pass
