extends Control

@onready var main_menu: Control = %MainMenu
@onready var settings_menu: Control = %SettingsMenu
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	load_settings()
	main_menu.show()
	settings_menu.hide()
	music_player.play()

func _on_settings_button_pressed() -> void:
	settings_menu.show()
	main_menu.hide()

func _on_back_pressed() -> void:
	main_menu.show()
	settings_menu.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/debug/level_1.tscn")
	
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		var volume = config.get_value("audio", "volume", 0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	else:
		print("Нет сохранённых настроек, используется стандартное значение.")
