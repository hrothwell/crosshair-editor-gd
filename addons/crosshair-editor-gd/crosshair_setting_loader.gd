## Example of a component to load crosshair from a users config 
class_name CrosshairSettingLoaderComponent extends Node

## File to look up saved crosshair data
@export var settings_file: String = "user://controls.cfg"
## Section of config file 
@export var section: String = "Controls"
## Crosshair key under section
@export var key: String = "crosshair"
## If no settings are found, use these settings
@export var default_crosshair_settings: CrosshairSettings

@onready var parent: Crosshair = get_parent()
var config_file: ConfigFile

func _ready():
	config_file = ConfigFile.new()
	load_setting()
	# Connect any signals to settings changing to update user crosshair

func load_setting():
	print("loading crosshair config")
	config_file.load(settings_file)
	var settings: CrosshairSettings = CrosshairSettings.from_json(config_file.get_value(section, key, ""))
	
	if settings == null:
		settings = default_crosshair_settings
	
	parent.settings = settings
	parent.queue_redraw()
