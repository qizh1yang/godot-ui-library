extends Control
## Demo 地图：接收建筑拖放（Godot 原生 _can_drop_data / _drop_data），放置后显示 emoji。
## 纯 Demo 用：无 Grid / Manager / 存档 / 资源系统。

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.get("type", "") == "building"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var label := Label.new()
	label.text = str(data.get("icon", "🏠"))
	label.add_theme_font_size_override("font_size", 44)
	label.position = at_position - Vector2(22, 22) # 近似居中于放置点
	add_child(label)
