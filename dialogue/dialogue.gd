extends Control

@export_file("*.json") var file1
@export_file("*.json") var file2
@export_file("*.json") var file3
@export_file("*.json") var file4
@export_file("*.json") var file5
@export_enum("with_self","with_anybody") var d_type : String
@export var sequence : int = 1
@export var speakers_number : int = 1

@onready var content := $ColorRect/text as RichTextLabel
@onready var type_timer := $Timer as Timer
@onready var num_chat = 1
@onready var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	json_changer()
	if Input.is_action_just_pressed("talk") and is_valid_d_type():
		match d_file:
			null: pass
			_: start_dialogue()

func is_valid_d_type():
	match d_active:
		true: 
			return false
		false:
			match d_type:
				"with_anybody":
					match GlobalVariables.can_chat:
						true: return true
						false: return false
				"with_self":
					return true
			
func json_changer():
	match num_chat:
		1:
			d_file = file1
		2:
			d_file = file2
		3: 
			d_file = file3
		4:
			d_file = file4
		5:
			d_file = file5
		_:
			d_file = null
	
func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	var dialogue_content = JSON.parse_string(file.get_as_text())
	return dialogue_content
	
func next_string():
	match sequence:
		1:
			if current_dialogue_id<0:
				current_dialogue_id += 1
			elif current_dialogue_id>=0:
				current_dialogue_id += 1 * speakers_number
		2: 
			if current_dialogue_id==0:
				current_dialogue_id += 1
			elif current_dialogue_id>0:
				current_dialogue_id += 1 * speakers_number
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
	match  sequence:
		1:
			current_dialogue_id = -1
		2:
			current_dialogue_id = 0
	next_string()
	
func _input(event: InputEvent) -> void:
	if !d_active:
		return
		d_active = false
	if event.is_action_pressed("ui_accept"):
		next_string()

