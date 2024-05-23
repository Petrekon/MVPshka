extends Control

@export_file("*.json") var d_file
@onready var content := $ColorRect/text as RichTextLabel
@onready var type_timer := $Timer as Timer
@onready var num_chat = 1

var dialogue = []
var current_dialogue_id = 0
var d_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	json_changer()
	if Input.is_action_just_pressed("talk"):
		match d_file:
			null: pass
			_: start_dialogue()
			
func json_changer():
	if get_tree().current_scene.name == "scene1":
		match num_chat:
			1:
				d_file = "res://dialogue/chats/playerchat1.json"
			2:
				d_file = "res://dialogue/chats/playerchat2.json"
			_: 
				d_file = null
	
	
func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	var dialogue_content = JSON.parse_string(file.get_as_text())
	return dialogue_content
	
func next_string():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$".".hide()
		num_chat += 1
		return
	update_message(dialogue[current_dialogue_id]['text'])
	
func _on_timer_timeout() -> void:
	if content.visible_characters < content.get_total_character_count():
		content.visible_characters += 1
	else:
		type_timer.stop()

func update_message(message: String) -> void:
	content.bbcode_text = message
	content.visible_characters = 0
	type_timer.start()
	
func start_dialogue():
	if d_active:
		return
	d_active = true
	$".".show()
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_string()
	
func _input(event: InputEvent) -> void:
	if !d_active:
		return
		d_active = false
	if event.is_action_pressed("ui_accept"):
		next_string()

