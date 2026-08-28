# Assets

当前**零美术资源**：组件与 Demo 样式全部由代码生成（`demo/theme/demo_theme.gd` 的 StyleBoxFlat / Theme），保持组件默认主题可用。

子目录规划：

```text
assets/
├── icons/       # 图标
├── textures/    # 贴图 / 九宫格
├── fonts/       # 字体
├── sounds/      # 音效
└── particles/   # 粒子素材
```

> 原则：组件不依赖 assets（零依赖自包含）。assets 只用于 Demo 美化 / Gameplay UI / 参考复刻。
