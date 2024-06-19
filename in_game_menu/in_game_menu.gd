extends CanvasLayer

@onready var content := $MainRect/RichTextLabel as RichTextLabel
@onready var type_timer := $MainRect/Timer as Timer

func _ready() -> void:
	print(content)
	$".".hide()
	$ExitRect.hide()
	$OptionsRect.hide()
	$OptionsRect/MarginContainer/HBoxContainer/VBoxContainer2/Label2/HScrollBar.value = MasterAudio.volume_db
	$OptionsRect/MarginContainer/HBoxContainer/VBoxContainer2/ScreenChanger.selected = GlobalVariables.screen_index
	
	var timer = get_tree().create_timer(1.0)
	var signale = timer.timeout
	await signale
#	GlobalFunctions.type_text(content, "[wave amp=50.0 freq=5.0 connected=1][color=Green]Правильно, сделай паузу[/color][/wave]", 0.05)
	update_message("[wave amp=50.0 freq=5.0 connected=1][color=Green]Правильно, сделай паузу[/color][/wave]")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and $".".visible == false:
		$".".show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	elif Input.is_action_just_pressed("escape") and $".".visible == true:
		$".".hide()
		$ExitRect.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false

func update_message(message: String) -> void:
	content.bbcode_text = message
	content.visible_characters = 0
	type_timer.start()

func _on_timer_timeout() -> void:
	if content.visible_characters < content.get_total_character_count():
		content.visible_characters += 1
	else:
		type_timer.stop()

func _on_exit_btn_pressed() -> void:
	$ExitRect.show()
func _on_continue_btn_pressed() -> void:
	$".".hide()
	$ExitRect.hide()
	get_tree().paused = false
func _on_yes_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	GlobalFunctions.scene_changed
func _on_no_btn_pressed() -> void:
	$ExitRect.hide()
func _on_options_btn_pressed() -> void:
	$ExitRect.hide()
	$MainRect/MarginContainer/VBoxContainer/continue_btn.hide()
	$MainRect/MarginContainer/VBoxContainer/options_btn.hide()
	$MainRect/MarginContainer/VBoxContainer/exit_btn.hide()
	$MainRect/RichTextLabel.hide()
	$OptionsRect.show()
	
func _on_continue_btn_mouse_entered() -> void:
	update_message("Скорее, мы уже устали ждать")
#	GlobalFunctions.type_text(content,"Скорее, мы уже устали ждать",0.1)
func _on_options_btn_mouse_entered() -> void:
	update_message("Покрутить громкость? Расправить окно?")
#	GlobalFunctions.type_text(content,"Пока этим ты ничего не добьёшься",0.1)
func _on_exit_btn_mouse_entered() -> void:
	update_message("Уже уходишь?")
#	GlobalFunctions.type_text(content,"Уже уходишь?",0.1)


func _on_screen_changer_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GlobalVariables.screen_index=index

func _on_h_scroll_bar_value_changed(value: float) -> void:
	MasterAudio.volume_db=value

func _on_ok_settings_btn_pressed() -> void:
	$OptionsRect.hide()
	$MainRect/MarginContainer/VBoxContainer/continue_btn.show()
	$MainRect/MarginContainer/VBoxContainer/options_btn.show()
	$MainRect/MarginContainer/VBoxContainer/exit_btn.show()
	$MainRect/RichTextLabel.show()



