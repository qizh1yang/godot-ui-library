# Card（Behavior Block）

可选卡片：hover / 选中 / 禁用状态。**状态视觉走 Theme 变体**（Card / CardHover / CardSelected / CardDisabled），脚本只切 `theme_type_variation` + 发信号 + 可选缩放。

| 项 | 路径 |
|---|---|
| Scene | `blocks/card/Card.tscn` |
| Script | `blocks/card/card.gd` |
| Demo | `demos/card/CardDemo.tscn` |

## 参数（Inspector）

| 参数 | 默认 | 说明 |
|---|---|---|
| selectable | true | 可点击选中 |
| default_selected | false | 初始选中 |
| disabled | false | 禁用（CardDisabled 变体） |
| hover_scale / selected_scale | (1.0, 1.0) | 缩放反馈（1.0 = 不缩放，纯变体） |
| duration | 0.12 | 缩放动画时长 |

## 信号

`clicked(card)` / `selected_changed(card, is_selected)`

## Theme 变体配置（在你的 Theme 里）

```text
Card/panel           → 默认样式
CardHover/panel      → 悬停样式
CardSelected/panel   → 选中样式（如高亮边框）
CardDisabled/panel   → 禁用样式
```

## 用法

```gdscript
var card := preload("res://blocks/card/Card.tscn").instantiate()
card.selected_changed.connect(func(c: Card, sel: bool) -> void: print(sel))
add_child(card)
```

**参考来源**：背包格子 / 单位卡 / 商店商品卡通用模式。
