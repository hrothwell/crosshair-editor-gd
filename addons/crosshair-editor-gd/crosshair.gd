@tool
class_name Crosshair extends Control

var _teardown: bool = false

@export var settings: CrosshairSettings:
	set(new_settings):
		for c in get_children():
			if c is CrosshairRect:
				remove_child(c)
				c.queue_free()
		settings = new_settings

func _ready() -> void:
	if Engine.is_editor_hint():
		visibility_changed.connect(queue_redraw)
	if settings:
		draw.connect(settings.render.bind(self))

func _draw() -> void:
	if settings == null:
		printerr("Crosshair settings not present")
		return
	settings.render(self)
