# Naming Rules — 命名规范

## 1. Block 名（场景/类）

PascalCase：`ScaleButton.tscn` / `DrawerPanel.tscn` / `PopupPanel.tscn` / `Card.tscn`

脚本 snake_case：`scale_button.gd` / `drawer_panel.gd` / `ui_popup.gd`
目录 snake_case：`blocks/button/scale_button/` 或直接族目录（`blocks/button/`）

> 族目录内组件少时直接放族目录（`blocks/button/ScaleButton.tscn`）；组件多了再建子目录。

## 2. 族目录

`button/` `panel/` `card/` `icon/` `text/` `progress/` `slot/` `badge/` `tab/` `tooltip/` `popup/` `drawer/` `list/` `notification/`

## 3. 变量 / 函数 / 信号

- 变量 snake_case 名词（`hover_scale` / `duration`）
- 函数 snake_case 动词（`open` / `close` / `set_selected` / `_apply_visual`）
- 私有 `_` 前缀（`_tween` / `_dim` / `_animating`）
- 布尔 `is_` / `can_` / `has_` 前缀（`is_open` / `selectable`）
- 信号过去时（`clicked` / `opened` / `selected_changed`）

## 4. 禁命名

- **禁用 Godot 原生类名**（`BaseButton` / `PopupPanel` / `Panel` 等引擎已有类）——先查官方文档/ClassDB 再命名。本项目实例：`PopupPanel.tscn` 的场景名可以叫 PopupPanel（场景名不冲突），但脚本 class_name 用 `UIPopup`。
