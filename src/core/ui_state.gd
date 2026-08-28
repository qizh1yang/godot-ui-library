class_name UIState
extends RefCounted
## 统一状态机：所有组件共享的状态定义与流转。
## 组合使用（Godot 单节点脚本限制下，状态机不靠继承复用，而是每个组件持有实例）。

enum State { NORMAL, HOVER, PRESSED, SELECTED, DISABLED }

## 状态切换信号（from/to 为 State 枚举值）。
signal changed(from: int, to: int)

## 当前状态，默认 NORMAL。
var current: int = State.NORMAL

## 切换到新状态；相同状态不重复触发（防重）。返回是否真的发生了切换。
func transition(new_state: int) -> bool:
	if new_state == current:
		return false
	var prev: int = current
	current = new_state
	changed.emit(prev, new_state)
	return true

func is_state(state_id: int) -> bool:
	return current == state_id

## 状态枚举值 → 名称（NORMAL / HOVER / ...），用于 Demo 状态回显与日志。
static func name_of(state_id: int) -> String:
	var keys: Array = State.keys()
	if state_id < 0 or state_id >= keys.size():
		return "UNKNOWN"
	return str(keys[state_id])
