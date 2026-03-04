extends Node2D


@onready var text__label: Label = $"story_nodes/Text_rect/Text_label"
@onready var name_label: Label = $story_nodes/Text_rect/ColorRect/Name_label
@onready var character: Sprite2D = $story_nodes/character
@onready var god: Sprite2D = $story_nodes/god
@onready var bg: Sprite2D = $story_nodes/bg

var story_archive = {
	"event_1" : {
		"speaker" : "Asjad",
		"text": "Man Im so bald and so sad and so bald and so sad" 
	},
	"event_2": {
		"speaker": "Asjad",
		"text": "Why am I so bald? I wont be able to go Agartha bald"
	},
	"event_3": {
		"speaker": "God",
		"text": "Dont worry my child, I got you fam"
	},
	"event_4": {
		"speaker": "God",
		"text": "If you buy HAIR-EXTRA-SUPREME-CREAM 3000 today, you will get to go to Agartha"
	},
	"event_5": {
		"speaker": "God",
		"text": "Here, try it"
	},
	"event_6": {
		"speaker":"",
		"text": ""
	},
	"event_7": {
		"speaker": "Asjad",
		"text": "Hell yeah!"
	},
	"event_8": {
		"speaker": "Asjad",
		"text": "Oh no... :,("
	},
	"event_9": {
		"speaker": "God",
		"text": "Guess, you gotta hurry child"
	},
	"event_10": {
		"speaker": "",
		"text": ""
	}
}
var current_event := 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	move_story_forward()
	
func  _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("mouse_click"):
		current_event += 1
		move_story_forward()
	
func move_story_forward() -> void:
	var key = "event_" + str(current_event)
	if story_archive.has(key):
		var data = story_archive[key]
		if data["speaker"] == "Asjad":
			character.visible = true
			god.visible = false
		else:
			character.visible = false
			god.visible = true
		text__label.text = data["text"]
		name_label.text = data["speaker"]
		if key == "event_6":
			bg.texture = preload("uid://cwqu8cdeob6k4")
			text__label.visible = false
			name_label.visible = false
			character.visible = false
			god.visible = false
		else:
			bg.texture = preload("uid://bdiewlwgemq1a")
			text__label.visible = true
			name_label.visible = true
		if key == "event_7":
			character.texture = preload("uid://cilnog5hmbpcd")
		else:
			character.texture = preload("uid://cvnjri48cpxux")
		if key == "event_10":
			var next_scene = load("res://Scenes/game.tscn").instantiate()
			get_tree().root.add_child(next_scene)
			queue_free()
	else:
		print("End of story")
