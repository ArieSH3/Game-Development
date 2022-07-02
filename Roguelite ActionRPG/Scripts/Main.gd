extends Node2D


onready var enemy = preload("res://Scenes/Enemy.tscn")

var enemy_spawn_rate = 0.1 #0.5 # 3 # Every how long enemy spawns
var can_spawn = true
var pos
var resolution = OS.get_window_size()
var spawn_offset = 150
var player_position = Vector2.ZERO
var max_enemies_on_map = 1

func _ready():
	# There to randomize the seed every time the game starts so the spawn points
	#	are always different
	randomize()
	

func _process(_delta):
	if can_spawn:
		spawn_enemy()
	#print(get_tree().get_nodes_in_group("Enemies").size())
	
	
func spawn_enemy():
	# Sets the mob spawns to happen around the player wherever he moves
	#	We take player position and move the spawn point by half of the resolution on x or y axis
	#	and place an offset for how far the mobs will spawn from that edge point of the screen
	
	# Checks if there is a certain limit of mobs on map and then it stops spawning more to not clog up memory
	if get_tree().get_nodes_in_group('Enemies').size() < max_enemies_on_map:
		player_position = get_node("Character").position
		pos = Vector2(rand_range(player_position.x-(resolution.x/2 + spawn_offset), player_position.x + (resolution.x/2 + spawn_offset)), rand_range(player_position.y-(resolution.y/2 + spawn_offset), player_position.y+(resolution.y/2 + spawn_offset)))
		while pos.x < player_position.x + resolution.x/2 and pos.x > player_position.x - resolution.x/2 or pos.y < player_position.y + resolution.y/2 and pos.y > player_position.y - resolution.y/2:
			pos = Vector2(rand_range(player_position.x-(resolution.x/2 + spawn_offset), player_position.x + (resolution.x/2 + spawn_offset)), rand_range(player_position.y-(resolution.y/2 + spawn_offset), player_position.y+(resolution.y/2 + spawn_offset)))
		
		var enm = enemy.instance()
		enm.position = pos
		add_child(enm)
		can_spawn = false
		yield (get_tree().create_timer(enemy_spawn_rate), 'timeout')
		can_spawn = true
