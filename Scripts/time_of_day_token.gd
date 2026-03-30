extends Interactable

@export var act_switcher_path: NodePath
@export var part_index: int = 0
@export var label: String = "Morning"

@onready var act_switcher: Node = get_node(act_switcher_path)


func get_interaction_text() -> String:
	return label


func interact(_interactor: Node) -> void:
	if act_switcher and act_switcher.has_method("go_to_act"):
		act_switcher.go_to_act(part_index)
