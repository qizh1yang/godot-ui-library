class_name ScaleButton
extends Button
## 缩放反馈按钮（Behavior Block）。
## 原则：视觉样式（颜色/边框/圆角）全部交给 Theme；本脚本只负责 Theme 做不了的 Transform。
## 行为：Hover 放大 → Pressed 缩小 → Release 弹回（TRANS_BACK 轻微过冲）。

@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.92, 0.92)
@export var duration: float = 0.12
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT

var _tween: Tween
var _was_disabled: bool = false

func _ready() -> void:
	_was_disabled = disabled
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _process(_delta: float) -> void:
	# 禁用状态同步：原生 set_disabled 非虚不可覆写，且 Button 无 disabled_changed 信号——轮询
	if disabled != _was_disabled:
		_was_disabled = disabled
		if disabled:
			_animate_to(Vector2.ONE)

func _on_mouse_entered() -> void:
	if not disabled:
		_animate_to(hover_scale)

func _on_mouse_exited() -> void:
	if not disabled:
		_animate_to(Vector2.ONE)

func _on_button_down() -> void:
	if not disabled:
		_animate_to(press_scale)

func _on_button_up() -> void:
	if not disabled:
		var over: bool = get_global_rect().has_point(get_global_mouse_position())
		_animate_to(hover_scale if over else Vector2.ONE)

func _animate_to(target: Vector2) -> void:
	if scale.is_equal_approx(target):
		return
	pivot_offset = size * 0.5
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "scale", target, duration).set_trans(transition).set_ease(ease)
