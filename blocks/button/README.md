# Button 族

## Button（Pure Block，无脚本）

普通按钮。hover / pressed / disabled 视觉 = Theme 的 normal / hover / pressed / disabled StyleBox，编辑器直接可见。

| 项 | 路径 |
|---|---|
| Scene | `blocks/button/Button.tscn` |
| Script | 无（Pure Block） |

**用法**：拖入场景，`text` 设文字。样式在 Theme 的 `Button` 类型配置。

## ScaleButton（Behavior Block）

缩放反馈按钮：Hover 放大 → Pressed 缩小 → Release 弹回。视觉样式走 Theme（Button 类型），脚本只做 Transform 缩放。

| 项 | 路径 |
|---|---|
| Scene | `blocks/button/ScaleButton.tscn` |
| Script | `blocks/button/scale_button.gd` |

| 参数 | 默认 | 说明 |
|---|---|---|
| hover_scale | (1.05, 1.05) | 悬停缩放 |
| press_scale | (0.92, 0.92) | 按下缩放 |
| duration | 0.12 | 动画时长 |
| transition / ease | TRANS_BACK / EASE_OUT | Tween 参数 |

```gdscript
var btn := preload("res://blocks/button/ScaleButton.tscn").instantiate()
btn.text = "开始"
btn.hover_scale = Vector2(1.1, 1.1)
btn.pressed.connect(_on_start)
add_child(btn)
```

## ToggleButton（Pure Block，无脚本）

开关按钮。基于原生 `toggle_mode`：选中保持按下状态 → Theme 的 pressed StyleBox 持续显示。
发原生 `toggled(button_pressed)` 信号。

| 项 | 路径 |
|---|---|
| Scene | `blocks/button/ToggleButton.tscn` |
| Script | 无（Pure Block） |

**用法**：拖入场景，`toggled` 信号监听选中变化。选中样式在 Theme 的 `Button/pressed` 配置。

---

Demo：`demos/button/ButtonDemo.tscn`
**参考来源**：RTS/ARPG 按钮通用反馈；设置面板开关通用模式。
