@tool
class_name TCrosshairSettings extends CrosshairSettings

static var name: String = "TCrosshairSettings"
@export var length: float = 3.0
@export var width: float = 1.0
@export var gap: float = 0.0
@export var dot_radius: float = 2.0
@export var color: Color = Color.WHITE
@export var dot_color: Color = Color.WHITE

func render(parent: Crosshair):
	var origin = Vector2.ZERO
	var top_start = origin.y - gap
	var bottom_start = origin.y + gap
	var right_start = origin.x + gap
	var left_start = origin.x - gap
	parent.draw_line(Vector2(origin.x, top_start), Vector2(origin.x, top_start - length), color, width)
	parent.draw_line(Vector2(origin.x, bottom_start), Vector2(origin.x, bottom_start + length), color, width)
	parent.draw_line(Vector2(right_start, origin.y), Vector2(right_start + length, origin.y), color, width)
	parent.draw_line(Vector2(left_start, origin.y), Vector2(left_start - length, origin.y), color, width)
	
	if dot_radius > 0:
		parent.draw_circle(origin, dot_radius, dot_color, true)

func get_type_string() -> String:
	return name

func to_dict() -> Dictionary:
	return {
		"name": name,
		"length": length,
		"width": width,
		"gap": gap,
		"dot_radius": dot_radius,
		"color": color,
		"dot_color": dot_color,
	}

static func from_dict(dict: Dictionary) -> TCrosshairSettings:
	var setting := TCrosshairSettings.new()
	setting.length = dict.get("length")
	setting.width = dict.get("width")
	setting.gap = dict.get("gap")
	setting.dot_radius = dict.get("dot_radius")
	setting.color = dict.get("color")
	setting.dot_color = dict.get("dot_color")
	return setting
