# BaseCard — 卡片基类（多状态）

**分类**：card

| 项 | 路径 |
|---|---|
| Demo | `res://demo/card/CardDemo.tscn` |
| Scene | `res://src/components/card/base_card/BaseCard.tscn` |
| Script | `res://src/components/card/base_card/base_card.gd` |

## 功能

卡片：Normal / Hover / Pressed / Selected / Disabled 状态管理，不绑定任何游戏数据。
交互：悬停 → 提亮 + 微放大；点击 → 按下缩小；松开 → `clicked` 信号 + 选中切换（selectable）。

```text
Normal   → scale 1.0，亮度 1.0
Hover    → scale 1.02，亮度 1.08
Pressed  → scale 0.98
Selected → scale 1.05，亮度 1.15（保持）
Disabled → scale 1.0，亮度 0.6（拦截交互）
```

## 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| selectable | bool | true | 可点击选中 |
| default_selected | bool | false | 初始选中 |
| disabled | bool | false | 禁用 |
| hover_scale / press_scale / selected_scale | Vector2 | 1.02 / 0.98 / 1.05 | 各状态缩放 |
| hover_brightness / selected_brightness | float | 1.08 / 1.15 | 亮度反馈 |
| animation_duration | float | 0.12 | 动画时长 |

## 信号

| 信号 | 参数 | 说明 |
|---|---|---|
| clicked | card | 点击（松开） |
| selected_changed | card, is_selected | 选中状态变化 |
| state_changed | from, to | 状态机变化 |

## 使用方法

```gdscript
var card := preload("res://src/components/card/base_card/BaseCard.tscn").instantiate()
card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
card.selected_changed.connect(func(c: BaseCard, sel: bool) -> void:
    print("selected:", sel))
add_child(card)
# 内容由使用方添加（Label / Icon / 子类化）
```

## 参考来源

背包格子 / 单位卡 / 商店商品卡通用模式（悬停反馈 + 选中高亮）。
