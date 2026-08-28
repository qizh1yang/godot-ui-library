class_name ScaleButton
extends UIButton
## 缩放反馈按钮：Hover 放大 / Press 缩小 / Release 弹回。
##
## 默认行为（全部可配置）：
##   Normal    → scale 1.0
##   Hover     → scale 1.05
##   Pressed   → scale 0.92
##   Release   → 弹回 1.0（TRANS_BACK 轻微过冲）

@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.92, 0.92)
@export var animation_duration: float = 0.12
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT

var _feedback: ScaleFeedback

func _ready() -> void:
	super()
	_feedback = ScaleFeedback.new(self)

func _apply_state(new_state: int) -> void:
	if _feedback == null:
		return
	match new_state:
		UIState.State.HOVER:
			_feedback.animate_to(hover_scale, animation_duration, transition, ease)
		UIState.State.PRESSED:
			_feedback.animate_to(press_scale, animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		UIState.State.NORMAL, UIState.State.DISABLED:
			_feedback.animate_to(Vector2.ONE, animation_duration, transition, ease)
