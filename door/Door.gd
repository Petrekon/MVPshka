extends Area2D

@export var level_to_change : String
@export var is_usable : bool

@onready var interaction_area = $interaction_zone

var is_body_inside = false

func _ready() -> void:
	check_usability()
	interaction_area.interact = Callable(self, "_change_scene")

func _change_scene():
	if is_usable == true and is_body_inside:
		print("нажал")
		get_tree().change_scene_to_file(level_to_change)
		GlobalFunctions.scene_changed.emit()

func _on_body_entered(body: Node2D) -> void:
	check_visibility()
	check_usability()
	if body.has_method("_on_player_area_area_entered"):
		is_body_inside = true
		
func _on_body_exited(body: Node2D) -> void:
	check_visibility()
	check_usability()
	if body.has_method("_on_player_area_area_entered"):
		is_body_inside = false
		
func check_visibility():
	var nodes_in_group = get_tree().get_nodes_in_group("reflectionable")
	for node in nodes_in_group:
		if node.self_modulate.a == 0:
			is_usable = not is_usable
			break  # Останавливаем цикл, если нашли невидимый объект
			
func check_usability():
	if is_usable == false:
		$".".hide()
	elif is_usable == true:
		$".".show()
