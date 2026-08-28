class_name UIPopup
extends BasePanel
## 弹窗面板：开/关动画（Fade / Scale 两种模式）+ 模态遮罩。
##
## 用法（业务侧）：
##   popup.open() / popup.close() / popup.toggle_open()
##   或按钮连接：button.pressed.connect(popup.open)
##   监听：opened / closed 信号
##
## animation_mode:
##   FADE  → 淡入淡出（默认）
##   SCALE → 从 scale_from 放大弹入 / 缩小退出
##   NONE  → 无动画

enum AnimationMode { NONE, FADE, SCALE }

@export var animation_mode: AnimationMode = AnimationMode.FADE
@export var animation_duration: float = 0.2
@export var scale_from: Vector2 = Vector2(0.85, 0.85)
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT

var _fade: FadeFeedback
var _scale: ScaleFeedback
var _closing: bool = false

func _ready() -> void:
	super()
	_fade = FadeFeedback.new(self)
	_scale = ScaleFeedback.new(self)
	visible = false # 编辑时可见，运行时收起

func open() -> void:
	_closing = false
	modulate.a = 1.0
	scale = Vector2.ONE
	super.open()

func _on_open() -> void:
	match animation_mode:
		AnimationMode.FADE:
			_fade.fade_in(animation_duration)
		AnimationMode.SCALE:
			scale = scale_from
			_scale.animate_to(Vector2.ONE, animation_duration, transition, ease)
		_:
			pass

func close() -> void:
	if not is_open or _closing:
		return
	_closing = true
	super.close() # 触发 _on_close 播放退场动画，动画结束后自行 hide()

func _on_close() -> void:
	match animation_mode:
		AnimationMode.FADE:
			_fade.fade_out(animation_duration, true)
		AnimationMode.SCALE:
			var exit_scale: Vector2 = scale_from * Vector2(0.95, 0.95)
			_scale.animate_to(exit_scale, animation_duration * 0.6, Tween.TRANS_QUAD, Tween.EASE_IN)
			await get_tree().create_timer(animation_duration * 0.6).timeout
			hide()
		_:
			hide()
