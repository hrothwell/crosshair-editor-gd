# crosshair-editor-gd

A simple crosshair editor for use in Godot

## Features
- Visual editor for 3 static crosshair types - `CrosshairEditor.tscn`
- Save crosshair data to specified path 
- Import crosshair data from same specified path
- `Crosshair.tscn` for dispalying the crosshair in game 
- Example setting loader in `crosshair_setting_loader.gd` 

## Usage 

### Editing
Use `CrosshairEditor.tscn` for a visual editor. Adjust different values and see preview update after edits, export displayed settings, and load previously exported settings. Exported settings are saved as JSON and should be accessed via `CrosshairSettings.from_json(...)`

### Render in game
To render in game place the `Crosshair.tscn` node at your desired rendering location. This scene takes a `CrosshairSetting`, either provide a fixed setting resource or load a previously exported setting via `CrosshairSettings.from_json(...)`

An example component is included as `CrosshairSettingLoaderComponent` for loading data for `Crosshair.tscn`

## Examples

### Save / load user settings to game config

```gdscript
@onready var crosshair_editor: CrosshairEditor = $CrosshairEditor
var file_path := "user://controls.cfg"
var config_file := ConfigFile.new()
var section: String = "Controls"

func _ready() -> void:
    config_file.load(file_path)

func save_crosshair() -> void:
    var json: String = crosshair_editor.previewed_setting.to_json()
    config_file.set_value(section, "crosshair", json)

func load_crosshair() -> void:
    var json: String = config_file.get_value(section, "crosshair", "")
    var crosshair_setting: CrosshairSetting = CrosshairSetting.from_json(json)
```