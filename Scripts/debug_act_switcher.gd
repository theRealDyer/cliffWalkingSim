extends Node

@export var lighting_rig_path: NodePath
@export var player_path: NodePath
@export var morning_spawn_path: NodePath
@export var afternoon_spawn_path: NodePath
@export var evening_spawn_path: NodePath

@export var fade_rect_path: NodePath
@export var fade_seconds: float = 1.0
@export var start_act: int = 0 # 0 morning, 1 afternoon, 2 evening

@onready var lighting_rig = get_node(lighting_rig_path)
@onready var player: Node3D = get_node(player_path)
@onready var morning_spawn: Node3D = get_node(morning_spawn_path)
@onready var afternoon_spawn: Node3D = get_node(afternoon_spawn_path)
@onready var evening_spawn: Node3D = get_node(evening_spawn_path)
@onready var fade_rect: ColorRect = get_node(fade_rect_path)

var _transitioning := false
var _tween: Tween

func _ready() -> void:
	# Start game in morning (no fade on boot)
	_set_act_immediate(start_act)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1: go_to_act(0)
			KEY_2: go_to_act(1)
			KEY_3: go_to_act(2)

func go_to_act(act_index: int) -> void:
	if _transitioning:
		return
	_transitioning = true

	if _tween and _tween.is_running():
		_tween.kill()

	# Ensure fade is visible and starts from current alpha
	fade_rect.visible = true

	var half := maxf(fade_seconds * 0.5, 0.01)

	_tween = get_tree().create_tween()
	_tween.tween_property(fade_rect, "modulate:a", 1.0, half)
	_tween.tween_callback(func():
		_apply_act(act_index)
	)
	_tween.tween_property(fade_rect, "modulate:a", 0.0, half)
	_tween.tween_callback(func():
		fade_rect.visible = false
		_transitioning = false
	)

func _set_act_immediate(act_index: int) -> void:
	_apply_act(act_index)
	fade_rect.visible = false
	fade_rect.modulate.a = 0.0
	_transitioning = false

func _apply_act(act_index: int) -> void:
	# apply lighting preset
	if lighting_rig.has_method("apply_part"):
		lighting_rig.apply_part(act_index)

	# move player
	match act_index:
		0: player.global_transform = morning_spawn.global_transform
		1: player.global_transform = afternoon_spawn.global_transform
		2: player.global_transform = evening_spawn.global_transform
