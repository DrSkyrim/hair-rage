extends Node2D

@onready var player := $Player
@onready var camera: Camera2D = $Camera

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print("entered")
		exit_room()

func exit_room():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
