extends Control
## Button 族 Demo：状态展示（hover/press/toggle）+ 参数实时调节。
## 可 F6 单独运行；也可被 UIShowcase 加载（theme 继承自 Showcase，单独运行自建）。

@onready var _scale_btn: ScaleButton = $Root/Row1/ScaleBtn
@onready var _state_label: Label = $Root/StateLabel
@onready var _toggle_log: Label = $Root/ToggleLog
@onready var _hover_slider: HSlider = $Root/Param1/HoverSlider
@onready var _dur_slider: HSlider = $Root/Param2/DurSlider
@onready var _p1_value: Label = $Root/Param1/P1Value
@onready var _p2_value: Label = $Root/Param2/P2Value

func _ready() -> void:
	theme = DemoTheme.build()
	for child: Node in $Root/Row1.get_children():
		if child is UIButton:
			child.state_changed.connect(_on_state_changed)
	for child: Node in $Root/Row2.get_children():
		if child is UIButton:
			child.state_changed.connect(_on_state_changed)
			child.toggled.connect(_on_toggled.bind(child.text))
	_hover_slider.value_changed.connect(_on_hover_changed)
	_dur_slider.value_changed.connect(_on_dur_changed)
	_p1_value.text = "%.2f" % _hover_slider.value
	_p2_value.text = "%.2f" % _dur_slider.value

func _on_state_changed(from: int, to: int) -> void:
	_state_label.text = "state: %s → %s" % [UIState.name_of(from), UIState.name_of(to)]

func _on_toggled(selected: bool, btn_name: String) -> void:
	_toggle_log.text = "toggle: %s → %s" % [btn_name, "ON" if selected else "OFF"]

func _on_hover_changed(value: float) -> void:
	_scale_btn.hover_scale = Vector2(value, value)
	_p1_value.text = "%.2f" % value

func _on_dur_changed(value: float) -> void:
	_scale_btn.animation_duration = value
	_p2_value.text = "%.2f" % value
