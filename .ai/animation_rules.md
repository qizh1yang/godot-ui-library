# Animation Rules — 动画层规范

## 1. 定义

Animation / Effect 负责**视觉反馈**：Scale / Fade / Slide / Bounce / Shake / Flash / Punch / Rotate / Glow。

动画是**执行器层**：它不知道交互，也不知道业务。组件在 `_apply_state()` 里选择动画执行器。

```text
Hover ──► Scale          Hover ──► Glow          Hover ──► Scale + Glow
```

## 2. 实现约定

- **优先 Tween / AnimationPlayer（Godot 原生）**，不引入第三方插件。
- 每个动画族一个执行器类（`src/animation/<族>/<族>_feedback.gd`，extends RefCounted）：

```gdscript
# ScaleFeedback 示例
class_name ScaleFeedback
extends RefCounted

var _node: Control
var _tween: Tween

func animate_to(target: Vector2, duration: float, transition: int, ease: int) -> void: ...
func play_punch(strength: Vector2, duration: float) -> void: ...  # 1.0 → strength → 1.0
```

- 执行器由组件 `_ready` 创建并持有，参数从组件 `@export` 透传。

## 3. 通用参数（所有动画执行器统一）

| 参数 | 默认 | 说明 |
|---|---|---|
| `animation_duration` | 0.12s（按压）/ 0.2s（开合） | 时长 |
| `transition` | `Tween.TRANS_BACK`（弹跳类） | 过渡类型 |
| `ease` | `Tween.EASE_OUT` | 缓动 |

约定：

- **按压反馈**：`TRANS_QUAD + EASE_OUT`（快、干脆）
- **弹跳/还原**：`TRANS_BACK + EASE_OUT`（轻微过冲回弹）
- **开合/淡入淡出**：`TRANS_SINE / TRANS_CUBIC + EASE_OUT`

## 4. 缩放动画必须居中

缩放前必须设 `pivot_offset = size * 0.5`，否则以左上角为轴心歪着放大。

## 5. 防重锁

- 同目标同参数动画：目标已达成（`is_equal_approx`）则跳过。
- 新动画开始前 `kill` 旧 Tween，防止抖动叠加。
- 重复调用 `play()` 同一动画（每帧触发）必须短路返回。

## 6. 动画与状态的连接

动画**只**由 `_apply_state(state)` 触发，禁止在交互回调里直接播动画：

```gdscript
# 正确
func _apply_state(new_state: int) -> void:
    match new_state:
        UIState.State.HOVER: _feedback.animate_to(hover_scale, duration, transition, ease)
        UIState.State.NORMAL: _feedback.animate_to(Vector2.ONE, duration, transition, ease)
```

## 7. 动画资产目录

| 文件 | 能力 |
|---|---|
| `src/animation/scale/scale_feedback.gd` | 缩放至目标 / punch 回弹 |
| `src/animation/fade/fade_feedback.gd` | 淡入 / 淡出（可选结束隐藏） |
| `src/animation/bounce/bounce_feedback.gd` | 弹性回弹（punch） |

后续扩展（slide / shake / flash / glow / punch / rotate）同模式新增目录。
