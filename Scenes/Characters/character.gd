extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite

enum State {IDLE, WALK}

var state = State.IDLE

func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_attack()

func handle_movement() -> void:
	if velocity.length() == 0:
		state = State.IDLE
	else:
		state = State.WALK
		
func handle_input() -> void:
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	if direction.x < 0:
		character_sprite.flip_h = true
	if direction.x > 0:
		character_sprite.flip_h = false
	velocity = direction*speed
	move_and_slide()
	
func handle_attack() -> void:
	if Input.is_action_just_pressed("BASIC_ATTACK"):
		character_sprite.play("attack") 



func _on_character_sprite_animation_finished() -> void:
	if character_sprite.animation == "attack":
		character_sprite.play("idle")
