extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var damage_emmiter: Area2D = $damage_emmiter
@onready var hairy_sprite: AnimatedSprite2D = $HairySprite
@onready var health_bar: ProgressBar = $HealthBar
@export var control_type : ControlType = ControlType.PLAYER
@export var target: CharacterBody2D
@export var hair: Hair = Hair.HAIRLESS
@export var cream_scene: PackedScene  # Assign your Cream scene here in the Inspector
@export var drop_chance: float = 0.3  # 30% chance to drop

enum State {IDLE, WALK, PUNCH}
enum ControlType { PLAYER, AI }
enum Hair { HAIR, HAIRLESS }

var state = State.IDLE
var max_health : int
# Skin resources
@export var hairless_frames : SpriteFrames = preload("uid://dlx2fuu7p78jl")
@export var hair_frames : SpriteFrames = preload("uid://dqwxy8rsktqxu")

func _ready() -> void:
	max_health = health
	update_skin()
	damage_emmiter.area_entered.connect(on_emit_damage)
	update_health_bar()  # make sure bar starts full


func update_skin():
	if control_type != ControlType.PLAYER:
		return
	
	if hair == Hair.HAIR:
		character_sprite.sprite_frames = hair_frames
	else:
		character_sprite.sprite_frames = hairless_frames


func _process(delta: float) -> void:
	if control_type == ControlType.PLAYER:
		handle_input()
	else:
		handle_ai()

	handle_movement()
	handle_attack()
	move_and_slide()


func handle_movement() -> void:
	if velocity.length() == 0:
		if state != State.PUNCH:
			state = State.IDLE
			character_sprite.play("idle")
	else:
		if state != State.PUNCH:
			state = State.WALK
			character_sprite.play("walk")


func handle_input() -> void:
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")

	if direction.x < 0:
		character_sprite.flip_h = true
	if direction.x > 0:
		character_sprite.flip_h = false

	velocity = direction * speed


func handle_attack() -> void:
	if control_type == ControlType.PLAYER:
		if Input.is_action_just_pressed("BASIC_ATTACK") and state != State.PUNCH:
			start_attack()
	else:
		if target and global_position.distance_to(target.global_position) < 60 and state != State.PUNCH:
			start_attack()


func start_attack():
	state = State.PUNCH
	damage_emmiter.monitoring = true
	character_sprite.play("attack")


func on_emit_damage(damage_receiver: Area2D) -> void:
	var receiver = damage_receiver.get_parent()
	
	if receiver == self:
		return
		
	if receiver.has_method("take_damage"):
		receiver.take_damage(damage)
		
func take_damage(amount: int):
	health -= amount
	print(name, "took", amount, "damage. HP:", health)
	update_health_bar()

	if health <= 0:
		die()
		
func die():
	print(name, "died")
	
	# Roll for cream drop
	if cream_scene and randf() < drop_chance:
		var cream_instance = cream_scene.instantiate()
		get_parent().add_child(cream_instance)
		# Position the cream at the enemy's position
		cream_instance.global_position = global_position
		print("Dropped cream!")
		
	queue_free()

func handle_ai() -> void:
	if target == null:
		return
	
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	
	if direction.x < 0:
		character_sprite.flip_h = true
	elif direction.x > 0:
		character_sprite.flip_h = false

func _on_character_sprite_animation_finished() -> void:
	if character_sprite.animation == "attack":
		state = State.IDLE
		damage_emmiter.monitoring = false
		character_sprite.play("idle") # Replace with function body.

func update_health_bar():
	if health_bar:
		health_bar.value = health
		health_bar.max_value = max_health
