class_name CrosshairEditor extends PanelContainer

## Where to import/export crosshair settings on user disk
@export var folder_location: String = "user://settings/crosshairs"
## Max length of lines and diameters of circles/dots
@export var max_length: float = 50.0

## CrosshairSetting
signal file_saved

## CrosshairSetting
signal file_loaded

signal preview_changed

@onready var save_dialog: FileDialog = %SaveDialog
@onready var save_button: Button = %Export
@onready var open_dialog: FileDialog = %OpenDialog
@onready var select_file: Button = %ImportFile
@onready var preview_container: CenterContainer = %CrosshairPreviewContainer
@onready var tab_container: TabContainer = %TabContainer

#region textures
@onready var texture_file_dialog: FileDialog = %FileDialog
@onready var select_texture_button: Button = %SelectTextureButton
@onready var selected_file_label: Label = %SelectedFileLabel
@onready var texture_scale: HSlider = %ScaleValue
#endregion

#region circle
@onready var radius_value: HSlider = %RadiusValue
@onready var circle_color: ColorPickerButton = %CircleColorPickerButton
@onready var circle_width: HSlider = %CircleWidthValue
@onready var fill: CheckButton = %FillButton
@onready var circle_dot_radius_value: HSlider = %CircleDotRadiusValue
@onready var circle_dot_color_picker_button: ColorPickerButton = %CircleDotColorPickerButton
#endregion

#region cross
@onready var cross_length_value: HSlider = %CrossLengthValue
@onready var cross_width_value: HSlider = %CrossWidthValue
@onready var cross_color_picker_button: ColorPickerButton = %CrossColorPickerButton
@onready var cross_dot_radius_value: HSlider = %CrossDotRadiusValue
@onready var cross_dot_color_picker_button: ColorPickerButton = %CrossDotColorPickerButton
@onready var cross_gap_value: HSlider = %CrossGapValue
#endregion

var previewed_setting: CrosshairSettings

var types_to_tabs: Dictionary[String, int] = {
	TCrosshairSettings.name: 0,
	CircleCrosshairSettings.name: 1,
	TextureCrosshairSettings.name: 2
}

func _ready() -> void:
	if !DirAccess.dir_exists_absolute(folder_location):
		DirAccess.make_dir_recursive_absolute(folder_location)

	save_dialog.root_subfolder = folder_location
	open_dialog.root_subfolder = folder_location
	save_button.pressed.connect(save)
	select_file.pressed.connect(open)
	
	for slider: HSlider in [radius_value,
		cross_length_value,
		cross_gap_value
	]:
		slider.max_value = max_length
		slider.value = max_length / 2.0
		slider.step = max_length / 100.0
	for slider: HSlider in [circle_width,
		cross_width_value,
		cross_dot_radius_value,
		circle_dot_radius_value
	]:
		slider.max_value = max_length
		slider.value = max_length / 10.0
		slider.step = max_length / 100.0
	
	tab_container.tab_changed.connect(_on_switch_tab)
	# Textures
	select_texture_button.pressed.connect(texture_file_dialog.show)
	texture_file_dialog.file_selected.connect(set_file)
	texture_scale.value_changed.connect(preview_texture.unbind(1))
	
	# circle
	radius_value.value_changed.connect(preview_circle.unbind(1))
	circle_dot_radius_value.value_changed.connect(preview_circle.unbind(1))
	circle_dot_color_picker_button.color_changed.connect(preview_circle.unbind(1))
	circle_color.color_changed.connect(preview_circle.unbind(1))
	circle_width.value_changed.connect(preview_circle.unbind(1))
	fill.pressed.connect(preview_circle)
	
	# cross
	cross_length_value.value_changed.connect(preview_cross.unbind(1))
	cross_width_value.value_changed.connect(preview_cross.unbind(1))
	cross_color_picker_button.color_changed.connect(preview_cross.unbind(1))
	cross_dot_radius_value.value_changed.connect(preview_cross.unbind(1))
	cross_dot_color_picker_button.color_changed.connect(preview_cross.unbind(1))
	cross_gap_value.value_changed.connect(preview_cross.unbind(1))
	
	preview_changed.connect(update_settings_for_preview)
	
	# generate a preview
	_on_switch_tab(tab_container.current_tab)
	
