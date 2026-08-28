extends Control
## Button 积木 Demo：普通 Button / ScaleButton / ToggleButton / Disabled 展示。
## 参数在 Inspector 里调（@export），Demo 不做运行时调参面板。

func _ready() -> void:
	theme = DemoTheme.build()
	for child: Node in $Root/Row2.get_children():
		if child is Button:
			child.toggled.connect(_on_toggled.bind(child.text))

func _on_toggled(selected: bool, btn_name: String) -> void:
	$Root/ToggleLog.text = "toggle: %s → %s" % [btn_name, "ON" if selected else "OFF"]
