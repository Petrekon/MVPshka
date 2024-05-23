extends CanvasLayer

@onready var content := $ColorRect/RichTextLabel as RichTextLabel
@onready var type_timer := $ColorRect/Timer as Timer

func _ready() -> void:
	$".".hide()
	var timer = get_tree().create_timer(1.0)
	var signale = timer.timeout
	await signale
	update_message("[wave amp=50.0 freq=5.0 connected=1][color=Green]Правильно, сделай паузу[/color][/wave]")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and $".".visible == false:
		$".".show()
		get_tree().paused = true
	elif Input.is_action_just_pressed("escape") and $".".visible == true:
		$".".hide()
		$ColorRect2.hide()
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
	$ColorRect2.show()
func _on_continue_btn_pressed() -> void:
	$".".hide()
	$ColorRect2.hide()
	get_tree().paused = false
func _on_yes_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
func _on_no_btn_pressed() -> void:
	$ColorRect2.hide()
	
func _on_continue_btn_mouse_entered() -> void:
	update_message("Скорее, мы уже устали ждать")
func _on_options_btn_mouse_entered() -> void:
	update_message("Пока этим ты ничего не добьёшься")
func _on_exit_btn_mouse_entered() -> void:
	update_message("Уже уходишь?")
