class_name BounceFeedback
extends RefCounted
## 弹性回弹执行器（src/animation/bounce/）：scale 1.0 → strength → 1.0。
##
## 与 ScaleFeedback.play_punch 的区别：Bounce 可自定义 transition 且两段独立时长，
## 用于「点击确认 / 奖励获得 / 卡片弹跳」等一次性弹性反馈。

var _node: Control
var _tween: Tween

func _init(node: Control) -> void:
	_node = node

## 弹性回弹：先弹到 strength，再回落到 1.0。
func play(strength: Vector2 = Vector2(1.15, 1.15), duration: float = 0.25, transition: int = Tween.TRANS_BACK) -> void:
	if _node == null or not is_instance_valid(_node):
		return
	_node.pivot_offset = _node.size * 0.5
	_kill()
	_tween = _node.create_tween()
	_tween.tween_property(_node, "scale", strength, duration * 0.45).set_trans(transition).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_node, "scale", Vector2.ONE, duration * 0.55).set_trans(transition).set_ease(Tween.EASE_IN_OUT)

func _kill() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null
