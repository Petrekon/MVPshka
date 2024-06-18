extends MarginContainer

@onready var text_label = $MarginContainer/RichTextLabel
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 400

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.04
var punctuation_time = 0.2

signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.bbcode_text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
	custom_minimum_size.y = size.y
	global_position.x -= size.x / 2
	global_position.y -= size.y + 250
	
	text_label.visible_characters = 0
	letter_index = 0
	_display_letter()

func _display_letter():
	if text_label.visible_characters >= text.length():
		finished_displaying.emit()
		return
	
	var char = text[letter_index]
	letter_index += 1
	text_label.visible_characters = letter_index+1
	match text[letter_index]:
		"!", "?", ".", ",":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_: 
			timer.start(letter_time)

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
