extends Node2D

@export var Enemy1Scene: PackedScene 
@export var Enemy2Scene: PackedScene
@export var Enemy3Scene: PackedScene 

@export var game_stats: GameStats 

var margin = 8
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component = $SpawnerComponent as SpawnerComponent
@onready var enemy1_spawn_timer: Timer = $Enemy1SpawnTimer 
@onready var enemy2_spawn_timer: Timer = $Enemy2SpawnTimer 
@onready var enemy3_spawn_timer: Timer = $Enemy3SpawnTimer 

func _ready() -> void:
	enemy1_spawn_timer.timeout.connect(handle_spawn.bind(Enemy1Scene, enemy1_spawn_timer))
	enemy2_spawn_timer.timeout.connect(handle_spawn.bind(Enemy2Scene, enemy2_spawn_timer))
	enemy3_spawn_timer.timeout.connect(handle_spawn.bind(Enemy3Scene, enemy3_spawn_timer))


func handle_spawn(enemy_scene: PackedScene, timer: Timer, time_offset: float = 1.0) -> void:
	spawner_component.scene = enemy_scene
	spawner_component.spawn(Vector2(randf_range(margin, screen_width-margin), -16))
	var spawn_rate = time_offset / (0.5 + (game_stats.score * 0.01))
	timer.start(spawn_rate + randf_range(0.25, 0.5))
