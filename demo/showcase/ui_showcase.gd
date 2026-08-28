extends Control
## UIShowcase：整个库的 UI 实验室（项目主场景，F5 运行）。
## 左侧分类（ToggleButton 互斥组，dogfooding 组件本身），右侧 DemoContainer 动态加载 Demo。
## 新增 Demo：在 DEMO_SCENES 注册 + 侧栏加一个分类按钮。

const DEMO_SCENES: Dictionary = {
	"button": "res://demo/button/ButtonDemo.tscn",
	"panel": "res://demo/panel/PanelDemo.tscn",
	"card": "res://demo/card/CardDemo.tscn",
}

@onready var _container: Control = $Root/ContentArea/DemoContainer
@onready var _cat_buttons: Array[ToggleButton] = [
	$Root/Sidebar/Margin/VBox/BtnButton,
	$Root/Sidebar/Margin/VBox/BtnPanel,
	$Root/Sidebar/Margin/VBox/BtnCard,
]

var _current_demo: Node = null

func _ready() -> void:
	theme = DemoTheme.build()
	for i in _cat_buttons.size():
		var btn: ToggleButton = _cat_buttons[i]
		var demo_id: String = DEMO_SCENES.keys()[i]
		btn.toggled.connect(_on_cat_toggled.bind(btn, demo_id))
	# 默认加载第一个分类
	_cat_buttons[0].set_pressed(true)
	_load_demo("button")

func _on_cat_toggled(selected: bool, btn: ToggleButton, demo_id: String) -> void:
	if not selected:
		return
	# 互斥：取消其他分类按钮的选中态
	for other: ToggleButton in _cat_buttons:
		if other != btn and other.button_pressed:
			other.set_pressed(false)
	_load_demo(demo_id)
	UISignalBus.demo_selected.emit(demo_id)

func _load_demo(demo_id: String) -> void:
	if _current_demo != null:
		_current_demo.queue_free()
		_current_demo = null
	var scene: PackedScene = load(DEMO_SCENES[demo_id]) as PackedScene
	if scene == null:
		push_error("UIShowcase: demo scene not found for '%s'" % demo_id)
		return
	_current_demo = scene.instantiate()
	_container.add_child(_current_demo)
