class_name Card
extends PanelContainer
## 可选卡片（Behavior Block）：hover / 选中 / 禁用状态切换。
## 原则：状态视觉（背景/边框/圆角）全部走 Theme 变体（Card / CardHover / CardSelected / CardDisabled），
##       脚本只负责"状态切换"本身（Theme 做不了状态变化）和可选缩放反馈。

signal clicked(card: Card)
signal selected_changed(card: Card, is_selected: bool)

## 是否可点击选中（切换 SELECTED 状态）。
@export var selectable: bool = true
@export var default_selected: bool = false
## 禁用：拦截一切交互，视觉变体切到 CardDisabled。
@export var disabled: bool = false
## 悬停/选中缩放（1.0 = 不缩放，纯视觉交给 Theme 变体）。
@export var hover_scale: Vector2 = Vector2(1.0, 1.0)
@export var selected_scale: Vector2 = Vector2(1.0, 1.0)
@export var duration: float = 0.12

var is_selected: bool = false
var _hovering: bool = false
var _tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	if disabled:
		_apply_visual()
	elif default_selected:
		set_selected(true)
	else:
		_apply_visual()

func _on_mouse_entered() -> void:
	if disabled:
		return
	_hovering = true
	_apply_visual()

func _on_mouse_exited() -> void:
	if disabled:
		return
	_hovering = false
	_apply_visual()

func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		clicked.emit(self)
		if selectable:
			set_selected(not is_selected)
		else:
			_apply_visual()

func set_selected(selected: bool) -> void:
	if is_selected == selected:
		return
	is_selected = selected
	selected_changed.emit(self, selected)
	_apply_visual()

func set_disabled(value: bool) -> void:
	if disabled == value:
		return
	disabled = value
	_apply_visual()

## 状态 → Theme 变体 + 可选缩放。所有视觉值都来自 Theme / 参数，脚本不写死颜色。
func _apply_visual() -> void:
	var variation: StringName = &"Card"
	if disabled:
		variation = &"CardDisabled"
	elif is_selected:
		variation = &"CardSelected"
	elif _hovering:
		variation = &"CardHover"
	theme_type_variation = variation

	var target := Vector2.ONE
	if not disabled:
		if is_selected:
			target = selected_scale
		elif _hovering:
			target = hover_scale
	_animate_to(target)

func _animate_to(target: Vector2) -> void:
	if scale.is_equal_approx(target):
		return
	pivot_offset = size * 0.5
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "scale", target, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
