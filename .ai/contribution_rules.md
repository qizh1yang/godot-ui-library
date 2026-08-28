# Contribution Rules — 新增 / 修改 Block 流程

## 1. 新增 Block（完整流程）

```text
搜索 catalog → 确认不存在 → 判断类型（Pure / Behavior）→ 实现 → README → Demo → Catalog → 测试 → 验证
```

1. **搜索**：查 `catalog/index.yaml` + grep 全库，确认无重复。
2. **定族**：button/panel/card/icon/text/progress/slot/badge/tab/tooltip/popup/drawer/list/notification。
3. **判断类型**：
   - 原生节点 + Theme 能完成 → **Pure Block**（只建 .tscn）
   - 需要行为 → **Behavior Block**（.tscn + 最小脚本，脚本只做 Theme 做不了的事）
4. **命名**：查 ClassDB 避开原生类名（`.ai/naming_rules.md`）。
5. **实现**：遵守 `.ai/component_rules.md`（参数 @export / 信号 / 零依赖 / 脚本零样式值）。
6. **README**：参数表 + 用法 + 参考来源。
7. **Demo**：`demos/<族>/`（`.ai/demo_rules.md`）+ 注册 UIShowcase。
8. **Catalog**：`catalog/index.yaml` 加条目（id/name/block_type/scene/demo/script/interactions/effects/parameters/tags）。
9. **测试**：`tests/run_tests.gd` 加断言。
10. **验证**：跑验证三连（`--import` / `--quit-after` / `--script tests`），零错误。

## 2. 修改 Block

- 修改前跑测试；行为变化同步 README / Demo / Catalog。
- 不破坏既有 @export 默认值（向后兼容）。

## 3. 禁止事项

- 不在脚本里写视觉值（颜色/字体/样式）——那是 Theme 的领地。
- 不做公共动画/状态机抽象层（动画内聚到 Block）。
- 不建空目录 / 空 Block。
- 不跳过 Demo / Catalog。
- 不使用第三方插件。
- 不把业务逻辑写进 blocks（业务组合在游戏项目里做）。

## 4. 代码纪律

- 显式类型标注；`class_name` 在 `extends` 前。
- 提交前 headless 验证零 SCRIPT ERROR。
