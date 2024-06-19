extends CanvasLayer

@onready var content := $MainRect/RichTextLabel as RichTextLabel
@onready var type_timer := $MainRect/Timer as Timer

func _ready() -> void:
	$ExitRect.hide()
	$NewGameRect.hide()
	$InProgressRect.hide()
	$OptionsRect.hide()
	$OptionsRect/MarginContainer/HBoxContainer/VBoxContainer2/Label2/HScrollBar.value = MasterAudio.volume_db
	$OptionsRect/MarginContainer/HBoxContainer/VBoxContainer2/ScreenChanger.selected = GlobalVariables.screen_index
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused=false
	laughter()
	
	
func laughter():
	await get_tree().create_timer(5.0).timeout
	GlobalFunctions.type_text(content,"[shake rate=20.0 level=5 connected=1][color=Red]ХА_ХА_ХА[/color][/shake]",0.1)
	
#реакции на клики
func _on_new_game_btn_pressed() -> void:
	$NewGameRect.show()
	$ExitRect.hide()
	$InProgressRect.hide()
func _on_exit_btn_pressed() -> void:
	$ExitRect.show()
	$NewGameRect.hide()
	$InProgressRect.hide()
func _on_yes_btn_pressed() -> void:
	get_tree().quit()
func _on_no_btn_pressed() -> void:
	$ExitRect.hide()
func _on_agree_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene1.tscn")
	GlobalFunctions.scene_changed
func _on_disagree_btn_pressed() -> void:
	$NewGameRect.hide()
func _on_options_btn_pressed() -> void:
	$OptionsRect.show()
	$NewGameRect.hide()
	$ExitRect.hide()
func _on_continue_btn_pressed() -> void:
	$InProgressRect.show()
	$NewGameRect.hide()
	$ExitRect.hide()
func _on_ok_btn_pressed() -> void:
	$InProgressRect.hide()
	
#реакции на курсор
func _on_new_game_btn_mouse_entered() -> void:
	GlobalFunctions.type_text(content,"новая_игра|",0.1)
func _on_continue_btn_mouse_entered() -> void:
	GlobalFunctions.type_text(content,"продолжить|",0.1)
func _on_options_btn_mouse_entered() -> void:
	GlobalFunctions.type_text(content,"настройки|",0.1)
func _on_exit_btn_mouse_entered() -> void:
	GlobalFunctions.type_text(content,"выйти_из_игры|",0.1)

func _on_ok_settings_btn_pressed() -> void:
	$OptionsRect.hide() # Replace with function body.

func _on_screen_changer_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GlobalVariables.screen_index=index
		

func _on_h_scroll_bar_value_changed(value: float) -> void:
	MasterAudio.volume_db = value
