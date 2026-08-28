class_name FadeFeedback
extends RefCounted
## 淡入淡出执行器（src/animation/fade/）：控制 modulate:a。
##
## 独立于交互与业务；由组件在 _apply_state() / 开合动画中调用。
## fade_out 可选在动画结束后隐藏节点（退场动画的常规收尾）。

var _node: Control
var _tween: Tween

func _init(node: Control) -> void:
	_node = node

## 淡至目标透明度（0.0 ~ 1.0）。
func animate_to(target_alpha: float, duration: float = 0.2, transition: int = Tween.TRANS_SINE, ease: int = Tween.EASE_OUT) -> void:
	if _node == null or not is_instance_valid(_node):
		return
	if is_equal_approx(_node.modulate.a, target_alpha):
		return
	_kill()
	_tween = _node.create_tween()
	_tween.tween_property(_node, "modulate:a", target_alpha, duration).set_trans(transition).set_ease(ease)

## 淡入：重置透明度为 0 后淡至 1.0（需节点已 show()）。
func fade_in(duration: float = 0.2) -> void:
	if _node == null or not is_instance_valid(_node):
		return
	_node.show()
	_node.modulate.a = 0.0
	animate_to(1.0, duration)

## 淡出至 0；hide_on_end 为 true 时动画结束自动 hide()。
func fade_out(duration: float = 0.2, hide_on_end: bool = true) -> void:
	if _node == null or not is_instance_valid(_node):
		return
	if is_equal_approx(_node.modulate.a, 0.0):
		if hide_on_end:
			_node.hide()
		return
	animate_to(0.0, duration)
	if hide_on_end and _tween != null:
		_tween.tween_callback(_node.hide)

func _kill() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null
