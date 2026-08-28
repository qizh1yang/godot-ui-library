# Slide Out Panel Pattern

## 用途

从屏幕边缘滑入/滑出的可折叠 UI（侧边栏 / 建筑菜单 / 背包 / 单位列表 / 设置 / 商店）。

## 核心实现

`Control` + Anchor/Offset + Tween。

```text
根 Control（贴边锚点）
├── Panel（PanelContainer，全宽全高，含 Content）
└── ToggleButton（锚定收起后仍可见的角落）
```

- **根节点负责整体移动**：Tween 根的 offset（主轴）→ Panel 与 ToggleButton 作为同一整体滑入/滑出（子节点自动跟随）。
- **展开/收起位置**由锚点 + offset 表达（RIGHT：展开 `-面板宽`，收起 `-collapsed_visible_size`）——**位置相对锚点而非固定屏幕坐标，Viewport Resize 自动跟随，无需 `_resized` 重算**。
- **收起保留区** `collapsed_visible_size`：面板滑出后仍留一段区域在屏幕内，ToggleButton 锚定其中 → 始终可点击重新展开。

## 设计原则

- **Panel 与 ToggleButton 属于同一个移动整体**（都是根的子节点，不是各自移动）。
- **Theme 负责视觉**（按钮四态 / 面板背景 / 边框圆角）；**Script 只负责位置计算与动画**。
- **Content 完全可替换**：组件只提供 Content 容器，内容（建筑列表 / 背包格子 / 设置项）由使用方填充。
- 脚本不做业务（无 BuildingManager / InventoryManager）；拖拽数据只带 `type + id`。

## 关键参数

| 参数 | 说明 |
|---|---|
| direction | LEFT / RIGHT / TOP / BOTTOM |
| duration / transition / ease | Tween 参数（默认 0.25s / TRANS_CUBIC / EASE_OUT） |
| collapsed_visible_size | 收起后保留在屏幕内的尺寸（默认 48px） |
| start_open | 初始是否展开 |

## API

```gdscript
panel.open() / panel.close() / panel.toggle()
panel.is_open
signals: opened / closed
```

## 适合

- Building Menu（见 `demos/SlideOutBuildingDemo.tscn`）
- Inventory / Unit List / Skill List
- Settings / Shop / Tech Tree

## 参考实现

`blocks/drawer/SlideOutPanel.tscn` + `slide_out_panel.gd`
