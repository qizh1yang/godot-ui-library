extends SceneTree
## headless 自动化测试：实例化 blocks → 模拟行为 → 断言。
## 运行：godot --headless --path . --script res://tests/run_tests.gd
##
## 原则：组件零依赖（无 autoload / 无项目资源依赖），测试直接实例化场景验证行为。

var _passed: int = 0
var _failed: int = 0

const SCENES: Dictionary = {
	"button": "res://blocks/button/Button.tscn",
	"scale_button": "res://blocks/button/ScaleButton.tscn",
	"toggle_button": "res://blocks/button/ToggleButton.tscn",
	"panel": "res://blocks/panel/Panel.tscn",
	"popup_panel": "res://blocks/popup/PopupPanel.tscn",
	"card": "res://blocks/card/Card.tscn",
	"drawer_panel": "res://blocks/drawer/DrawerPanel.tscn",
}

func _initialize() -> void:
	call_deferred("_run_all")

func _run_all() -> void:
	await _test_scenes_loadable()
	await _test_scale_button()
	await _test_toggle_button()
	await _test_popup_panel()
	await _test_card()
	await _test_drawer()
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

func _test_scale_button() -> void:
	print("-- ScaleButton --")
	var btn: ScaleButton = instantiate(SCENES["scale_button"]) as ScaleButton
	check(btn.scale.is_equal_approx(Vector2.ONE), "initial scale 1.0")
	btn.duration = 0.05 # 缩短动画便于测试等待
	btn._on_mouse_entered()
	if btn._tween != null and btn._tween.is_valid():
		await btn._tween.finished # 等 tween 完成（headless 下 create_timer 计时不可靠，用信号）
	check(btn.scale.is_equal_approx(btn.hover_scale), "hover -> hover_scale")
	btn._on_button_down()
	if btn._tween != null and btn._tween.is_valid():
		await btn._tween.finished
	check(btn.scale.is_equal_approx(btn.press_scale), "press -> press_scale")
	btn._on_button_up()
	if btn._tween != null and btn._tween.is_valid():
		await btn._tween.finished
	check(btn.scale.is_equal_approx(Vector2.ONE), "release -> back to 1.0")
	# disabled 轮询复位
	btn.set_disabled(true)
	await process_frame
	await process_frame
	check(btn.scale.is_equal_approx(Vector2.ONE), "disabled keeps scale 1.0")
	btn.queue_free()

func _test_toggle_button() -> void:
	print("-- ToggleButton --")
	var btn: Button = instantiate(SCENES["toggle_button"]) as Button
	check(btn.toggle_mode, "toggle_mode on")
	var toggled_events: Array[bool] = []
	btn.toggled.connect(func(on: bool) -> void: toggled_events.append(on))
	btn.set_pressed(true)
	check(btn.button_pressed, "set_pressed true")
	check(toggled_events == [true], "toggled signal [true]")
	btn.set_pressed(false)
	check(btn.button_pressed == false, "set_pressed false")
	check(toggled_events == [true, false], "toggled signal [true, false]")
	btn.queue_free()

func _test_popup_panel() -> void:
	print("-- PopupPanel --")
	var popup: UIPopup = instantiate(SCENES["popup_panel"]) as UIPopup
	check(not popup.is_open, "initial closed")
	check(not popup.visible, "initial hidden")
	var opened_events: Array[int] = []
	var closed_events: Array[int] = []
	# lambda 对 int 局部变量是值捕获，计数必须用 Array（引用类型）
	popup.opened.connect(func() -> void: opened_events.append(1))
	popup.closed.connect(func() -> void: closed_events.append(1))
	popup.open()
	check(popup.is_open, "open -> is_open")
	check(popup.visible, "open -> visible")
	check(opened_events.size() == 1, "opened signal once")
	popup.open()
	check(opened_events.size() == 1, "re-open blocked")
	popup.close()
	check(not popup.is_open, "close -> not is_open")
	check(closed_events.size() == 1, "closed signal once")
	popup.animation_mode = UIPopup.AnimationMode.SCALE
	check(popup.animation_mode == UIPopup.AnimationMode.SCALE, "animation_mode SCALE settable")
	popup.queue_free()

func _test_card() -> void:
	print("-- Card --")
	var card: Card = instantiate(SCENES["card"]) as Card
	check(card.theme_type_variation == &"Card", "initial variation Card")
	var selected_events: Array[bool] = []
	card.selected_changed.connect(func(c: Card, s: bool) -> void: selected_events.append(s))
	card.set_selected(true)
	check(card.is_selected, "set_selected true")
	check(card.theme_type_variation == &"CardSelected", "variation -> CardSelected")
	check(selected_events == [true], "selected_changed [true]")
	card.set_selected(false)
	check(card.theme_type_variation == &"Card", "variation -> Card")
	# disabled 变体
	var disabled_card: Card = instantiate(SCENES["card"]) as Card
	disabled_card.set_disabled(true)
	check(disabled_card.theme_type_variation == &"CardDisabled", "disabled variation CardDisabled")
	disabled_card.queue_free()
	card.queue_free()

func _test_drawer() -> void:
	print("-- DrawerPanel --")
	var drawer: DrawerPanel = instantiate(SCENES["drawer_panel"]) as DrawerPanel
	check(not drawer.is_open, "initial closed")
	check(not drawer.visible, "initial hidden")
	var opened_events: Array[int] = []
	var closed_events: Array[int] = []
	drawer.opened.connect(func() -> void: opened_events.append(1))
	drawer.closed.connect(func() -> void: closed_events.append(1))
	drawer.duration = 0.05 # 缩短动画便于测试等待
	drawer.open()
	check(drawer.is_open, "open -> is_open")
	check(drawer.visible, "open -> visible")
	await drawer.opened # 等滑动动画完成（opened 在动画回调里发出）
	check(opened_events.size() == 1, "opened signal after animation")
	check(drawer.offset_left == drawer._rest_offset.x, "offset reached rest position")
	drawer.close()
	check(not drawer.is_open, "close -> not is_open")
	await drawer.closed # 等退场动画完成
	check(closed_events.size() == 1, "closed signal after animation")
	check(not drawer.visible, "hidden after close animation")
	drawer.queue_free()

func _test_card_disabled_helper() -> void:
	pass
