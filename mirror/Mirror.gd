extends Area2D

@onready var interaction_area = $interaction_zone

var can_see = true
var canmirror = false
# Called when the node enters the scene tree for the first time.

func _mirror():
	var changers = get_tree().get_nodes_in_group("reflectionable")
	if canmirror and can_see == true:
		can_see = false
		for c in changers:
			var disappear = get_tree().create_tween().tween_property(c,"self_modulate:a",0,0.5)
	elif canmirror and can_see == false:
		can_see = true
		for c in changers:
			var disappear = get_tree().create_tween().tween_property(c,"self_modulate:a",1,0.5)
	
func _ready() -> void:
	interaction_area.interact = Callable(self, "_mirror")
	
func _on_body_entered(body):
	body.has_method("_on_player_area_area_entered")
	canmirror = true

func _on_body_exited(body: Node2D) -> void:
	body.has_method("_on_player_area_area_entered")
	canmirror = false
