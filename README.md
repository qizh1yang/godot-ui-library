# Godot Game UI Library

Godot 4.x **UI 积木库**：收录常见游戏 UI 交互模式，每个积木 = 原生节点 + Theme +（必要时）最小脚本。拖进项目即可用，可自由组合，可喂给 AI 检索调用。

> **能用 Godot 原生解决的，不写代码；能用 Theme 解决的，不用脚本；只有行为无法通过原生节点和 Theme 表达时，才增加最小脚本。**

## 快速开始

1. 用 Godot 4.7.x 打开本项目 → **F5** 运行 `UIShowcase`（UI 积木实验室，左侧分类切换 Demo）。
2. 单个 Demo：`demos/` 下打开场景按 **F6**。
3. 用积木：把 `blocks/<族>/<Block>.tscn` 拖进你的项目 → Inspector 配参数 → 内容塞进 Content 容器。
4. 视觉：在你的项目 Theme 里配对应类型/变体样式（积木脚本零样式）。
5. 测试：`godot --headless --path . --script res://tests/run_tests.gd`

## 核心概念：Pure Block vs Behavior Block

| 类型 | 定义 | 例子 |
|---|---|---|
| **Pure Block** | 无脚本（原生节点 + Theme） | Button、ToggleButton、Panel |
| **Behavior Block** | 原生节点 + 一个最小脚本（只做 Theme 做不了的行为） | ScaleButton（缩放）、DrawerPanel（滑动）、PopupPanel（开合）、Card（状态切换） |

**边界**：Theme 管"长什么样"，脚本管"怎么动"。脚本里永远不出现颜色/字体/样式值。

## Block 索引

| Block | 类型 | 场景 | 行为 |
|---|---|---|---|
| Button | Pure | `blocks/button/Button.tscn` | 原生按钮（hover/pressed/disabled 样式走 Theme） |
| ScaleButton | Behavior | `blocks/button/ScaleButton.tscn` | Hover 放大 / Press 缩小 / Release 弹回 |
| ToggleButton | Pure | `blocks/button/ToggleButton.tscn` | 原生 toggle_mode（选中样式 = Theme pressed） |
| Panel | Pure | `blocks/panel/Panel.tscn` | 原生 PanelContainer 容器 |
| PopupPanel | Behavior | `blocks/popup/PopupPanel.tscn` | 开合动画（Fade / Scale）+ 模态遮罩 |
| Card | Behavior | `blocks/card/Card.tscn` | hover/选中/禁用状态（Theme 变体切换） |
| DrawerPanel | Behavior | `blocks/drawer/DrawerPanel.tscn` | 边缘滑入滑出（锚点 + offset Tween） |
| SlideOutPanel | Behavior | `blocks/drawer/SlideOutPanel.tscn` | 可折叠侧边面板：ToggleButton 随整体移动，收起保留手柄可见（建筑菜单 Demo：`demos/SlideOutBuildingDemo.tscn`） |

完整索引见 [`catalog/index.yaml`](catalog/index.yaml)。

## 目录结构

```text
GodotGameUILibrary/
├── AGENTS.md            # AI 协作规则入口
├── .ai/                 # 规则文档（architecture / component / interaction / animation / naming / demo / contribution）
├── blocks/              # UI 积木（Scene + 可选最小脚本）
│   ├── button/  panel/  card/  popup/  drawer/ ...
├── demos/               # 每个 Block 的 Demo + UIShowcase（主场景）
├── catalog/             # AI 检索索引（index.yaml）
├── assets/              # 共享美术资源（零素材时全走 Theme）
├── reference/           # 游戏 UI 参考收录
└── tests/               # headless 自动化测试
```

## 用积木组合（示例：右侧滑出的背包）

```text
DrawerPanel（direction = RIGHT）
└── Content
    ├── Panel（标题栏）
    ├── GridContainer（物品格）
    │   ├── Card × N（每个格一张卡，selectable）
    │   └── ...
    └── Button（关闭）
```

```gdscript
var drawer := preload("res://blocks/drawer/DrawerPanel.tscn").instantiate()
drawer.direction = DrawerPanel.Direction.RIGHT
drawer.duration = 0.3
add_child(drawer)
open_btn.pressed.connect(drawer.open)
```

## AI 工作方式

AI 接到 UI 需求时：

1. 读取 `AGENTS.md` → 2. 查看 `catalog/index.yaml` → 3. 按 类型/分类/交互/tags 搜索 → 4. 打开 Scene 看 Inspector 参数 → 5. 拖入组合 → 6. 禁止未搜索就重新实现。
