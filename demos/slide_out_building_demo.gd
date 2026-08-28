extends Control
## SlideOutBuildingDemo：验证 SlideOutPanel 积木（内容可替换 + 拖出建筑）。
## SlideOutPanel 本身不含任何建筑逻辑——建筑数据/槽/拖放全在此 Demo 层。

const BUILDINGS: Array[Dictionary] = [
	{"id": "house", "icon": "🏠", "name": "House"},
	{"id": "farm", "icon": "🌾", "name": "Farm"},
	{"id": "mine", "icon": "⛏️", "name": "Mine"},
	{"id": "tower", "icon": "🗼", "name": "Tower"},
	{"id": "storage", "icon": "📦", "name": "Storage"},
]

const SLOT_SCENE: PackedScene = preload("res://demos/BuildingSlot.tscn")

@onready var _panel: SlideOutPanel = $SlideOutPanel
@onready var _hint: Label = $Hint

func _ready() -> void:
	theme = DemoTheme.build()
	_setup_content()
	_panel.opened.connect(func() -> void: _hint.text = "面板已展开 — 拖出建筑到地图")
	_panel.closed.connect(func() -> void: _hint.text = "已收起 — 点击 ▶ 再展开")

## 往 SlideOutPanel 的 Content 填充建筑列表（Content 可替换的验证）。
func _setup_content() -> void:
	var content: Node = _panel.get_node("Panel/Content")
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	content.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 8)
	scroll.add_child(vbox)

	for b: Dictionary in BUILDINGS:
		var slot: BuildingSlot = SLOT_SCENE.instantiate() as BuildingSlot
		slot.building_id = b["id"]
		slot.icon_text = b["icon"]
		slot.display_name = b["name"]
		vbox.add_child(slot)
