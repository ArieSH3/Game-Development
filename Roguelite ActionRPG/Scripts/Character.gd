extends KinematicBody2D


export var move_speed = 150

var velocity = Vector2()
var is_dead = false

#func _ready():
#	var enemy = get_tree().get_root().find_node('Enemy', true, false)
#	enemy.connect('damage_given_to_player', self, 'damage_taken_handler')

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("dash"):
		print('dashed')
		
		
	velocity = velocity.normalized() * move_speed


func _ready():
	var health_bar = get_tree().get_root().find_node('HealthBar', true, false)
	health_bar.connect('player_dead', self, 'on_death_handler')

func on_death_handler():
	print('Player: I have died!')
	is_dead = true
	# Removes the scene from the queue (deleting the scene/node)
	# queue_free()
	# Hides the player as if he has died because removing him with queue_free()
	#	creates errors for now
	self.hide()
	
	
# Use physics process for anything physics related and just physics for graphics
#	and places that position is not involved
func _physics_process(_delta):
	if !is_dead:
		get_input()
		velocity = move_and_slide(velocity)
