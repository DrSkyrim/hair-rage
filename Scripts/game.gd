extends Node2D

@onready var player := $Player
@onready var camera := $Camera

func _process(delta: float) -> void:
	camera_controls()


func camera_controls() -> void:
	if player.position.x > camera.position.x || player.position.x < camera.position.x:
		camera.position.x = player.position.x
	if player.position.y > camera.position.y || player.position.y < camera.position.y:
		camera.position.y = player.position.y-120
