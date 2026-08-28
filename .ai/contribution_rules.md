# Contribution Rules — 新增 / 修改组件流程

## 1. 新增组件（完整流程）

```text
搜索 catalog → 确认不存在 → 定组件族 → 实现（脚本+场景）→ README → Demo → Catalog 条目 → 测试 → 验证
```

1. **搜索**：查 `catalog/index.yaml` + `grep` 全库，确认没有重复实现。
2. **定族**：决定归属（button / panel / card / list / popup / tooltip / tab / notification…），找不到合适族则新建（需在 README 说明）。
3. **实现**：
   - 继承合适基类（Button 族 extends UIButton；面板/卡片 extends UIComponent）
   - 复用动画执行器（`src/animation/`），**不新写动画逻辑到组件**（除非新动画族，见下）
   - 遵守 `.ai/component_rules.md`（参数/信号/零依赖）
4. **README**：组件目录下，按模板（名称/Demo/Scene/Script/参数/使用方法/参考来源）。
5. **Demo**：`demo/<族>/` 下建演示场景（`.ai/demo_rules.md`），注册进 Showcase。
6. **Catalog**：`catalog/index.yaml` 加条目（id/name/category/scene/interactions/effects/parameters/tags/demo）。
7. **测试**：`tests/run_tests.gd` 加断言（实例化 + 状态切换 + 信号）。
8. **验证**：headless 运行 `--quit-after` + 测试脚本，零错误。

## 2. 新增动画族（如 glow / shake）

- `src/animation/<族>/<族>_feedback.gd`（RefCounted，同名 class_name）
- 遵守 `.ai/animation_rules.md`（防重锁 / pivot 居中 / 参数约定）
- Catalog `effects` 分类登记

## 3. 修改组件

- 修改前读组件 README + 对应 Demo，先跑测试。
- 行为变化必须同步：README、Demo（如参数变了）、Catalog 条目。
- 不破坏既有 `@export` 默认值（向后兼容）。

## 4. 禁止事项

- 不建空目录 / 空组件占位（目录可规划，代码只实现需要的）。
- 不为了"架构完整"创建无用抽象类。
- 不把业务逻辑写进 `src/` 组件（业务组合放 `gameplay/`）。
- 不跳过 Demo / Catalog 直接提交组件。
- 不使用第三方插件（除非 `AGENTS.md` 明确允许）。

## 5. 代码纪律

- 显式类型标注，禁止 Variant 推断（warning-as-error 项目兼容）。
- `class_name` 在 `extends` 前。
- 提交前 headless 验证（`--headless --path . --quit-after 120`）零 SCRIPT ERROR。
