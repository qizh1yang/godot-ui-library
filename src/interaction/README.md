# Interaction 层

**交互 = 用户行为层**（hover / press / select / drag / drop / swipe / focus / blur）。

## 职责

1. 侦测用户行为（Control 原生信号 / `gui_input` / 拖放虚函数）
2. 更新状态机（`state.transition(UIState.State.X)`）

**禁止**：直接操作业务系统、直接播放动画（动画由组件 `_apply_state()` 消费状态后播放）。

## 当前实现

| 交互 | 状态 | 实现组件 |
|---|---|---|
| hover | NORMAL ↔ HOVER | UIButton（mouse_entered/exited）、BaseCard |
| press | PRESSED | UIButton（button_down/up）、BaseCard（gui_input） |
| select / deselect | SELECTED ↔ NORMAL | ToggleButton（toggle_mode）、BaseCard（set_selected） |

详细规则见 `.ai/interaction_rules.md`。

## 规划目录

`hover/` `press/` `select/` `drag/` `drop/` `swipe/` `focus/`

> 遵循「目录可规划、代码只实现需要的」：当前交互已由组件内置实现，暂不拆分独立目录；新增复杂交互（drag/drop/swipe）时按需建立。
