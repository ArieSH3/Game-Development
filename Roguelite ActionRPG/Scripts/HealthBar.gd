extends ProgressBar


signal player_dead
signal took_dmg

var max_hp = 100
var current_hp
export var toggle_damage = true


func _ready():
	current_hp = max_hp
	
func _process(_delta):
	pass


func on_hit(damage):
	if toggle_damage:
		print('HPBar: I have been damaged for ', damage, ' health.')
		emit_signal('took_dmg')
		current_hp -= damage
		self.value = int((float(current_hp) / max_hp) * 100)
		if current_hp <= 0:
			on_death()
		
		

func on_death():
	print('HPBar: Player is dead')
	emit_signal('player_dead')
