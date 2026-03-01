extends CharacterBody3D

const MIN_PITCH := deg_to_rad(-60)
const MAX_PITCH := deg_to_rad(60)

@export_group("Interactions")
@export var interaction_ray: RayCast3D
@export var prompt_ui: InteractablePromptUI
@export_group("Movement")
@export var speed := 5.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.005



# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_interactable: Interactable = null # Sets the current interactable object if any
var can_look := false # Whether to allow camera movement

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var item_inspector := $ItemInspector

func _ready() -> void:
	prompt_ui.set_camera(camera)


func _process(_delta) -> void:
	update_interactable()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var neck_basis: Basis = neck.global_transform.basis # relative to the world not parent
	neck_basis.y = Vector3.UP
	neck_basis = neck_basis.orthonormalized()

	var direction = (neck_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_capture"):
		can_look = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion and can_look:
		neck.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, MIN_PITCH, MAX_PITCH)

	if event.is_action_pressed("interact") and current_interactable:
		var interact_return = current_interactable.interact(self)
		prompt_ui.hide_prompt()
		if interact_return is Dictionary:
			item_inspector.item = current_interactable.preview_scene
			item_inspector.item_name = interact_return["item_name"]
			item_inspector.item_description = interact_return["item_description"]
			
			item_inspector.visible=true


func _unhandled_input(event: InputEvent) -> void:
	# Used for final inputs only for escaping UI's etc
	if event.is_action_pressed("ui_cancel"):
		can_look = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func get_interactable_from_collider(collider: Object):
	# Grab the interactable node of a given collider for access to interact functions
	# Sometimes this is the collider itself, other times it might be a parent of the collider
	if collider is Interactable:
		return collider

	# Step up parents till we find an Interactable
	var node = collider
	while node:
		if node is Interactable:
			return node
		node = node.get_parent()

	# If no Interactable is found
	return null


func update_interactable():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		var interactable = get_interactable_from_collider(collider)
		# If looking at an interactable item -> display relevant interact prompt
		if interactable is Interactable and interactable.can_interact(self):
			if interactable != current_interactable:
				current_interactable = interactable
				prompt_ui.show_prompt(
					interactable.get_interaction_text(),
				)
			return

	# If not looking at interactable -> clear cache
	clear_interactable()


func set_current_interactable(_interactable: Interactable) -> void:
	current_interactable = _interactable


func clear_interactable():
	if current_interactable:
		current_interactable = null
		prompt_ui.hide_prompt()
