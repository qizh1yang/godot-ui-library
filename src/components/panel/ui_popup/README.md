# UIPopup — 弹窗面板（开合动画）

**分类**：panel

| 项 | 路径 |
|---|---|
| Demo | `res://demo/panel/PanelDemo.tscn` |
| Scene | `res://src/components/panel/ui_popup/UIPopup.tscn` |
| Script | `res://src/components/panel/ui_popup/ui_popup.gd` |

## 功能

弹窗面板：打开/关闭动画（Fade 淡入淡出 / Scale 放大弹入缩小退出），支持模态遮罩。
`Content` 子节点为内容容器（MarginContainer），内容由使用方填充。

```text
Open  → Fade in（alpha 0→1）或 Scale 0.85→1.0（TRANS_BACK 弹入）
Close → Fade out（完自动隐藏）或 Scale 缩小退出（完自动隐藏）
```

## 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| animation_mode | AnimationMode | FADE | NONE / FADE / SCALE |
| animation_duration | float | 0.2 | 动画时长 |
| scale_from | Vector2 | (0.85, 0.85) | SCALE 模式入场起始缩放 |
| transition / ease | int | TRANS_BACK / EASE_OUT | Tween 参数 |
| modal | bool | false | 模态（遮罩） |
| close_on_click_outside | bool | true | 点击遮罩关闭 |

## 使用方法

```gdscript
var popup := preload("res://src/components/panel/ui_popup/UIPopup.tscn").instantiate()
popup.animation_mode = UIPopup.AnimationMode.SCALE
popup.modal = true
add_child(popup)
# 填充内容（Content 是组件场景自带容器）
var content: Node = popup.get_node("Content")
content.add_child(my_label)
# 打开 / 关闭
open_btn.pressed.connect(popup.open)
close_btn.pressed.connect(popup.close)
```

## 参考来源

游戏通用弹窗模式（商店 / 设置 / 确认框）：淡入或缩放弹入 + 遮罩 + 点外关闭。
