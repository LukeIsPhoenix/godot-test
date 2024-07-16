extends CharacterBody2D

@export var HP = 10

func _physics_process(_delta):
	if HP <= 0:
		self.queue_free()

func take_damage(damage_amount):
	print("Damage: ", damage_amount)
	HP -= damage_amount
