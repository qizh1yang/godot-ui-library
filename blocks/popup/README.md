# PopupPanel（Behavior Block）

弹窗：开合动画（Fade 淡入淡出 / Scale 放大弹入）+ 模态遮罩（点击遮罩关闭）。
视觉走 Theme（类型名 UIPopup），脚本只做开合行为。

| 项 | 路径 |
|---|---|
| Scene | `blocks/popup/PopupPanel.tscn` |
| Script | `blocks/popup/ui_popup.gd` |
| Demo | `demos/panel/PanelDemo.tscn` |

## 参数（Inspector）

| 参数 | 默认 | 说明 |
|---|---|---|
| animation_mode | FADE | NONE / FADE / SCALE |
| duration | 0.2 | 动画时长 |
| transition / ease | TRANS_BACK / EASE_OUT | Tween 参数 |
| scale_from | (0.85, 0.85) | SCALE 模式入场起始缩放 |
| modal | false | 模态（遮罩） |
| close_on_click_outside | true | 点击遮罩关闭 |

## 信号

`opened` / `closed`

## 用法

```gdscript
var popup := preload("res://blocks/popup/PopupPanel.tscn").instantiate()
popup.animation_mode = UIPopup.AnimationMode.SCALE
popup.modal = true
add_child(popup)
popup.get_node("Content").add_child(my_label) # 内容由使用方填充
open_btn.pressed.connect(popup.open)
close_btn.pressed.connect(popup.close)
```

**参考来源**：游戏通用弹窗模式（商店/设置/确认框）：淡入或缩放弹入 + 遮罩 + 点外关闭。
