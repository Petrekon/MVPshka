extends Node

@onready var dialogue_scene = preload("res://dialogue/alternative_dialogue.tscn")
@onready var player = get_tree().get_first_node_in_group("player")


var d_lines: Array[String] = []

var current_line_index = 0

var text_box
var text_box_pos: Vector2
var d_type : String

var is_d_active = false
var can_advance_line = false

signal dialog_finished

func start_dialogue(position: Vector2, lines: Array[String],action_type:String):
	player_checker()
	if is_d_active:
		return
	d_lines = lines
	text_box_pos = position
	d_type = action_type
	_show_text_box()
	is_d_active = true

func _show_text_box():
	match d_lines:
		[]: 
			pass
			can_advance_line = true
		_:
			text_box = dialogue_scene.instantiate()
			text_box.finished_displaying.connect(_on_dialogue_finished_displaying)
			get_tree().root.add_child(text_box)
			text_box.scale.x = player.scale.x*1.25
			text_box.scale.y = player.scale.y*1.25
			match d_type:
				"with_anybody":
					text_box.global_position = text_box_pos
				"with_self":
					text_box.global_position.x = player.global_position.x - 150 * player.scale.x
					text_box.global_position.y = player.global_position.y - 450 * player.scale.y
			text_box.display_text(d_lines[current_line_index])
			can_advance_line = false
			
func _process(delta):
	if text_box != null and d_type == "with_self":
		if player == null:
			text_box.queue_free()
			text_box = null
		if text_box != null:
			text_box.global_position.x = player.global_position.x - 150 * player.scale.x
			text_box.global_position.y = player.global_position.y - 450 * player.scale.y

func _on_dialogue_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("talk") and is_d_active and can_advance_line
	): 
		match d_lines:
			[]: 
				is_d_active = false
				current_line_index = 0
				dialog_finished.emit()
				return
			_:
				text_box.queue_free()
				current_line_index += 1
				if current_line_index >= d_lines.size():
					is_d_active = false
					current_line_index = 0
					dialog_finished.emit()
					return
				_show_text_box()

func player_checker():
	if player == null:
		player = get_tree().get_first_node_in_group("player")
