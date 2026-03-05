extends Node2D

@onready var player := $Player
@onready var camera: Camera2D = $Camera
@onready var room: Node2D = $Room
@onready var street: Node2D = $Street
@onready var enemy: CharacterBody2D = $Street/Backgrounds/enemy
@onready var enemy_2: CharacterBody2D = $Street/Backgrounds/enemy2
@onready var cream: Area2D = $Cream
@onready var beach: Node2D = $Beach
@onready var enemy_1: CharacterBody2D = $Beach/enemy
@onready var enemy_2_2: CharacterBody2D = $Beach/enemy2
@onready var enemy_3: CharacterBody2D = $Beach/enemy3

func _ready():
	# Setup enemy targets
	enemy.target = player
	enemy_2.target = player

	# Hide enemies initially
	enemy.visible = false
	enemy_2.visible = false

	# Disable physics processing
	enemy.set_physics_process(false)
	enemy_2.set_physics_process(false)

	# Disable collisions
	enemy.set_collision_layer(0)
	enemy.set_collision_mask(0)


func _process(delta: float) -> void:
	camera_controls()


func camera_controls() -> void:
	camera.position.x = player.position.x
	camera.position.y = player.position.y - 120


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and room.visible == true:
		exit_room()


func exit_room():
	room.visible = false
	street.visible = true

	player.position = Vector2(500, 1000)

	# Enable enemies
	enemy.visible = true
	enemy_2.visible = true

	enemy.set_physics_process(true)
	enemy_2.set_physics_process(true)

	enemy.set_collision_layer(3)
	enemy.set_collision_mask(3)

#func move_to_beach():
	## Hide current street
	#street.visible = false
	#beach.visible = true
#
	## Move player to starting position in beach
	#player.position = Vector2(500, 1000)
#
	## Enable beach enemies
	#enemy_1.visible = true
	#enemy_2_2.visible = true
	#enemy_3.visible = true
#
	#enemy_1.set_physics_process(true)
	#enemy_2_2.set_physics_process(true)
	#enemy_3.set_physics_process(true)
#
	#enemy_1.set_collision_layer(3)
	#enemy_1.set_collision_mask(3)
#
	#enemy_2_2.set_collision_layer(3)
	#enemy_2_2.set_collision_mask(3)
#
	#enemy_3.set_collision_layer(3)
	#enemy_3.set_collision_mask(3)
#
	## Set player as target for each beach enemy
	#enemy_1.target = player
	#enemy_2_2.target = player
	#enemy_3.target = player

func _on_cream_body_entered(body: Node2D) -> void:
	if cream.picked_up:
		return

	if body == player:
		cream.picked_up = true
		cream.visible = false

		player.damage += cream.cream_buff
		player.hair = player.Hair.HAIR
		player.update_skin()
		print("Picked up")

		_start_buff_timer()


func _start_buff_timer() -> void:
	await get_tree().create_timer(cream.buff_time).timeout
	player.damage -= cream.cream_buff
	player.hair = player.Hair.HAIRLESS
	player.update_skin()
	print("Buff ended")
