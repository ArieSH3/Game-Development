extends KinematicBody2D


export var move_speed = 150

var velocity = Vector2()

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


# Use physics process for anything physics related and just physics for graphics
#	and places that position is not involved
func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
