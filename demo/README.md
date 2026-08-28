# Demo 说明

每个公开组件都有可独立运行的 Demo（F6 打开场景直接跑），并被 `UIShowcase` 统一收纳。

| Demo | 场景 | 展示内容 |
|---|---|---|
| ButtonDemo | `demo/button/ButtonDemo.tscn` | UIButton / ScaleButton / ToggleButton + 参数实时调节（hover_scale / duration） |
| PanelDemo | `demo/panel/PanelDemo.tscn` | UIPopup 的 Fade / Scale 开合动画 + 模态遮罩 |
| CardDemo | `demo/card/CardDemo.tscn` | BaseCard 悬停 / 点击选中 / 禁用 |
| UIShowcase | `demo/showcase/UIShowcase.tscn` | **项目主场景（F5）**：左侧分类 → 右侧加载对应 Demo |

## 运行

```bash
# 主入口（UI 实验室）
godot --path .                    # 或编辑器 F5

# 单个 Demo（F6 在编辑器中运行当前场景）
godot --path . demo/button/ButtonDemo.tscn
```

## 主题

`demo/theme/demo_theme.gd`（DemoTheme）代码生成统一深色主题。组件零样式依赖：
Demo 根节点挂 Theme（组件自动继承），组件文件本身不携带任何样式。
