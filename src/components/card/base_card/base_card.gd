class_name BaseCard
extends UIComponent
## 卡片基类：Normal / Hover / Pressed / Selected / Disabled 状态管理。
## 不绑定任何具体游戏数据——内容由使用方（子类 / Gameplay UI）填充。
##
## 交互：鼠标悬停 → HOVER 缩放；点击 → PRESSED；松开 → clicked 信号 + 选中切换（selectable）。
## 对外信号：clicked(card) / selected_changed(card, is_selected)。

signal clicked(card: BaseCard)
signal selected_changed(card: BaseCard, is_selected: bool)

## 是否可被点击选中（切换 SELECTED 状态）。
@export var selectable: bool = true
@export var default_selected: bool = false
## 禁用：拦截一切交互，视觉变暗（DISABLED 状态）。
@export var disabled: bool = false
@export var hover_scale: Vector2 = Vector2(1.02, 1.02)
@export var press_scale: Vector2 = Vector2(0.98, 0.98)
@export var selected_scale: Vector2 = Vector2(1.05, 1.05)
@export var animation_duration: float = 0.12
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT
## 悬停/选中时 modulate 亮度倍率（背景自绘无主题反馈，用亮度区分状态）。
@export var hover_brightness: float = 1.08
@export var selected_brightness: float = 1.15

var is_selected: bool = false

var _feedback: ScaleFeedback
var _normal_modulate: Color = Color.WHITE

func _ready() -> void:
	super()
	_normal_modulate = modulate
	_feedback = ScaleFeedback.new(self)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	if default_selected:
		set_selected(true)
	if disabled:
		_set_state(UIState.State.DISABLED)

func set_disabled(value: bool) -> void:
	disabled = value
	var next: int = UIState.State.DISABLED if value else (UIState.State.SELECTED if is_selected else UIState.State.NORMAL)
	_set_state(next)

func _on_mouse_entered() -> void:
	if disabled:
		return
	_set_state(UIState.State.HOVER)

func _on_mouse_exited() -> void:
	if disabled:
		return
	_set_state(UIState.State.SELECTED if is_selected else UIState.State.NORMAL)

func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_set_state(UIState.State.PRESSED)
		else:
			clicked.emit(self)
			if selectable:
				set_selected(not is_selected)
			_set_state(UIState.State.SELECTED if is_selected else UIState.State.HOVER)

func set_selected(selected: bool) -> void:
	if is_selected == selected:
		return
	is_selected = selected
	selected_changed.emit(self, selected)
	_set_state(UIState.State.SELECTED if selected else UIState.State.NORMAL)

func _apply_state(new_state: int) -> void:
	if _feedback == null:
		return
	match new_state:
		UIState.State.HOVER:
			_feedback.animate_to(hover_scale, animation_duration, transition, ease)
			modulate = _normal_modulate * hover_brightness
		UIState.State.PRESSED:
			_feedback.animate_to(press_scale, animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
			modulate = _normal_modulate * 0.95
		UIState.State.SELECTED:
			_feedback.animate_to(selected_scale, animation_duration, transition, ease)
			modulate = _normal_modulate * selected_brightness
		UIState.State.DISABLED:
			_feedback.animate_to(Vector2.ONE, animation_duration, transition, ease)
			modulate = _normal_modulate * 0.6
		UIState.State.NORMAL:
			_feedback.animate_to(Vector2.ONE, animation_duration, transition, ease)
			modulate = _normal_modulate
