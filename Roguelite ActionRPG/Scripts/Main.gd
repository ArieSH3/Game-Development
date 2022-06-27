extends Node2D


onready var enemy = preload("res://Scenes/Enemy.tscn")

var enemy_spawn_rate = 3
var can_spawn = true
var pos
var resolution = OS.get_window_size()
var spawn_offset = 150

func _ready():
	# There to randomize the seed every time the game starts so the spawn points
	#	are always different
	randomize()
	print('Resolution: ', resolution.x)
	

func _process(_delta):
	if can_spawn:
		spawn_enemy()
	
	
func spawn_enemy():
	pos = Vector2(rand_range(-spawn_offset, resolution.x + spawn_offset), rand_range(-spawn_offset, resolution.y + spawn_offset))
	while pos.x < resolution.x and pos.x > 0 or pos.y < resolution.y and pos.y > 0:
		pos = Vector2(rand_range(-spawn_offset, resolution.x + spawn_offset), rand_range(-spawn_offset, resolution.y + spawn_offset))
	
	var enm = enemy.instance()
	enm.position = pos
	add_child(enm)
	can_spawn = false
	yield (get_tree().create_timer(enemy_spawn_rate), 'timeout')
	can_spawn = true
	

