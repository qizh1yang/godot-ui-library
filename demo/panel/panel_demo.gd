extends Control
## Panel 族 Demo：UIPopup 的 Fade / Scale 两种开合动画 + 模态遮罩关闭。
## 可 F6 单独运行；也可被 UIShowcase 加载。

@onready var _fade_popup: UIPopup = $FadePopup
@onready var _scale_popup: UIPopup = $ScalePopup
@onready var _log: Label = $Root/Log

func _ready() -> void:
	theme = DemoTheme.build()
	$Root/Row/OpenFadeBtn.pressed.connect(func() -> void: _fade_popup.open())
	$Root/Row/OpenScaleBtn.pressed.connect(func() -> void: _scale_popup.open())
	_fade_popup.opened.connect(func() -> void: _log_text("Fade popup opened"))
	_fade_popup.closed.connect(func() -> void: _log_text("Fade popup closed"))
	_scale_popup.opened.connect(func() -> void: _log_text("Scale popup opened"))
	_scale_popup.closed.connect(func() -> void: _log_text("Scale popup closed"))
	_setup_content(_fade_popup, "Fade 弹窗", Color(0.16, 0.22, 0.32))
	_setup_content(_scale_popup, "Scale 弹窗", Color(0.24, 0.16, 0.32))

func _log_text(msg: String) -> void:
	_log.text = "popup: " + msg

## 动态填充弹窗内容（弹窗组件只负责开合动画，内容由使用方提供）。
func _setup_content(popup: UIPopup, title: String, accent: Color) -> void:
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

	var mode_label := Label.new()
	mode_label.text = "UIPopup · animation_mode = %d" % popup.animation_mode
	mode_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mode_label.add_theme_color_override("font_color", Color(0.7, 0.72, 0.8))
	vbox.add_child(mode_label)

	var close_btn := ScaleButton.new()
	close_btn.text = "关闭"
	close_btn.custom_minimum_size = Vector2(140, 44)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.pressed.connect(popup.close)
	vbox.add_child(close_btn)
