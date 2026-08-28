# Assets

当前**零美术资源**：视觉全部由 Theme 提供（Demo 用 `demos/theme/demo_theme.gd` 代码生成，用户项目用自己的 Theme）。

子目录规划：

```text
assets/
├── common/      # 通用素材（九宫格面板、按钮底图等）
├── icons/       # 图标
├── textures/    # 贴图
├── fonts/       # 字体
└── sounds/      # 音效
```

> 原则：Block 不依赖 assets（零依赖自包含，视觉走 Theme）。assets 只用于 Demo 美化 / 游戏项目共享素材。
> 每个 Block 可自带 `blocks/<族>/<Block>/assets/` 放专属素材。
