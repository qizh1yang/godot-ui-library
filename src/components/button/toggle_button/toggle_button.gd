class_name ToggleButton
extends UIButton
## 开关按钮：toggle_mode + 选中缩放反馈。
##
## 状态：Normal / Selected / Disabled。
## 对外信号：原生 Button.toggled(button_pressed)——组件只发信号，不操作业务。
## 视觉：选中 → scale selected_scale（保持）；取消 → 弹回 1.0；hover/press 交给默认主题。

@export var selected_scale: Vector2 = Vector2(1.08, 1.08)
@export var animation_duration: float = 0.12
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT

var _feedback: ScaleFeedback

func _ready() -> void:
	super()
	toggle_mode = true
	_feedback = ScaleFeedback.new(self)
	toggled.connect(_on_toggled)

func _on_toggled(is_selected: bool) -> void:
	_set_state(UIState.State.SELECTED if is_selected else UIState.State.NORMAL)

func _apply_state(new_state: int) -> void:
	if _feedback == null:
		return
	match new_state:
		UIState.State.SELECTED:
			_feedback.animate_to(selected_scale, animation_duration, transition, ease)
		UIState.State.NORMAL, UIState.State.DISABLED:
			_feedback.animate_to(Vector2.ONE, animation_duration, transition, ease)
		_:
			pass # HOVER / PRESSED 由默认主题样式表现（选中态才是缩放反馈）
