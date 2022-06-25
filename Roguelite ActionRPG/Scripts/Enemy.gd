extends KinematicBody2D
# Make enemy stop moving (Maybe with signal) so player can push it around
# Supposed to emit signal that player has been damaged (DONE)
# Trigger an attack speed timer and damage player continuosly until
# 	player exits the area2d of the enemy meaning he is safe (DONE)


signal damage_given_to_player 

export var speed = 100
var motion = Vector2.ZERO
var can_move = true
var can_attack = true
export var attack_rate = 1.5
export var damage_done = 30
var touching_player = false

onready var enemy_attack_timer = get_node("EnemyAttackTimer")
onready var character = get_parent().get_node('Character')


func _process(_delta):
	attack_player()


func _physics_process(delta):
	motion = Vector2.ZERO
	if can_move:
		motion = position.direction_to(character.position) * speed
	
	motion = move_and_slide(motion)


func attack_player():
	if can_attack and touching_player:
		can_attack = false
		print('Enemy: I have damaged the player.')
		emit_signal("damage_given_to_player", damage_done)
		yield(get_tree().create_timer(attack_rate), 'timeout')
		can_attack = true


func _on_Area2D_body_entered(body):
	if body == character:
		touching_player = true
		can_move = false


func _on_Area2D_body_exited(body):
	if body == character:
		can_move = true
		touching_player = false
