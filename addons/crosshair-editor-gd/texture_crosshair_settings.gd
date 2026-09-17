@tool
class_name TextureCrosshairSettings extends CrosshairSettings

static var name: String = "TextureCrosshairSettings"
## file to use on user disk
@export_global_file("*.png") var texture_file: String
## scale the texture up or down
@export_range(0.01, 2.0, 0.01) var texture_scaling: float = 1.0

func render(parent: Crosshair) -> void:
	var texture_2d: Texture2D = load(texture_file)
	var rect: CrosshairRect = CrosshairRect.new()
	rect.texture = texture_2d
	rect.process_mode = Node.PROCESS_MODE_DISABLED
	parent.add_child(rect)
	rect.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	rect.pivot_offset = rect.size / 2.0
	rect.scale = rect.scale * texture_scaling

func get_type_string() -> String:
	return name

func to_dict() -> Dictionary:
	return {
		"name": name,
		"texture_file": texture_file,
		"texture_scaling": texture_scaling
	}

static func from_dict(dict: Dictionary) -> TextureCrosshairSettings:
	var setting := TextureCrosshairSettings.new()
	setting.texture_file = dict.get("texture_file")
	setting.texture_scaling = dict.get("texture_scaling")
	return setting
