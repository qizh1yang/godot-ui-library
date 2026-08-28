# Animation Rules — 动画约定

## 1. 动画内聚到 Block

不做公共动画层/执行器抽象。每个 Behavior Block 内部用自己的 Tween 实现**它自己的行为**：
- ScaleButton → scale Tween
- DrawerPanel → offset Tween
- PopupPanel → modulate / scale Tween

## 2. 通用参数（所有动画 Block 统一）

| 参数 | 默认 | 说明 |
|---|---|---|
| `duration` | 0.12~0.25s | 动画时长 |
| `transition` | `TRANS_BACK`（弹跳）/ `TRANS_CUBIC`（滑动） | 过渡类型 |
| `ease` | `EASE_OUT` | 缓动 |

约定：按压反馈 `TRANS_QUAD + EASE_OUT`（快、干脆）；弹跳还原 `TRANS_BACK + EASE_OUT`；抽屉滑动 `TRANS_CUBIC + EASE_OUT`。

## 3. 缩放必须居中

缩放前 `pivot_offset = size * 0.5`，否则以左上角为轴心歪着放大。

## 4. 防重锁

- 目标已达成（`is_equal_approx`）→ 跳过。
- 新动画前 `kill` 旧 Tween。
- 开合类加防抖标志（`is_open` / `_animating`），动画中忽略重复触发。

## 5. 退场动画

动画结束再 hide（`tween_callback(hide)` 或 await timer 后 hide）——不要先 hide 再播动画。
