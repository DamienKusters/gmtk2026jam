extends Node2D
class_name NewspaperComponent

signal shot_ready

@onready var van: Van = get_parent()

@export var cooldown := 2.0

var projectile: Node2D
var projectile_position_normalized

var shoot_direction: Vector2i

func _ready() -> void:
	van.ready.connect(_late_ready)

func _late_ready():
	$CooldownTimer.timeout.connect(func(): shot_ready.emit())
	$CooldownTimer.wait_time = cooldown

func shoot():
	if projectile:
		_reset_projectile()
	shoot_direction = van.direction
	projectile = $ParticleTemplate.duplicate()
	projectile.visible = true
	projectile.position = van.location_normalized * van.MOVE_LENGTH
	projectile_position_normalized = van.location_normalized
	van.get_parent().add_child(projectile)
	$Timer.start()
	$CooldownTimer.start()
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	if !projectile:
		return
		
	var next_tile = van.get_next_tile(projectile_position_normalized, shoot_direction)
	
	if van.tilemap.try_deliver_newspaper(next_tile['coords'], next_tile['tile'], shoot_direction):
		van.reset_quota_timer()
		_reset_projectile()
		return
	elif next_tile['tile']["inaccessable"] or van.tilemap.tile_is_house(next_tile['tile']):
		_reset_projectile()
		return
	
	projectile_position_normalized = next_tile['coords']
	_animate_move(projectile_position_normalized * van.MOVE_LENGTH)

func _reset_projectile():
	$Timer.stop()
	projectile_position_normalized = null
	projectile.call_deferred("queue_free")

var move_tween: Tween
func _animate_move(new_position: Vector2):
	move_tween = Globals.animate(move_tween, self)
	move_tween.tween_property(projectile, "position", new_position, $Timer.wait_time)
