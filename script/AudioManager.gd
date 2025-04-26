extends Node

var config = ConfigFile.new()

func _ready() -> void:
	load_settings()
	
func set_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	save_settings(value)
	
func save_settings(value: float) -> void:
	config.set_value("audio", "volume", value)
	config.save("res://settings.cfg")

func load_settings() -> void:
	var err = config.load("res://settings.cfg")
	if err == OK:
		var volume = config.get_value("audio", "volume", 0.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
