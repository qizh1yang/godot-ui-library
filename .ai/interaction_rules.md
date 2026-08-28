# Interaction Rules — 交互层规范

## 1. 定义

Interaction 表示**用户行为**：Hover / Press / Release / Select / Deselect / DragStart / Drag / Drop / Swipe / Focus / Blur。

Interaction 是**行为层**：它不包含具体游戏业务逻辑，也不直接播放动画。它只做两件事：

1. 侦测行为（信号 / 输入事件）
2. 更新状态机（`UIState.transition()`）

```gdscript
# 正确：交互 → 状态
func _on_mouse_entered() -> void:
    state.transition(UIState.State.HOVER)

# 错误：交互 → 业务
func _on_mouse_entered() -> void:
    player.inventory.highlight(self)
```

## 2. 状态机流转

```text
               mouse_entered                 button_down
NORMAL ──────────────────────► HOVER ────────────────────► PRESSED
  ▲                            │  ▲                          │
  │      mouse_exited          │  │   button_up (仍在悬停)    │
  └────────────────────────────┘  └──────────────────────────┘
                                button_up (离开) → NORMAL

SELECTED（toggle / 点击选择）：独立状态，可叠加 hover / press 表现
DISABLED：拦截一切交互（mouse / button / focus 信号不派发）
```

- 禁用态：`disabled = true` 时组件忽略所有 hover / press 状态切换。
- 选中态切换必须发对外信号（`toggled` / `selected_changed`）。

## 3. 侦测方式

| 交互 | 侦测源 | 备注 |
|---|---|---|
| Hover / Blur | `mouse_entered` / `mouse_exited`（Control 原生信号） | 触摸屏无 hover |
| Press | `button_down` / `gui_input`（MouseButton pressed） | Button 原生或 `gui_input` |
| Release | `button_up` / `gui_input`（MouseButton released） | |
| Select / Deselect | toggle_mode / 手动 `set_selected()` | 发 `toggled` 信号 |
| Drag / Drop | `_get_drag_data` / `_can_drop_data` / `_drop_data`（Control 虚函数） | 第二阶段 |
| Swipe | `_gui_input` 累积位移 | 第二阶段 |
| Focus / Blur | `focus_entered` / `focus_exited` | 键盘导航 |

## 4. 业务隔离铁律

Interaction 回调内**禁止**：

- 访问玩家 / 库存 / 商店 / 任何业务对象
- 修改游戏状态（扣资源、加物品……）

只允许：

- `state.transition(...)`
- `信号.emit(...)`（把决定权交给业务系统）

## 5. 触摸适配

- 触摸设备没有 hover：状态应能从触摸按压缩放回弹获得等效反馈（press 动画即反馈）。
- 鼠标 + 触摸双输入无需特殊处理（Godot 统一派发），但 hover 触发的效果（如 tooltip）需在触摸上另有入口。
