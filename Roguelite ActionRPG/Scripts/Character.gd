extends KinematicBody2D


signal on_death

export var move_speed = 150

var velocity = Vector2()
var move_input = Vector2.ZERO
var is_dead = false
var on_dmg_taken_flash = 0.08
var dash_time = 0.15

#func _ready():
#	var enemy = get_tree().get_root().find_node('Enemy', true, false)
#	enemy.connect('damage_given_to_player', self, 'damage_taken_handler')

func get_input():
#	velocity = Vector2()
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
#	if Input.is_action_just_pressed("dash"):
#		print('dashed')
#
#
#	velocity = velocity.normalized() * move_speed

	move_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
#	# Turns the sprite and its attack hitbox to the side its moving
#	if Input.get_action_strength("ui_left") > Input.get_action_strength("ui_right"):
#		$Sprite.scale.x = -3
#	if Input.get_action_strength("ui_left") < Input.get_action_strength("ui_right") :
#		$Sprite.scale.x = 3

	# Turns sprite and its hotbox to the side the mouse is relative to the character
	if get_global_mouse_position().x < self.position.x:
		$Sprite.scale.x = -3
	if get_global_mouse_position().x > self.position.x:
		$Sprite.scale.x = 3
	
	# Just a dash test code (Probably to be scrapped or replaced)
	if Input.is_action_just_pressed("dash"):
		move_speed = 1000
		yield(get_tree().create_timer(dash_time),"timeout")
		move_speed = 150 

	move_input = move_input.normalized() * move_speed
	


func _ready():
	var health_bar = get_tree().get_root().find_node('HealthBar', true, false)
	health_bar.connect('player_dead', self, 'on_death_handler')
	health_bar.connect('took_dmg', self, 'on_dmg_handler')	
	
# Use physics process for anything physics related and just physics for graphics
#	and places that position is not involved
func _physics_process(_delta):
	if !is_dead:
		get_input()
		move_input = move_and_slide(move_input)


func on_death_handler():
	print('Player: I have died!')
	is_dead = true
	emit_signal("player_dead")
	# Removes the scene from the queue (deleting the scene/node)
	# queue_free()
	# Hides the player as if he has died because removing him with queue_free()
	#	creates errors for now
	# self.hide()
	self.modulate = '#2c1a1a'
	$CollisionShape2D.disabled = true
	$DeathTimer.start()

func on_dmg_handler():
	# On taking dmg the player flashes another colour
	self.modulate = '#ff6060' # turns red
	yield(get_tree().create_timer(on_dmg_taken_flash), 'timeout')
	self.modulate = '#ffffff' # back to original


func _on_DeathTimer_timeout():
	queue_free()
