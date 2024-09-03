class_name ColorEnemy
extends Enemy

@onready var states: Node = $States

@onready var move_down_state = %MoveDownState
@onready var move_side_state = %MoveSideState
@onready var pause_state = %PauseState
@onready var move_side_component = %MoveSideState/MoveSideComponent
@onready var projectile_spawn = %FireState/ProjectileSpawn
@onready var fire_state = %FireState

func _ready() -> void: 
	super()
	
	for state in states.get_children():
		state = state as StateComponent
		state.disable()
		
	move_side_component.velocity.x = [-20, 20].pick_random()
	
	move_down_state.state_finished.connect(move_side_state.enable)
	move_side_state.state_finished.connect(func():
		scale_component.tween_scale()
		projectile_spawn.spawn(global_position)
		fire_state.disable()
		fire_state.state_finished.emit()
	)
	fire_state.state_finished.connect(pause_state.enable)
	pause_state.state_finished.connect(move_down_state.enable)
	move_down_state.enable()
	
