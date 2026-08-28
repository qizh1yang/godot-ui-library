# Component Rules — Block 规范

## 1. Block 必须

1. 可以独立实例化（有自己的 `.tscn`）。
2. 视觉全部来自 Theme（类型名 / theme_type_variation），脚本零样式值（禁止硬编码 Color/StyleBox/Font）。
3. 对外暴露清晰的 `@export` 参数（Inspector 里配）。
4. 用 Godot 原生 Signal 通知（clicked / selected_changed / opened / closed / toggled）。
5. 不直接修改外部业务系统（发信号，业务方决定）。
6. 必须提供 Demo。
7. 必须加入 Catalog（`catalog/index.yaml`）。
8. 有 README（参数/用法）。

## 2. Pure Block 铁律

没有脚本。如果发现需要脚本，先问：**Theme 能不能做？原生节点能不能做？**
- 能 → 不加脚本
- 不能 → 升级为 Behavior Block（加最小脚本）

## 3. Behavior Block 铁律

- 脚本**只做 Theme 做不了的那一件事**：
  - Transform 变化（scale 缩放）→ Tween
  - 位置移动（抽屉滑入滑出）→ 锚点 + offset + Tween
  - 开合动画 / 显隐时序 → Tween + hide/show
  - 状态切换（hover/selected/disabled）→ `theme_type_variation` 切换 + 信号
- 脚本里**禁止**出现颜色、字体、样式相关代码（那是 Theme 的领地）。
- 参数只描述**行为**，不描述视觉：

```gdscript
# 正确（ScaleButton）
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var duration: float = 0.12
@export var transition: int = Tween.TRANS_BACK

# 错误（视觉泄漏）
@export var bg_color: Color
@export var font: Font
```

## 4. 参数规范

- 全部 `@export`，全部有默认值（零配置可用）。
- 命名：`<名词>_scale` / `duration` / `transition` / `ease`。
- 需要视觉参数时，用 Theme 类型/变体名而非颜色值（如 `selected_variation: StringName = &"CardSelected"`）。

## 5. 信号规范

- 过去时：`clicked` / `selected_changed` / `opened` / `closed` / `toggled`。
- 参数携带最小上下文（自己 + 必要数据）。

## 6. 零依赖

- 不访问 autoload、不 preload 业务脚本。
- 不依赖项目资源（样式全 Theme，默认主题可用）。
- 复制「场景 + 脚本」即进任何项目。

## 7. 脚本要求

- 显式类型标注；`class_name` 在 `extends` 前。
- **class_name 不能与 Godot 原生类同名**（`BaseButton`/`PopupPanel` 都是引擎已有类——先查文档再命名）。
- 每个脚本 ≤ 150 行；超了说明职责不纯。
