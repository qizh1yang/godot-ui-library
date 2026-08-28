# ScaleButton — 缩放反馈按钮

**分类**：button

| 项 | 路径 |
|---|---|
| Demo | `res://demo/button/ButtonDemo.tscn` |
| Scene | `res://src/components/button/scale_button/ScaleButton.tscn` |
| Script | `res://src/components/button/scale_button/scale_button.gd` |

## 功能

点击缩放反馈按钮：Hover 放大 → Press 缩小 → Release 弹回。

```text
Normal   → scale 1.0
Hover    → scale 1.05（可配）
Pressed  → scale 0.92（可配）
Release  → 弹回 1.0（TRANS_BACK 轻微过冲）
Disabled → scale 1.0
```

## 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| hover_scale | Vector2 | (1.05, 1.05) | 悬停缩放 |
| press_scale | Vector2 | (0.92, 0.92) | 按下缩放 |
| animation_duration | float | 0.12 | 动画时长（秒） |
| transition | int | TRANS_BACK | Tween 过渡类型 |
| ease | int | EASE_OUT | Tween 缓动 |

## 使用方法

```gdscript
var btn := preload("res://src/components/button/scale_button/ScaleButton.tscn").instantiate()
btn.text = "开始"
btn.hover_scale = Vector2(1.1, 1.1)
btn.pressed.connect(_on_start)
add_child(btn)
```

## 参考来源

RTS / ARPG 按钮通用反馈（悬停放大、按下缩小、松开回弹）。
