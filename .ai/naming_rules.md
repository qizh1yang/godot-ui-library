# Naming Rules — 命名规范

## 1. 场景 / 类

PascalCase，与组件名一致：

```text
ScaleButton.tscn     class_name ScaleButton
ToggleButton.tscn    class_name ToggleButton
UIPopup.tscn      class_name UIPopup
ItemCard.tscn        class_name ItemCard
InventorySlot.tscn   class_name InventorySlot
```

## 2. 脚本

snake_case，与类名对应：

```text
scale_button.gd
toggle_button.gd
ui_popup.gd
item_card.gd
```

## 3. 目录

snake_case，单数，与组件族对应：

```text
src/components/button/scale_button/
src/components/panel/ui_popup/
src/components/card/item_card/
```

组件族目录：`button/` `panel/` `card/` `list/` `popup/` `tooltip/` `tab/` `notification/`
交互目录：`hover/` `press/` `select/` `drag/` `drop/` `swipe/` `focus/`
动画目录：`scale/` `fade/` `slide/` `bounce/` `shake/` `flash/`

## 4. 变量 / 函数

- 变量：snake_case，名词（`hover_scale` / `animation_duration`）
- 函数：snake_case，动词开头（`set_selected` / `_apply_state` / `animate_to`）
- 私有：下划线前缀（`_feedback` / `_tween`）
- 布尔：`is_` / `can_` / `has_` 前缀（`is_open` / `selectable`）
- 常量：UPPER_SNAKE_CASE（`TWEEN_TRANSITION`）

## 5. 信号

过去时 / 完成时：`toggled` / `clicked` / `selected_changed` / `opened` / `closed` / `drag_started`

## 6. 枚举

PascalCase 类型，UPPER_SNAKE_CASE 值：

```gdscript
enum AnimationMode { NONE, FADE, SCALE }
```

## 7. 文件组织（组件目录标准结构）

```text
src/components/button/scale_button/
├── ScaleButton.tscn     # 组件场景
├── scale_button.gd      # 组件脚本
└── README.md            # 组件文档（含 Catalog 描述）
```

Demo 放 `demo/`，不在组件目录内：

```text
demo/button/ButtonDemo.tscn
```
