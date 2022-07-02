extends KinematicBody2D
# Make enemy stop moving (Maybe with signal) so player can push it around
# Supposed to emit signal that player has been damaged (DONE)
# Trigger an attack speed timer and damage player continuosly until
# 	player exits the area2d of the enemy meaning he is safe (DONE)


export var speed = 100
var motion = Vector2.ZERO
var can_move = true
var can_attack = true
export var attack_rate = 1.5
export var damage = 2
var touching_player = false
var max_health = 1
var current_health
var player_is_dead = false
var enemy_dead = false
var on_hit_flash = 0.08

#onready var enemy_attack_timer = get_node("EnemyAttackTimer")
onready var character = get_parent().get_node('Character')


func _ready():
	var health_bar = get_tree().get_root().find_node('HealthBar', true, false)
	health_bar.connect('player_dead', self, 'on_player_death')
	current_health = max_health



func _process(_delta):
	if !enemy_dead:
		attack_player()



func _physics_process(_delta):
	if !enemy_dead:
		enemy_move()
	
	motion = move_and_slide(motion)


func attack_player():
	if can_attack and touching_player:
		can_attack = false
		# Calls the group HPBar in which our health is stored and now whenever
		#	an enemy touches the player the HP decreases
		#	(Previous problem we had with using Node Signals instead of 
		#	Node Groups was that we could only reference one enemy and now
		#	enemies call the method inside health bar and they send the amount
		#	of damage they do and the script inside health bar scene handles
		#	how that damage will be dealt with and can alter the number in case
		#	we implement some sort of barrier or armor in the game)
		get_tree().call_group('HPBar', 'on_hit', damage)
		# We create a timer and give it the time for our enemies attack rate,
		#	activate it and this method waits until timer is done and sets
		#	can_attack variable back to true so the enemy can attack again
		yield(get_tree().create_timer(attack_rate), 'timeout')
		can_attack = true
		

func enemy_move():
	motion = Vector2.ZERO
	if can_move:
		if !player_is_dead: # Does the check if player scene still exists
			motion = position.direction_to(character.position) * speed


func on_player_death():
	player_is_dead = true
	

func on_hit(_damage):
	print(self, ' hit')
	$Sprite.modulate = '#000000'
	yield(get_tree().create_timer(on_hit_flash), 'timeout')
	$Sprite.modulate = '#ffffff'
	current_health -= _damage
	if current_health <= 0:
		on_death()
	

func on_death():
	enemy_dead = true
	self.queue_free()
	
	
func _on_Area2D_body_entered(body):
	if body == character:
		touching_player = true
		can_move = false


func _on_Area2D_body_exited(body):
	if body == character:
		can_move = true
		touching_player = false
		

func remove_enemy():
	print('im gone')
	queue_free()

