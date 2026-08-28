# Godot Game UI Library

Godot 4.x 游戏 UI **交互与组件库**。收集常见游戏 UI 交互模式，拆分为可复用组件，提供 Demo 与 Catalog 索引，目标是长期积累（50 → 100 → 数百个组件）并可供 AI 检索调用。

> **Reference → Interaction → Animation → Component → Gameplay UI → Demo → Catalog → Reuse**

## 快速开始

1. 用 Godot 4.7.x 打开本项目（`project.godot`）。
2. 按 **F5** 运行 → 进入 `UIShowcase`（UI 实验室），左侧分类切换，右侧加载对应 Demo。
3. 单个 Demo 可独立运行：在 `demo/` 下打开场景按 **F6**。
4. 测试：`godot --headless --path . --script res://tests/run_tests.gd`

## 组件索引（第一阶段）

| 组件 | 场景 | 交互 | 效果 | Demo |
|---|---|---|---|---|
| UIButton | `src/components/button/ui_button/UIButton.tscn` | hover / press | — | ButtonDemo |
| ScaleButton | `src/components/button/scale_button/ScaleButton.tscn` | hover / press / release | scale + bounce | ButtonDemo |
| ToggleButton | `src/components/button/toggle_button/ToggleButton.tscn` | select / deselect | scale | ButtonDemo |
| BasePanel | `src/components/panel/base_panel/BasePanel.tscn` | open / close | — | PanelDemo |
| UIPopup | `src/components/panel/ui_popup/UIPopup.tscn` | open / close | fade / scale | PanelDemo |
| BaseCard | `src/components/card/base_card/BaseCard.tscn` | hover / press / select | scale | CardDemo |

完整索引见 [`catalog/index.yaml`](catalog/index.yaml)。

## 目录结构

```text
GodotGameUILibrary/
├── AGENTS.md            # AI 协作规则入口（详细规则在 .ai/）
├── .ai/                 # 架构/组件/交互/动画/命名/Demo/贡献 规则
├── catalog/             # AI 检索索引（index.yaml + 分类说明）
├── src/
│   ├── core/            # UIState 状态机 / UIComponent 基类 / UISignalBus
│   ├── interaction/     # 交互层（行为定义）
│   ├── animation/       # 动画层（ScaleFeedback / FadeFeedback / BounceFeedback）
│   └── components/      # 可复用组件（场景 + 脚本 + README）
├── gameplay/            # 游戏业务 UI（规划中，组合基础组件）
├── demo/                # 每个组件的可运行 Demo + UIShowcase
├── reference/           # 游戏 UI 参考收录（截图/视频/分析）
├── assets/              # 美术资源（当前零素材，样式由代码生成）
└── tests/               # headless 自动化测试
```

## 核心设计原则

- **组件零依赖自包含**：不依赖 autoload、不依赖项目资源，复制场景 + 脚本即可进任何项目。
- **交互与动画解耦**：交互（鼠标/触摸 → 状态）→ 状态机（UIState）→ 动画（Feedback 类消费状态）。`hover → scale` 可换成 `hover → glow`。
- **业务隔离**：组件只发信号（`toggled` / `clicked` / `opened`），不直接操作业务系统。
- **Composition over inheritance**：Godot 单节点脚本限制下，Button 族继承原生 Button，其余组件统一继承 `UIComponent`（背景自绘 + 状态机 + 生命周期），状态机以组合方式复用（见 `.ai/architecture.md`）。

## AI 检索方式

AI 接到 UI 需求时应：

1. 读取 `AGENTS.md` → 2. 读取 `catalog/index.yaml` → 3. 按 名称/分类/interaction/effect/tags 搜索 → 4. 读取组件 README → 5. 检查场景 → 6. 复用组件，**禁止未搜索就重新实现**。
