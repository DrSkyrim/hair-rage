extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var damage_emmiter: Area2D = $damage_emmiter
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum State {IDLE, WALK, PUNCH}

var state = State.IDLE

func _ready() -> void:
	damage_emmiter.area_entered.connect(on_emit_damage)

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
	if Input.is_action_just_pressed("BASIC_ATTACK") and state != State.PUNCH:
		state = State.PUNCH
		damage_emmiter.monitoring = true
		animation_player.play("attack")


func on_emit_damage(damage_receiver: Area2D) -> void:
	print(damage_receiver)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		state = State.IDLE
		damage_emmiter.monitoring = false