func _on_switch_tab(id: int) -> void:
	var tab_name: String = tab_container.get_tab_title(id)
	match tab_name:
		"Cross":
			preview_cross()
		"Circle":
			preview_circle()
		"Texture":
			preview_texture()

func preview(settings: CrosshairSettings) -> void:
	for c in preview_container.get_children():
		preview_container.remove_child(c)
		c.queue_free()
	
	if settings == null: return
	
	var preview: Crosshair = Crosshair.new()
	preview.settings = settings
	preview_container.add_child(preview)
	previewed_setting = settings
	preview_changed.emit(previewed_setting)
	var target_tab = types_to_tabs[previewed_setting.get_type_string()]
	if target_tab != tab_container.current_tab:
		tab_container.current_tab = target_tab

func update_settings_for_preview(preview: CrosshairSettings) -> void:
	# Unfortunate need due to race conditions on these updates setting values
	var children: Array[Node] = find_children("*")
	for c in children:
		c.set_block_signals(true)
		
	if preview is TCrosshairSettings:
		update_cross_values(preview)
	elif preview is CircleCrosshairSettings:
		update_circle_settings(preview)
	else:
		update_texture_settings(preview)
	
	for c in children:
		c.set_block_signals(false)

#region preview cross
func preview_cross() -> void:
	var cross_settings: TCrosshairSettings = TCrosshairSettings.new()
	cross_settings.color = cross_color_picker_button.color
	cross_settings.gap = cross_gap_value.value
	cross_settings.length = cross_length_value.value
	cross_settings.width = cross_width_value.value
	cross_settings.dot_radius = cross_dot_radius_value.value
	cross_settings.dot_color = cross_dot_color_picker_button.color
	preview(cross_settings)

func update_cross_values(cross_settings: TCrosshairSettings) -> void:
	cross_color_picker_button.color = cross_settings.color
	cross_gap_value.value = cross_settings.gap
	cross_length_value.value = cross_settings.length
	cross_width_value.value = cross_settings.width
	cross_dot_radius_value.value = cross_settings.dot_radius
	cross_dot_color_picker_button.color = cross_settings.dot_color
#endregion

#region circle previews
func preview_circle() -> void:
	var circle_settings: CircleCrosshairSettings = CircleCrosshairSettings.new()
	circle_settings.color = circle_color.color
	circle_settings.fill = fill.button_pressed
	circle_settings.radius = radius_value.value
	circle_settings.thickness = circle_width.value
	circle_settings.dot_radius = circle_dot_radius_value.value
	circle_settings.dot_color = circle_dot_color_picker_button.color
	preview(circle_settings)

func update_circle_settings(circle_settings: CircleCrosshairSettings) -> void:
	circle_color.color = circle_settings.color
	fill.button_pressed = circle_settings.fill
	radius_value.value = circle_settings.radius
	circle_width.value = circle_settings.thickness
	circle_dot_radius_value.value = circle_settings.dot_radius
	circle_dot_color_picker_button.color = circle_settings.dot_color
#endregion

#region texture previews
func set_file(path: String) -> void:
	selected_file_label.text = path
	preview_texture()

func preview_texture() -> void:
	if !FileAccess.file_exists(selected_file_label.text):
		preview(null)
		return
	
	var texture_settings: TextureCrosshairSettings = TextureCrosshairSettings.new()
	texture_settings.texture_file = selected_file_label.text
	texture_settings.texture_scaling = texture_scale.value
	preview(texture_settings)

func update_texture_settings(texture_settings: TextureCrosshairSettings):
	selected_file_label.text = texture_settings.texture_file
	texture_scale.value = texture_settings.texture_scaling
#endregion

func save() -> void:
	save_dialog.show()
	save_dialog.file_selected.connect(func(path: String):
		var crosshair_file = FileAccess.open(path, FileAccess.WRITE)
		var json: String = CrosshairSettings.to_json(previewed_setting)
		crosshair_file.store_line(json)
		file_saved.emit(previewed_setting),
		ConnectFlags.CONNECT_ONE_SHOT)

func open() -> void:
	open_dialog.show()
	open_dialog.file_selected.connect(func(path: String):
		var crosshair_setting: CrosshairSettings = CrosshairSettings.from_json(FileAccess.get_file_as_string(path))
		preview(crosshair_setting)
		file_loaded.emit(crosshair_setting),
		ConnectFlags.CONNECT_ONE_SHOT)
