@tool
class_name CircleCrosshairSettings extends CrosshairSettings

static var name: String = "CircleCrosshairSettings"
@export var color: Color = Color.WHITE
@export var radius: float = 3.0
@export var thickness: float = 1.0
@export var fill: bool = false
@export var dot_radius: float = 0.0
@export var dot_color: Color = Color.WHITE

func render(parent: Crosshair) -> void:
	var resolved_thickness: float = thickness
	if fill:
		resolved_thickness = -1.0
	parent.draw_circle(Vector2.ZERO, radius, color, fill, resolved_thickness)
	
	if dot_radius > 0:
		parent.draw_circle(Vector2.ZERO, dot_radius, dot_color, true, -1.0)

func get_type_string() -> String:
	return name

func to_dict() -> Dictionary:
	return {
		"name": name,
		"color": color,
		"radius": radius,
		"thickness": thickness,
		"fill": fill,
		"dot_radius": dot_radius,
		"dot_color": dot_color,
	}

static func from_dict(dict: Dictionary) -> CircleCrosshairSettings:
	var setting := CircleCrosshairSettings.new()
	setting.color = dict.get("color")
	setting.radius = dict.get("radius")
	setting.thickness = dict.get("thickness")
	setting.fill = dict.get("fill")
	setting.dot_radius = dict.get("dot_radius")
	setting.dot_color = dict.get("dot_color")
	return setting
