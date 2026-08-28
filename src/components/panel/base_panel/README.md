# BasePanel — 面板基类（开/关生命周期）

**分类**：panel（组件族基类）

| 项 | 路径 |
|---|---|
| Demo | `res://demo/panel/PanelDemo.tscn` |
| Scene | `res://src/components/panel/base_panel/BasePanel.tscn` |
| Script | `res://src/components/panel/base_panel/base_panel.gd` |

## 功能

可开合面板：`open() / close() / toggle_open()` + `opened / closed` 信号。
可选模态（`modal=true`）：打开时显示全屏半透明遮罩（子节点 ModalDim），拦截背景输入；点击遮罩关闭（`close_on_click_outside`）。
背景自绘（`background_style` 或 Theme 的 "UIComponent" 类型样式）。

## 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| modal | bool | false | 模态（显示遮罩） |
| close_on_click_outside | bool | true | 点击遮罩关闭 |
| background_style | StyleBoxFlat | null | 背景样式（空则用 Theme） |

## 使用方法

```gdscript
var panel := preload("res://src/components/panel/base_panel/BasePanel.tscn").instantiate()
panel.modal = true
add_child(panel)
panel.open()
```

## 参考来源

内部基础组件（无外部参考）。
