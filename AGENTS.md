# AGENTS.md — AI 协作规则入口

这是一个 **Godot Game UI Interaction & Component Library**（Godot 4.x / GDScript / 2D UI）。

在修改或新增 UI 之前，必须遵守：

1. 必须优先搜索已有组件（`catalog/index.yaml`）。
2. 必须检查 Catalog 后再动手。
3. 禁止重复实现已有功能（先 Search，再 Implement）。
4. Component 必须与 Gameplay 解耦（组件不读业务数据、不调业务方法）。
5. Interaction 与 Animation 必须尽量解耦（交互产生状态，动画消费状态）。
6. 新增公开 Component 必须提供 Demo（可独立运行）。
7. 新增公开 Component 必须加入 Catalog（index.yaml + 组件 README）。
8. 不要为了简单功能创建复杂抽象（先 5~10 个高质量组件验证架构，再扩展）。
9. 优先 Composition over Inheritance（Godot 单节点脚本限制见 `.ai/architecture.md`）。
10. 保持 Godot 原生结构清晰（Control / Container / Panel / Button / Tween）。

详细规则放在 `.ai/`（每个文件只负责一个主题）：

| 文件 | 主题 |
|---|---|
| `.ai/architecture.md` | 分层架构与设计决策 |
| `.ai/component_rules.md` | 组件规范（参数/信号/零依赖） |
| `.ai/interaction_rules.md` | 交互层规范 |
| `.ai/animation_rules.md` | 动画层规范（Tween 约定） |
| `.ai/naming_rules.md` | 命名规范 |
| `.ai/demo_rules.md` | Demo 规范 |
| `.ai/contribution_rules.md` | 新增/修改组件的流程 |

> 本文件是入口，不是全部细节。先读 `.ai/architecture.md` 建立全局认识，再按主题查规则。
