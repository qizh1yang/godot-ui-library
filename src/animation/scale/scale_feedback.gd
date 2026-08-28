class_name ScaleFeedback
extends RefCounted
## 缩放动画执行器（src/animation/scale/）：缩放至目标 / punch 回弹。
##
## 独立于交互与业务：由组件在 _apply_state() 中调用（见 .ai/animation_rules.md）。
## 防重：目标已达成则跳过；新动画先 kill 旧 Tween。

var _node: Control
var _tween: Tween

func _init(node: Control) -> void:
	_node = node

## 缩放至目标 scale。transition/ease 遵循 .ai/animation_rules.md 约定。
func animate_to(target: Vector2, duration: float = 0.12, transition: int = Tween.TRANS_BACK, ease: int = Tween.EASE_OUT) -> void:
	if _node == null or not is_instance_valid(_node):
		return
	if _node.scale.is_equal_approx(target):
		return
	_node.pivot_offset = _node.size * 0.5
	_kill()
	_tween = _node.create_tween()
	_tween.tween_property(_node, "scale", target, duration).set_trans(transition).set_ease(ease)

## 回弹：scale 1.0 → strength → 1.0（一次性反馈，如点击确认 / 奖励弹跳）。
func play_punch(strength: Vector2 = Vector2(1.15, 1.15), duration: float = 0.25) -> void:
	if _node == null or not is_instance_valid(_node):
		return
	_node.pivot_offset = _node.size * 0.5
	_kill()
	_tween = _node.create_tween()
	_tween.tween_property(_node, "scale", strength, duration * 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_node, "scale", Vector2.ONE, duration * 0.55).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func _kill() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null
