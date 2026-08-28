class_name UIButton
extends Button
## 按钮族基类：把原生 Button 的交互信号映射到统一状态机（UIState）。
## 子类实现 _apply_state() 决定视觉反馈（ScaleButton 缩放、ToggleButton 选中高亮……）。
##
## 状态流转：NORMAL ↔ HOVER ↔ PRESSED；disabled → DISABLED（拦截一切交互）。
## 对外信号：state_changed(from, to)；业务信号沿用 Button 原生（pressed / toggled / button_up...）。

signal state_changed(from: int, to: int)

## 组件持有的状态机（组合复用，见 src/core/ui_state.gd）。
var state: UIState = UIState.new()

var _last_disabled: bool = false

func _ready() -> void:
	_last_disabled = disabled
	state.changed.connect(_on_state_changed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _process(_delta: float) -> void:
	# 原生 set_disabled 非虚方法不可安全覆写（引擎不调用），且 Button 无 disabled_changed 信号——
	# 用每帧轮询同步禁用状态到状态机（bool 比较，开销可忽略）。
	if disabled != _last_disabled:
		_last_disabled = disabled
		_set_state(UIState.State.DISABLED if disabled else UIState.State.NORMAL)

func _on_mouse_entered() -> void:
	if not disabled:
		_set_state(UIState.State.HOVER)

func _on_mouse_exited() -> void:
	if not disabled:
		_set_state(UIState.State.NORMAL)

func _on_button_down() -> void:
	if not disabled:
		_set_state(UIState.State.PRESSED)

func _on_button_up() -> void:
	if not disabled:
		# 松开时可能已移出按钮：按实际鼠标位置恢复 HOVER / NORMAL
		var over: bool = get_global_rect().has_point(get_global_mouse_position())
		_set_state(UIState.State.HOVER if over else UIState.State.NORMAL)

func _set_state(new_state: int) -> void:
	state.transition(new_state)

func _on_state_changed(from: int, to: int) -> void:
	state_changed.emit(from, to)
	_apply_state(to)

## 子类实现：按状态播放动画 / 切换样式。
func _apply_state(new_state: int) -> void:
	pass
