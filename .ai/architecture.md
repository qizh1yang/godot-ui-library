# Architecture — UI 积木库架构

## 核心原则（一句话）

> **能用 Godot 原生解决的，不写代码；能用 Theme 解决的，不用脚本；只有行为无法通过原生节点和 Theme 表达时，才增加最小脚本。**

## 分层

```text
Theme          长什么样（颜色 / 边框 / 圆角 / 字体——编辑器里直接可见可调）
    ↓
Script         怎么动（Theme 做不了的行为：位置 Tween、状态切换、信号）
    ↓
Block          一个可拖用的积木（Scene 为主，脚本是可选附件）
    ↓
组合           积木自由嵌套（Drawer 里放 Panel、Grid、Slot、Icon、Badge）
    ↓
Catalog        机器可读索引（AI 检索入口）
```

边界非常干净：**Theme 管视觉，Script 管行为**。脚本里不出现任何颜色/字体/样式值。

## Block 两种类型

| 类型 | 定义 | 例子 |
|---|---|---|
| **Pure Block** | 无脚本。Godot 原生节点 + Theme + Scene | Button、ToggleButton、Panel、Label、ProgressBar、Badge |
| **Behavior Block** | 原生节点 + 一个最小脚本（只在原生能力不够时） | ScaleButton（缩放 Transform）、DrawerPanel（位置 Tween）、PopupPanel（开合动画）、Card（状态切换） |

判断方法：问自己"Godot 原生节点 / Theme 能不能完成？"
- 能 → 不写脚本（如 Button 的 hover/pressed 视觉 = Theme 四套 StyleBox）
- 不能 → 写最小脚本，且脚本只做那件 Theme 做不了的事（如 scale 缩放 = Transform，Theme 管不了）

## 目录结构

```text
blocks/<族>/<Block>/
├── <Block>.tscn      # 积木场景（拖入项目即可用）
├── <block>.gd        # 可选：最小行为脚本（Pure Block 没有）
└── assets/           # 可选：该积木专属美术（零素材时走 Theme）
```

动画不抽公共层：**每个 Behavior Block 内部自己 Tween**（ScaleButton 管自己的缩放，Drawer 管自己的滑动）——不做 Animation/Effect 抽象层。

## 数据流

```text
输入（鼠标/触摸）
    → Block 脚本（connect 原生信号）
    → 行为（Tween / theme_type_variation 切换 / 信号 emit）
    → 视觉（Theme 定义的样式）+ 对外信号（业务方监听）
```
