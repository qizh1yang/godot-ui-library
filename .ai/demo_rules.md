# Demo Rules — Demo 规范

## 1. 强制要求

每个 Block 必须有 Demo（`demos/<族>/`）：

1. 展示 Block 本身（实例化场景，不是截图/描述）。
2. 展示各种状态（hover / pressed / selected / disabled 可触发）。
3. 让用户实际操作。
4. 方便回归（`tests/run_tests.gd` 自动化断言行为）。

**不做运行时调参面板**——参数在 Inspector（编辑器）里调，所见即所得，这是库的原则之一。

## 2. Demo 结构

```text
demos/<族>/<族>Demo.tscn + <族>_demo.gd
```

- Demo 脚本负责：布局、信号回显（Log Label）、内容填充。
- Demo 可 F6 独立运行（自身挂 DemoTheme）；被 UIShowcase 加载时继承其主题。

## 3. UIShowcase 集成

- 所有 Demo 注册进 `demos/ui_showcase.gd` 的 `DEMO_SCENES` + 侧栏加分类按钮。
- 切换 Demo 时 `queue_free` 旧实例。

## 4. 验收清单

- [ ] F6 单独运行无报错
- [ ] 所有状态可触发
- [ ] 信号回显正确
- [ ] Showcase 中可加载
