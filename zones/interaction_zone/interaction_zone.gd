extends Area2D

class_name InteractionZone

@export_file("*.json") var file1
@export_file("*.json") var file2
@export_file("*.json") var file3
@export_file("*.json") var file4
@export_file("*.json") var file5
@export var num_chat : int = 1
@export var action_name: String = "interact"
@export_enum("with_self","with_anybody") var action_type: String

@onready var d_file
@onready var lines : Array[String] = []

func json_changer():
	match num_chat:
		1:
			d_file = file1
		2:
			d_file = file2
		3: 
			d_file = file3
		4:
			d_file = file4
		5:
			d_file = file5
		_:
			d_file = null

func load_dialogue() -> Array[String]:
	var result : Array[String] = []
	match d_file:
		null: return result
		_:
			var file = FileAccess.open(d_file, FileAccess.READ)
			var dialogue_content = JSON.parse_string(file.get_as_text())
			for line in dialogue_content:
				if typeof(line) == TYPE_STRING:
					result.append(line)
			return result

var chatting: Callable = func():
	pass
var interact: Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)

func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
	
func _ready() -> void:
	$".".chatting = Callable(self, "_on_interact")

func _on_interact():
	json_changer()
	lines = load_dialogue()
	DialogueManager.start_dialogue(global_position,lines,action_type)
	await DialogueManager.dialog_finished
	num_chat += 1
	

