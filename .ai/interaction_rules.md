# Interaction Rules — 交互规则

## 1. 交互 = connect 原生信号

Behavior Block 的脚本直接 connect 原生信号，不做状态机抽象：

| 交互 | 侦测源 |
|---|---|
| Hover | `mouse_entered` / `mouse_exited` |
| Press / Release | `button_down` / `button_up`（Button）或 `gui_input`（Control） |
| Select / Toggle | `toggle_mode`（Button 原生）或手动 `set_selected()` |
| Open / Close | 显式方法调用（`open()` / `close()`） |
| Focus | `focus_entered` / `focus_exited` |

## 2. 视觉响应两条路

1. **Theme 能做的**（hover/pressed/disabled 样式、toggle 选中样式）→ 什么都不写，Theme 自动。
2. **Theme 做不了的**（Transform 缩放、位置移动、显隐动画）→ 脚本 Tween。

## 3. 业务隔离

交互回调内禁止访问业务对象（玩家/库存/商店）。只允许：播动画、切 Theme 变体、发信号。

## 4. 触摸适配

触摸无 hover：Behavior Block 的 hover 反馈（如缩放）在触摸上不触发是正常的——press 反馈替代。
