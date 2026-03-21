extends Interactable
## Controls the interaction pickup and display of the book
@export_group("Interaction Info")
@export var item_name: String
@export var item_description: String

@onready var item_info: Dictionary = {
	"item_name": item_name,
	"item_description": item_description
	}

func get_interaction_text() -> String:
	return interaction_text
	
func interact(_interactor: Node) -> Dictionary:
	return item_info
	
