extends Node2D


var can_attack = true
var attack_rate = 0.4
var attack_duration = 0.1
var attack_damage = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	# Disables the attack by default because we are not in attack mode by default
	$Area2D/CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_pressed("player_attack") and can_attack:
		can_attack = false
		# Turns on attack and off right after (Should be enough for mobs to register a hit)
		$Area2D/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(attack_duration), "timeout")
		$Area2D/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(attack_rate), 'timeout')
		can_attack = true
		


func _on_Area2D_body_entered(body):
	if body.is_in_group('Enemies'):
		body.on_hit(attack_damage)
