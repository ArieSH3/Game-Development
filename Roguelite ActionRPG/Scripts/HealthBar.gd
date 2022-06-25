extends ProgressBar

var max_hp = 100
var current_hp

func _ready():
	var enemy = get_tree().get_root().find_node('Enemy', true, false)
	enemy.connect('damage_given_to_player', self, 'damage_taken_handler')
	#current_hp = max_hp
	
func _process(delta):
	pass


func damage_taken_handler(damage_amount):
	print('HPBar: I have been damaged for ', damage_amount, ' health.')
	current_hp = 2 #-= int(damage_amount)
	get_node('HealthBar').value = current_hp #int((float(current_hp) / max_hp) * 100)
	if current_hp <= 0:
		on_death()
		

func on_death():
	print('HPBar: Player is dead')
