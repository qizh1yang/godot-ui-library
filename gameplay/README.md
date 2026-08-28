# Gameplay UI（规划目录）

Gameplay UI 是建立在基础 Component 之上的**组合层**，例如 `inventory/` 可包含 `InventoryPanel / InventoryGrid / InventorySlot / ItemTooltip`——但 Inventory 不得重新实现 Button / Card / Drag / Drop 等基础功能，应组合：

```text
Inventory → InventorySlot → ItemCard → Drag/Drop → Scale/Bounce
```

规划子目录：`inventory/` `equipment/` `character/` `shop/` `reward/` `quest/` `battle/` `upgrade/`

> 第一阶段不实现。完成基础组件（≥10 个）并验证架构后，再从此目录开始构建业务组合。
