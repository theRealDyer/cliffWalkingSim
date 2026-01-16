extends Node

@export var lighting_rig_path: NodePath
@export var player_path: NodePath

@export var morning_spawn_path: NodePath
@export var afternoon_spawn_path: NodePath
@export var evening_spawn_path: NodePath

@onready var lighting_rig = get_node(lighting_rig_path)
@onready var player: Node3D = get_node(player_path)

@onready var morning_spawn: Node3D = get_node(morning_spawn_path)
@onready var afternoon_spawn: Node3D = get_node(afternoon_spawn_path)
@onready var evening_spawn: Node3D = get_node(evening_spawn_path)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				_set_act(0)
			KEY_2:
				_set_act(1)
			KEY_3:
				_set_act(2)

func _set_act(act_index: int) -> void:
	# apply lighting preset
	if lighting_rig.has_method("apply_part"):
		lighting_rig.apply_part(act_index)

	# move player to the matching spawn (optional but handy)
	match act_index:
		0:
			player.global_transform = morning_spawn.global_transform
		1:
			player.global_transform = afternoon_spawn.global_transform
		2:
			player.global_transform = evening_spawn.global_transform
