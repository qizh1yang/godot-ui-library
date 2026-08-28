# Architecture — 分层架构与设计决策

## 1. 分层

```text
Reference                      现实游戏 UI 参考（截图/视频/分析），不参与运行时代码
    ↓                          参考 → 提炼交互模式
Interaction                    用户行为层（hover / press / select / drag / drop / swipe / focus）
    ↓                          行为 → 产生状态
Animation / Effect             视觉反馈层（scale / fade / slide / bounce / shake / flash / glow）
    ↓                          状态 → 消费动画
Component                      可复用 UI 单元（场景 + 脚本 + 参数 + 信号）
    ↓                          组合
Gameplay UI                    业务 UI（inventory / shop / reward ...），组合基础组件
    ↓
Demo                           每个组件可独立运行的演示
    ↓
Catalog                        机器可读索引（index.yaml），AI 检索入口
    ↓
Reuse                          复制组件场景 + 脚本进任何项目
```

各层职责必须保持清晰，上层只依赖相邻下层。

## 2. 关键设计决策

### 2.1 交互与动画解耦（状态机是中间层）

交互层**不直接调用**动画层。统一路径：

```text
Interaction → UIState 状态机 → state_changed 信号 → Component._apply_state() → Feedback 类
```

- 交互（`mouse_entered` / `button_down` / `gui_input`）只做一件事：`state.transition(UIState.State.HOVER)`
- 组件只做一件事：实现 `_apply_state(state)`，内部决定用哪个动画表现
- 好处：`hover → scale` 换成 `hover → glow` 只改 `_apply_state` 一行，交互逻辑零改动

### 2.2 Godot 单节点脚本限制下的组合策略

一个节点只能挂一个脚本（无多继承 / 无 mixin）。落地方式：

- **Button 族 extends 原生 Button**（UIButton → ScaleButton / ToggleButton）：原生按钮行为（focus / keyboard / toggle_mode / disabled）无法通过组合完整获得，继承是 Godot 的标准扩展方式。
- **其余组件 extends `UIComponent`**（extends Control，背景自绘 + 状态机 + 开/关生命周期 + 动画助手）：BasePanel / UIPopup / BaseCard。
- **状态机以组合复用**：`UIState`（RefCounted）被所有组件持有，不重复实现。
- 业务能力一律组合（Gameplay UI 组合组件），禁止把业务逻辑写进基础组件。

### 2.3 组件零依赖自包含

- 不依赖 autoload（`UISignalBus` 是可选增强，组件不强制使用）
- 不依赖项目美术资源（样式走 Theme / StyleBox / `background_style`，默认主题可用）
- 不硬编码颜色 / 字体 / 尺寸（全部 `@export` 参数）
- 复制「场景 + 脚本」即可进任何项目

### 2.4 事件通知统一走 Godot Signal

组件对外只发信号（`toggled` / `clicked` / `selected_changed` / `opened` / `closed`），业务系统决定如何处理。组件**绝不**直接修改外部业务状态。

```gdscript
# 错误：
func _on_drag() -> void:
    player.inventory.remove_item()

# 正确：
func _on_drag() -> void:
    drag_started.emit(self)
```

## 3. 目录职责

| 目录 | 职责 | 是否可含业务逻辑 |
|---|---|---|
| `src/core/` | 状态机、组件基类、信号总线 | 否 |
| `src/interaction/` | 交互行为定义与规则 | 否 |
| `src/animation/` | 动画执行器（Feedback 类） | 否 |
| `src/components/` | 可复用组件（含 README） | 否 |
| `gameplay/` | 业务 UI 组合 | 是（组合层） |
| `demo/` | 演示场景（含参数面板） | 否（可含演示用的假数据） |
| `reference/` | 游戏参考收录 | 否 |
| `catalog/` | AI 检索索引 | 否 |
| `tests/` | 自动化测试 | 否 |

## 4. 数据流

```text
输入（鼠标/触摸/键盘）
    → 组件状态机（UIState）
    → state_changed 信号
    → 组件 _apply_state()（选择 Feedback 动画）
    → 视觉变化 + 对外信号（业务系统监听）
```
