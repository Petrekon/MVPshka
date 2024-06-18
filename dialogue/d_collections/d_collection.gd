extends Node2D

@export_file("*.json") var file1
@export_file("*.json") var file2
@export_file("*.json") var file3
@export_file("*.json") var file4
@export_file("*.json") var file5

@onready var d_file
@onready var num_chat

func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	var dialogue_content = JSON.parse_string(file.get_as_text())
	return dialogue_content

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
