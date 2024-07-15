extends CharacterBody2D

@export var speed = 0.64 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var is_attacking = false
var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move:
		velocity = Vector2.ZERO # The player's movement vector
		
		# Translate movement to vectors
		var walk_movement_map = {
			"move_right": Vector2(1, 0),
			"move_left": Vector2(-1, 0),
			"move_up": Vector2(0, -1),
			"move_down": Vector2(0, 1)
		}
		
		# Translate movement to animations
		var walk_animation_map = {
			"move_right": "walk_right",
			"move_left": "walk_left",
			"move_up": "walk_up",
			"move_down": "walk_down"
		}
		
		# Check all through all walk options then move with the correct animation
		for input in walk_movement_map.keys():
			if Input.is_action_pressed(input):
				velocity += walk_movement_map[input]
				walk(walk_animation_map[input])
				break
		
		# Translate movement directions to attack directions
		var attack_animation_map = {
			"walk_right": "attack_right",
			"walk_left": "attack_left",
			"walk_up": "attack_up",
			"walk_down": "attack_down"
		}
		
		# Check for correct attack direction then attack with the correct animation
		for direction in attack_animation_map.keys():
			if Input.is_action_just_pressed("attack"):
				if $AnimatedSprite2D.animation == direction:
					attack(attack_animation_map[direction])
					break
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		elif $AnimatedSprite2D.is_playing() && !is_attacking:
			$AnimatedSprite2D.stop()
		
		#position += velocity * delta
		move_and_collide(velocity)
		position = position.clamp(Vector2.ZERO, screen_size)

func walk(animation):
	if !is_attacking:
		$AnimatedSprite2D.animation = animation
		if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.frame = 3
		$AnimatedSprite2D.play(animation)

func attack(animation):
	can_move = false
	$AnimatedSprite2D.stop()
	is_attacking = true
	var previousAnimation = $AnimatedSprite2D.animation
	$AnimatedSprite2D.play(animation, 3)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.animation = previousAnimation
	is_attacking = false
	can_move = true
