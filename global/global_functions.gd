extends Node

signal scene_changed

func type_text(node: RichTextLabel, message: String, interval: float = 0.1) -> void:
	var type_timer: Timer = Timer.new()
	
	type_timer.wait_time = interval
	type_timer.one_shot = false
	add_child(type_timer)
	
	node.bbcode_text = message
	node.visible_characters = 0
	
	var callable = Callable(self, "_on_timer_timeout").bind(node, type_timer)
	type_timer.connect("timeout", callable)
	type_timer.start()

func _on_timer_timeout(node: RichTextLabel, type_timer: Timer) -> void:
	node.visible_characters += 1 
	if node.visible_characters >= node.get_total_character_count():
		type_timer.stop()
		type_timer.queue_free()  
