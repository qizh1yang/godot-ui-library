# DrawerPanel（Behavior Block）

抽屉：从屏幕边缘滑入/滑出（侧边栏 / 背包式）。**锚点贴边 + offset Tween**。
视觉走 Theme（类型名 DrawerPanel），脚本只负责"屏幕外 → 屏幕内"的位置 Tween。

| 项 | 路径 |
|---|---|
| Scene | `blocks/drawer/DrawerPanel.tscn` |
| Script | `blocks/drawer/drawer_panel.gd` |
| Demo | `demos/drawer/DrawerDemo.tscn` |

## 参数（Inspector）

| 参数 | 默认 | 说明 |
|---|---|---|
| direction | RIGHT | LEFT / RIGHT / TOP / BOTTOM |
| duration | 0.25 | 滑动时长 |
| transition / ease | TRANS_CUBIC / EASE_OUT | Tween 参数 |
| modal | true | 模态遮罩 |
| close_on_click_outside | true | 点击遮罩关闭 |

> LEFT/RIGHT 自动全高（宽度 = 场景预设宽度）；TOP/BOTTOM 自动全宽（高度 = 场景预设高度，请设 `custom_minimum_size`）。

## 信号

`opened` / `closed`

## 用法

```gdscript
var drawer := preload("res://blocks/drawer/DrawerPanel.tscn").instantiate()
drawer.direction = DrawerPanel.Direction.RIGHT
drawer.duration = 0.3
add_child(drawer)
drawer.get_node("Content").add_child(backpack_grid) # 内容由使用方填充
open_btn.pressed.connect(drawer.open)
close_btn.pressed.connect(drawer.close)
```

**参考来源**：侧边栏 / 背包 / 商店抽屉式 UI 通用模式。
