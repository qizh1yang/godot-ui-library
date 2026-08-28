# Catalog — Gameplay 分类

当前为空（规划中）。

Gameplay UI 是**组合层**：基于基础组件（button/panel/card/list/popup/…）构建业务 UI，不重新实现基础功能。

规划目录（`gameplay/`）：`inventory` / `equipment` / `character` / `shop` / `reward` / `quest` / `battle` / `upgrade`

例如 `inventory` 应为：

```text
InventoryPanel → InventoryGrid → InventorySlot → ItemCard → Drag/Drop → Scale/Bounce
```

（组合复用，不重写基础组件）
