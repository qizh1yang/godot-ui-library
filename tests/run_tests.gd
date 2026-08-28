extends SceneTree
## headless 自动化测试：实例化组件 → 模拟状态/信号 → 断言。
## 运行：godot --headless --path . --script res://tests/run_tests.gd
##
## 注意：--script 模式 autoload 不可用，测试不依赖 UISignalBus——同时验证组件零依赖原则。

var _passed: int = 0
var _failed: int = 0

const SCENES: Dictionary = {
	"ui_button": "res://src/components/button/ui_button/UIButton.tscn",
	"scale_button": "res://src/components/button/scale_button/ScaleButton.tscn",
	"toggle_button": "res://src/components/button/toggle_button/ToggleButton.tscn",
	"base_panel": "res://src/components/panel/base_panel/BasePanel.tscn",
	"ui_popup": "res://src/components/panel/ui_popup/UIPopup.tscn",
	"base_card": "res://src/components/card/base_card/BaseCard.tscn",
}

func _initialize() -> void:
	call_deferred("_run_all")

func _run_all() -> void:
	await _test_scenes_loadable()
	await _test_ui_state()
	await _test_scale_button()
	await _test_toggle_button()
	await _test_ui_popup()
	await _test_base_card()
	print("========================================")
	print("RESULT: %d passed, %d failed" % [_passed, _failed])
	quit(0 if _failed == 0 else 1)

# ---------- 工具 ----------

func check(cond: bool, msg: String) -> void:
	if cond:
		_passed += 1
		print("[PASS] ", msg)
	else:
		_failed += 1
		printerr("[FAIL] ", msg)

func instantiate(path: String) -> Node:
	var scene: PackedScene = load(path) as PackedScene
	var node: Node = scene.instantiate()
	root.add_child(node)
	return node

# ---------- 测试 ----------

func _test_scenes_loadable() -> void:
	print("-- scenes loadable --")
	for id: String in SCENES:
		var node: Node = instantiate(SCENES[id])
		check(node != null, "instantiate %s" % id)
		node.queue_free()

func _test_ui_state() -> void:
	print("-- UIState --")
	var st := UIState.new()
	check(st.current == UIState.State.NORMAL, "initial state NORMAL")
	check(st.transition(UIState.State.HOVER), "NORMAL -> HOVER")
	check(not st.transition(UIState.State.HOVER), "same-state transition blocked (no re-emit)")
	var seen: Array[int] = []
	st.changed.connect(func(from: int, to: int) -> void: seen.append(to))
	st.transition(UIState.State.PRESSED)
	check(seen == [UIState.State.PRESSED], "changed signal emitted once")
	check(UIState.name_of(UIState.State.SELECTED) == "SELECTED", "name_of SELECTED")

func _test_scale_button() -> void:
	print("-- ScaleButton --")
	var btn: ScaleButton = instantiate(SCENES["scale_button"]) as ScaleButton
	check(btn.state.current == UIState.State.NORMAL, "ScaleButton initial NORMAL")
	btn._set_state(UIState.State.HOVER)
	check(btn.state.current == UIState.State.HOVER, "set_state HOVER")
	btn._set_state(UIState.State.PRESSED)
	check(btn.state.current == UIState.State.PRESSED, "set_state PRESSED")
	var state_seen: Array[int] = []
	btn.state_changed.connect(func(from: int, to: int) -> void: state_seen.append(to))
	btn.set_disabled(true)
	await process_frame # 禁用状态经 _process 轮询同步（deferred 当帧 _process 尚未开始，需跨 2 帧）
	await process_frame
	check(btn.state.current == UIState.State.DISABLED, "set_disabled -> DISABLED")
	check(btn.disabled, "button disabled property")
	btn.set_disabled(false)
	await process_frame
	await process_frame
	check(btn.state.current == UIState.State.NORMAL, "re-enable -> NORMAL")
	btn._set_state(UIState.State.HOVER)
	btn.queue_free()

func _test_toggle_button() -> void:
	print("-- ToggleButton --")
	var btn: ToggleButton = instantiate(SCENES["toggle_button"]) as ToggleButton
	check(btn.toggle_mode, "toggle_mode on")
	var toggled_seen: Array[bool] = []
	btn.toggled.connect(func(on: bool) -> void: toggled_seen.append(on))
	btn.set_pressed(true)
	check(btn.button_pressed, "set_pressed true")
	check(btn.state.current == UIState.State.SELECTED, "toggled -> SELECTED state")
	check(toggled_seen == [true], "toggled signal [true]")
	btn.set_pressed(false)
	check(btn.state.current == UIState.State.NORMAL, "untoggled -> NORMAL state")
	btn.queue_free()

func _test_ui_popup() -> void:
	print("-- UIPopup --")
	var popup: UIPopup = instantiate(SCENES["ui_popup"]) as UIPopup
	check(not popup.is_open, "initial closed")
	check(not popup.visible, "initial hidden")
	var opened_events: Array[int] = []
	var closed_events: Array[int] = []
	# 注意：lambda 对 int 局部变量是值捕获，计数必须用 Array（引用类型）
	popup.opened.connect(func() -> void: opened_events.append(1))
	popup.closed.connect(func() -> void: closed_events.append(1))
	popup.open()
	check(popup.is_open, "open -> is_open")
	check(popup.visible, "open -> visible")
	check(opened_events.size() == 1, "opened signal once")
	popup.open()
	check(opened_events.size() == 1, "re-open blocked (no double emit)")
	popup.close()
	check(not popup.is_open, "close -> not is_open")
	check(closed_events.size() == 1, "closed signal once")
	# 动画模式参数存在
	popup.animation_mode = UIPopup.AnimationMode.SCALE
	check(popup.animation_mode == UIPopup.AnimationMode.SCALE, "animation_mode SCALE settable")
	popup.queue_free()

func _test_base_card() -> void:
	print("-- BaseCard --")
	var card: BaseCard = instantiate(SCENES["base_card"]) as BaseCard
	check(card.state.current == UIState.State.NORMAL, "initial NORMAL")
	var clicked_events: Array[int] = []
	var selected_seen: Array[bool] = []
	card.clicked.connect(func(c: BaseCard) -> void: clicked_events.append(1))
	card.selected_changed.connect(func(c: BaseCard, s: bool) -> void: selected_seen.append(s))
	card.set_selected(true)
	check(card.is_selected, "set_selected true")
	check(card.state.current == UIState.State.SELECTED, "selected -> SELECTED state")
	check(selected_seen == [true], "selected_changed [true]")
	card.set_selected(false)
	check(selected_seen == [true, false], "selected_changed [true, false]")
	card.set_disabled(true)
	check(card.state.current == UIState.State.DISABLED, "disabled -> DISABLED")
	card.queue_free()
