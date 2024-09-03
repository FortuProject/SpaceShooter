extends Node2D

@onready var left_muzzle = $LeftMuzzle
@onready var right_muzzle = $RightMuzzle
@onready var spawner_component: SpawnerComponent = $SpawnerComponent as SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var scale_component: ScaleComponent = $ScaleComponent as ScaleComponent
@onready var animated_sprite_2d = $anchor/AnimatedSprite2D
@onready var move_component = $MoveComponent
@onready var stats_component = $StatsComponent
@onready var flash_component = $FlashComponent
@onready var flash_component_2 = $FlashComponent2
@onready var shake_component = $ShakeComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer

func _ready() -> void: 
	fire_rate_timer.timeout.connect(fire_lasers)
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		if stats_component.health == 1:
			flash_component_2.flash()
		else:
			flash_component.flash()
		
		scale_component.tween_scale()
		shake_component.tween_shake()
	)
	stats_component.no_health.connect(queue_free)


func fire_lasers() -> void:
	variable_pitch_audio_stream_player.play_with_variance()
	spawner_component.spawn(left_muzzle.global_position)
	spawner_component.spawn(right_muzzle.global_position)
	scale_component.tween_scale()

func _process(delta: float) -> void:
	animate_the_ship()
	
func animate_the_ship() -> void: 
	if move_component.velocity.x < 0: 
		animated_sprite_2d.play("bank_left")
		left_muzzle.position = Vector2(-11,-7)
		right_muzzle.position = Vector2(7,-10)
	elif move_component.velocity.x > 0:
		animated_sprite_2d.play("bank_right")
		left_muzzle.position = Vector2(-7,-10)
		right_muzzle.position = Vector2(11,-7)
	else: 
		animated_sprite_2d.play("center")
		left_muzzle.position = Vector2(-11,-9)
		right_muzzle.position = Vector2(11,-9)
