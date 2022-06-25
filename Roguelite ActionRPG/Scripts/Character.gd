extends KinematicBody2D


export var move_speed = 150

var velocity = Vector2()

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



#func damage_taken_handler(damage_amount):
#	print('Player: I have been damaged for ', damage_amount, ' health.')
	
	
# Use physics process for anything physics related and just physics for graphics
#	and places that position is not involved
func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
