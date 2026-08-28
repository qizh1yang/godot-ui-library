extends Control
## Panel 积木 Demo：普通 Panel（Pure）+ PopupPanel（Behavior）两种开合动画。
## 弹窗内容由脚本动态填充（弹窗组件只负责开合行为，内容由使用方提供）。

@onready var _fade_popup: UIPopup = $FadePopup
@onready var _scale_popup: UIPopup = $ScalePopup
@onready var _log: Label = $Root/Log

func _ready() -> void:
	theme = DemoTheme.build()
	$Root/Row/OpenFadeBtn.pressed.connect(func() -> void: _fade_popup.open())
	$Root/Row/OpenScaleBtn.pressed.connect(func() -> void: _scale_popup.open())
	_fade_popup.opened.connect(func() -> void: _log.text = "popup: Fade opened")
	_fade_popup.closed.connect(func() -> void: _log.text = "popup: Fade closed")
	_scale_popup.opened.connect(func() -> void: _log.text = "popup: Scale opened")
	_scale_popup.closed.connect(func() -> void: _log.text = "popup: Scale closed")
	_setup_content(_fade_popup, "Fade 弹窗")
	_setup_content(_scale_popup, "Scale 弹窗")

func _setup_content(popup: UIPopup, title: String) -> void:
	var content: Node = popup.get_node("Content")
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

	var close_btn := ScaleButton.new()
	close_btn.text = "关闭"
	close_btn.custom_minimum_size = Vector2(140, 44)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.pressed.connect(popup.close)
	vbox.add_child(close_btn)
