extends AudioStreamPlayer

@export var audio_streams : Array[AudioStream]

var audio_player: AudioStreamPlayer
var current_scene_name := ""

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	change_music()
	
func _process(delta: float) -> void:
	if  GlobalFunctions.scene_changed:
		if current_scene_name != get_tree().current_scene.name:
			current_scene_name = get_tree().current_scene.name
			change_music()
			
func change_music() -> void:
	match get_tree().current_scene.name:
		"Menu":
			stop()
			stream = audio_streams[0]
			stream.loop=true
			play()
		"scene1":
			stop()
			stream = audio_streams[1]
			stream.loop=true
			play()
		"scene2":
			stop()
			stream = audio_streams[2]
			stream.loop=true
			play()
		_:
			stop()
