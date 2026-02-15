extends CharacterBody2D

@export var speed : float = 200.0
@export var attack_duration : float = 0.4

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

var is_attacking : bool = false
var attack_timer : float = 0.0


func _physics_process(delta):

	if is_attacking:
		handle_attack(delta)
		move_and_slide()
		return

	handle_movement()
	handle_attack_input()
	move_and_slide()


func handle_movement():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	input_vector = input_vector.normalized()
	
	velocity = input_vector * speed
	
	if input_vector != Vector2.ZERO:
		sprite.play("run")
		flip_sprite(input_vector)
	else:
		sprite.play("idle")


func handle_attack_input():
	if Input.is_action_just_pressed("attack"):
		start_attack()


func start_attack():
	is_attacking = true
	attack_timer = attack_duration
	velocity = Vector2.ZERO
	sprite.play("attack")
	hitbox.monitoring = true


func handle_attack(delta):
	attack_timer -= delta
	
	if attack_timer <= 0:
		is_attacking = false
		hitbox.monitoring = false


func flip_sprite(direction: Vector2):
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
