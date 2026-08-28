class_name UIPopup
extends PanelContainer
## 弹窗（Behavior Block）：开合动画（Fade / Scale 两种模式）+ 模态遮罩。
## 原则：视觉样式交给 Theme（类型名 UIPopup）；脚本只负责"屏幕外/隐藏 → 显示"的行为。

enum AnimationMode { NONE, FADE, SCALE }

signal opened
signal closed

@export var animation_mode: AnimationMode = AnimationMode.FADE
@export var duration: float = 0.2
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT
@export var scale_from: Vector2 = Vector2(0.85, 0.85)
@export var modal: bool = false
@export var close_on_click_outside: bool = true

var is_open: bool = false
var _closing: bool = false
var _dim: ColorRect = null
var _fade_tween: Tween
var _scale_tween: Tween

func _ready() -> void:
	_dim = get_node_or_null("ModalDim") as ColorRect
	if _dim != null:
		_dim.mouse_filter = Control.MOUSE_FILTER_STOP
		_dim.gui_input.connect(_on_dim_input)
	visible = false # 编辑时可见，运行时收起

func open() -> void:
	if is_open:
		return
	_closing = false
	is_open = true
	show()
	if modal and _dim != null:
		_dim.global_position = Vector2.ZERO
		_dim.size = get_viewport_rect().size
		_dim.show()
	match animation_mode:
		AnimationMode.FADE:
			_kill_tweens()
			modulate.a = 0.0
			_fade_tween = create_tween()
			_fade_tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(transition).set_ease(ease)
		AnimationMode.SCALE:
			_kill_tweens()
			scale = scale_from
			pivot_offset = size * 0.5
			_scale_tween = create_tween()
			_scale_tween.tween_property(self, "scale", Vector2.ONE, duration).set_trans(transition).set_ease(ease)
	opened.emit()

func close() -> void:
	if not is_open or _closing:
		return
	_closing = true
	is_open = false
	if _dim != null:
		_dim.hide()
	match animation_mode:
		AnimationMode.FADE:
			_kill_tweens()
			_fade_tween = create_tween()
			_fade_tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(transition).set_ease(ease)
			_fade_tween.tween_callback(hide)
		AnimationMode.SCALE:
			_kill_tweens()
			_scale_tween = create_tween()
			_scale_tween.tween_property(self, "scale", scale_from * Vector2(0.95, 0.95), duration * 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			_scale_tween.tween_callback(hide)
		_:
			hide()
	closed.emit()

func toggle_open() -> void:
	if is_open:
		close()
	else:
		open()

func _on_dim_input(event: InputEvent) -> void:
	if close_on_click_outside and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close()

func _kill_tweens() -> void:
	if _fade_tween != null and _fade_tween.is_valid():
		_fade_tween.kill()
	if _scale_tween != null and _scale_tween.is_valid():
		_scale_tween.kill()
