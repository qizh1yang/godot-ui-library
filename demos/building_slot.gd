class_name BuildingSlot
extends PanelContainer
## Demo 建筑槽：显示建筑图标 + 名称，支持拖出（原生 _get_drag_data）。
## 拖拽数据只含 type + building_id + icon——槽【不】实例化建筑，放置由地图决定。
## 纯 Demo 用（非通用 Block）：演示"内容可替换 + 拖拽"。

@export var building_id: String = "house"
@export var icon_text: String = "🏠"
@export var display_name: String = "House"

func _ready() -> void:
	theme_type_variation = &"BuildingSlot"
	$HBox/Icon.text = icon_text
	$HBox/Name.text = display_name
	mouse_entered.connect(func() -> void: theme_type_variation = &"BuildingSlotHover")
	mouse_exited.connect(func() -> void: theme_type_variation = &"BuildingSlot")

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := Label.new()
	preview.text = icon_text
	preview.add_theme_font_size_override("font_size", 48)
	set_drag_preview(preview)
	return {"type": "building", "building_id": building_id, "icon": icon_text}
