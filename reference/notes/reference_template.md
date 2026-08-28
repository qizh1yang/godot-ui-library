# Reference 记录模板

每收录一条 UI 参考，按此模板记录：

```markdown
# <游戏名> — <UI 类型>

- 来源：<Game UI Database 链接 / 截图路径 / 视频路径>
- 收录日期：YYYY-MM-DD

## 截图 / 视频

<截图路径，reference/screenshots/ 下>

## 交互方式

- <如：悬停放大 + 按下缩小>
- <如：长按弹出详情>

## 动画方式

- <如：scale 1.0→1.1 TRANS_BACK 0.2s>
- <如：淡入 + 上滑 0.3s>

## 设计分析

- 为什么有效
- 可复刻到 Godot 的要点
- 参考实现组件：<catalog id，如 scale_button>
```

## 提炼为组件时的动作

1. 确定交互层（interaction）与动画层（effect）组合
2. 检查 catalog 是否已有近似组件（有 → 参数化扩展；无 → 新建组件）
3. 按 `.ai/contribution_rules.md` 走完整流程
