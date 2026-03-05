extends Area2D

@onready var player: CharacterBody2D = $"../Player"

@export var cream_buff: int = 10
@export var buff_time: float = 5.0

var picked_up: bool = false
