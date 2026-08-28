# Component Rules — 组件规范

## 1. 每个 Component 必须

1. 可以独立实例化（有自己的 `.tscn`）。
2. 尽可能不依赖具体 Gameplay（零依赖原则）。
3. 对外暴露清晰的 `@export` 参数。
4. 使用 Godot Signal 进行事件通知。
5. 不直接修改外部业务系统。
6. 必须提供 Demo（可独立运行）。
7. 必须有 Catalog 描述（`catalog/index.yaml` 条目）。
8. 必须有 README（组件目录下，含参数/用法/参考来源）。

## 2. 参数规范

- 参数只描述**表现**，不描述**业务**：

```gdscript
# 正确 —— ScaleButton
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.92, 0.92)
@export var animation_duration: float = 0.12
@export var transition: int = Tween.TRANS_BACK
@export var ease: int = Tween.EASE_OUT

# 错误 —— 业务泄漏
@export var player_id: int
@export var coin_manager: Node
@export var hero_data: Dictionary
```

- 所有参数必须有默认值（组件零配置即可用）。
- 参数命名：`<名词>_scale` / `<名词>_duration` / `<形容词>_<属性>`。

## 3. 信号规范

- 信号名用过去时或动词过去式：`toggled` / `clicked` / `selected_changed` / `opened` / `closed` / `drag_started`。
- 信号参数携带最小上下文（通常是自己 + 必要数据），业务系统自行关联。
- 组件内部状态变化统一走 `state_changed(from, to)`（由 `UIState` 发出）。

## 4. 状态规范

所有组件共享同一套状态机（`UIState`）：

```text
NORMAL → HOVER → PRESSED → (release) → HOVER / NORMAL
SELECTED（选中态，独立于 hover / press）
DISABLED（禁用态，拦截一切交互）
```

- 交互信号只调用 `state.transition()`。
- 组件实现 `_apply_state(new_state)` 决定视觉表现。
- `state.transition()` 内部防重（同状态重复切换不触发）。

## 5. 零依赖清单（组件脚本禁止）

- `preload` 游戏业务脚本 / 场景
- 访问 autoload 单例（`UISignalBus` 可选，不强制）
- 硬编码 `Color` / `Font` / 尺寸魔法数（应参数化）
- 读取 `user://` 或外部数据文件

## 6. 脚本要求

- 显式类型标注（`var x: Control`），禁止 Variant 推断。
- `class_name` 在 `extends` 之前。
- 每个脚本 ≤ 300 行；超出拆子类 / 组合。
