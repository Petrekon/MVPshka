extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $RichTextLabel


var active_areas = []
var can_interact = true

func register_area(area: InteractionZone):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionZone):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(delta: float) -> void:
	player_checker()
	if active_areas.size()>0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		GlobalFunctions.type_text(label, " "+active_areas[0].action_name, 0.05)
		label.scale.x = player.scale.x*1.25
		label.scale.y = player.scale.x*1.25
		label.global_position = player.global_position
		label.global_position.y -= 300 * player.scale.x
		label.global_position.x -= 150 * player.scale.x
		label.show()
	else:
		label.hide()
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("talk") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			await active_areas[0].chatting.call()
			can_interact = true
			
	elif event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			await active_areas[0].interact.call()
			can_interact = true
			
func player_checker():
	if player == null:
		player = get_tree().get_first_node_in_group("player")
