extends Node

signal money_updated
signal van_used_ability(van: Van, upgrade: UpgradeEnum)

enum UpgradeEnum { BOY, PROPAGANDA, HELI }
var upgrades: Dictionary[UpgradeEnum, int] = {
	#UpgradeEnum.BOY: 1,
	#UpgradeEnum.PROPAGANDA: 1,
	#UpgradeEnum.HELI: 4,
}

var music = [
	preload("res://nodes/music/Retrograde.mp3"),
	preload("res://nodes/music/Smart Riot.mp3"),
	preload("res://nodes/music/Snake on the Beach.mp3"),
	preload("res://nodes/music/Sugar Zone.mp3"),
]

var sfx = {
	&"bump": preload("res://nodes/sfx/hitHurt.wav"),
	&"deliver": preload("res://nodes/sfx/pickupCoin.wav"),
	&"throw": preload("res://nodes/sfx/powerUp.wav"),
	&"propaganda": preload("res://nodes/sfx/propaganda.wav"),
}

var scenes = {
	&"game": preload("res://nodes/game.tscn"),
	&"tutorial": preload("res://nodes/game.tscn"),
	&"menu": preload("res://nodes/menu/menu.tscn"),
}

var money := 0 : 
	set(value):
		money = value
		money_updated.emit()

func _ready():
	$AudioStreamPlayer.finished.connect(_play_random_song)
	_play_random_song()
	
func load_scene(key: StringName):
	get_tree().change_scene_to_packed.call_deferred(scenes[key])

func play_sound(key: StringName, random_pitch := true):
	if random_pitch:
		$SFXPlayer.pitch_scale = randf_range(0.8, 1.2)
	$SFXPlayer.stream = sfx[key]
	$SFXPlayer.play()

func animate(tween: Tween, parent: Node):
	if tween:
		tween.kill()
	return parent.create_tween()
	
func _play_random_song():
	$AudioStreamPlayer.stream = music.pick_random()
	$AudioStreamPlayer.play()
