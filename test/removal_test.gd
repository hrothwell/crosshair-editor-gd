extends Control
@onready var button: Button = %Button
@onready var crosshair: Crosshair = %Crosshair

func _ready() -> void:
	button.pressed.connect(func(): crosshair.queue_free())
