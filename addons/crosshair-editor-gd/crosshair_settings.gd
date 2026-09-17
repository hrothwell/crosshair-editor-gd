@abstract
class_name CrosshairSettings extends Resource

## Called from parent to draw this crosshair on screen
@abstract func render(parent: Crosshair)

@abstract func get_type_string() -> String

@abstract func to_dict() -> Dictionary

static func to_json(setting: CrosshairSettings) -> String:
	return JSON.stringify(JSON.from_native(setting.to_dict()))

static func from_json(json: String) -> CrosshairSettings:
	var result: CrosshairSettings = null
	var parsed = JSON.parse_string(json)
	if parsed == null:
		printerr("Invalid crosshair: ", json)
		return null
	
	var dict = JSON.to_native(parsed)
	if dict == null:
		printerr("Invalid crosshair: ", json)
		return null
	var type_name: String = dict.get("name")
	
	match type_name:
		TCrosshairSettings.name: result = TCrosshairSettings.from_dict(dict)
		CircleCrosshairSettings.name: result = CircleCrosshairSettings.from_dict(dict)
		TextureCrosshairSettings.name: result = TextureCrosshairSettings.from_dict(dict)
	
	return result
