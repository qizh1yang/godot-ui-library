# ToggleButton — 开关按钮

**分类**：button

| 项 | 路径 |
|---|---|
| Demo | `res://demo/button/ButtonDemo.tscn` |
| Scene | `res://src/components/button/toggle_button/ToggleButton.tscn` |
| Script | `res://src/components/button/toggle_button/toggle_button.gd` |

## 功能

开关按钮：选中 → scale 放大保持；取消 → 弹回。基于原生 `toggle_mode`，发原生 `toggled(button_pressed)` 信号。

```text
Normal   → scale 1.0
Selected → scale 1.08（保持）
Disabled → scale 1.0
```

组件只发信号，不操作业务（业务方监听 `toggled` 决定行为）。

## 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| selected_scale | Vector2 | (1.08, 1.08) | 选中态缩放 |
| animation_duration | float | 0.12 | 动画时长 |
| transition / ease | int | TRANS_BACK / EASE_OUT | Tween 参数 |

## 使用方法

```gdscript
var toggle := preload("res://src/components/button/toggle_button/ToggleButton.tscn").instantiate()
toggle.text = "音效"
toggle.toggled.connect(func(on: bool) -> void:
    settings.sound = on) # 业务方决定如何处理
add_child(toggle)
# 编程式切换：toggle.set_pressed(true)（同样触发 toggled）
```

## 参考来源

设置面板开关 / 分段选择器通用模式。
