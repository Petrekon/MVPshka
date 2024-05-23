extends CanvasLayer

@onready var content := $ColorRect/RichTextLabel as RichTextLabel
@onready var type_timer := $ColorRect/Timer as Timer

func _ready() -> void:
	$ColorRect2.hide()
	$ColorRect3.hide()
	get_tree().paused=false
	laughter()
	
func laughter():
	await get_tree().create_timer(5.0).timeout
	update_message("[shake rate=20.0 level=5 connected=1][color=Red]ХА_ХА_ХА[/color][/shake]")
	
	
#реакции на клики
func _on_new_game_btn_pressed() -> void:
	$ColorRect3.show()
	$ColorRect2.hide()
func _on_exit_btn_pressed() -> void:
	$ColorRect2.show()
	$ColorRect3.hide()
func _on_yes_btn_pressed() -> void:
	get_tree().quit()
func _on_no_btn_pressed() -> void:
	$ColorRect2.hide()
func _on_agree_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene1.tscn")
func _on_disagree_btn_pressed() -> void:
	$ColorRect3.hide()
	
#реакции на курсор
func _on_new_game_btn_mouse_entered() -> void:
	update_message("новая_игра|")
func _on_continue_btn_mouse_entered() -> void:
	update_message("продолжить|")
func _on_options_btn_mouse_entered() -> void:
	update_message("настройки|")
func _on_exit_btn_mouse_entered() -> void:
	update_message("выйти_из_игры|")

#функции для обновление текста
func update_message(message: String) -> void:
	content.bbcode_text = message
	content.visible_characters = 0
	type_timer.start()

func _on_timer_timeout() -> void:
	if content.visible_characters < content.get_total_character_count():
		content.visible_characters += 1
	else:
		type_timer.stop()





