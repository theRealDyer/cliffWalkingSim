## This script sets up the three different parts of the day and loads their
## environments

extends Node3D

enum Part { MORNING, AFTERNOON, EVENING }

@export var morning_env: Environment
@export var afternoon_env: Environment
@export var evening_env: Environment

@export var morning_sun_energy: float = 1.2
@export var afternoon_sun_energy: float = 0.6
@export var evening_sun_energy: float = 0.8

@export var morning_sun_color: Color = Color(1, 1, 1)
@export var afternoon_sun_color: Color = Color(0.95, 0.97, 1.0)
@export var evening_sun_color: Color = Color(1.0, 0.85, 0.7)

@onready var world_env: WorldEnvironment = $WorldEnv
@onready var sun: DirectionalLight3D = $Sun

func apply_part(part: Part) -> void:
	match part:
		Part.MORNING:
			world_env.environment = morning_env
			sun.light_energy = morning_sun_energy
			sun.light_color = morning_sun_color
		Part.AFTERNOON:
			world_env.environment = afternoon_env
			sun.light_energy = afternoon_sun_energy
			sun.light_color = afternoon_sun_color
		Part.EVENING:
			world_env.environment = evening_env
			sun.light_energy = evening_sun_energy
			sun.light_color = evening_sun_color
