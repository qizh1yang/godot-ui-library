extends Control
## Drawer 积木 Demo：右侧 / 左侧 / 底部三个抽屉的滑入滑出。
## 抽屉内容由脚本动态填充（DrawerPanel 只负责滑动行为）。

@onready var _right: DrawerPanel = $RightDrawer
@onready var _left: DrawerPanel = $LeftDrawer
@onready var _bottom: DrawerPanel = $BottomDrawer
@onready var _log: Label = $Root/Log

func _ready() -> void:
	theme = DemoTheme.build()
	$Root/Row/OpenRightBtn.pressed.connect(func() -> void: _right.open())
	$Root/Row/OpenLeftBtn.pressed.connect(func() -> void: _left.open())
	$Root/Row/OpenBottomBtn.pressed.connect(func() -> void: _bottom.open())
	for drawer: DrawerPanel in [_right, _left, _bottom]:
		drawer.opened.connect(func() -> void: _log.text = "drawer: opened")
		drawer.closed.connect(func() -> void: _log.text = "drawer: closed")
	_setup_content(_right, "右侧抽屉", "direction = RIGHT")
	_setup_content(_left, "左侧抽屉", "direction = LEFT")
	_setup_content(_bottom, "底部抽屉", "direction = BOTTOM")

func _setup_content(drawer: DrawerPanel, title: String, desc: String) -> void:
	var content: Node = drawer.get_node("Content")
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 16)
	content.add_child(vbox)

	var title_label := Label.new()
	title_label.text = title
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title_label)

	var desc_label := Label.new()
	desc_label.text = desc
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.add_theme_color_override("font_color", Color(0.7, 0.72, 0.8))
	vbox.add_child(desc_label)

	var close_btn := ScaleButton.new()
	close_btn.text = "关闭"
	close_btn.custom_minimum_size = Vector2(140, 44)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.pressed.connect(drawer.close)
	vbox.add_child(close_btn)
