# Demo Rules — Demo 规范

## 1. 强制要求

每个公开 Component 必须有对应 Demo，放在 `demo/` 下（不在组件目录内）：

```text
src/components/button/scale_button/ScaleButton.tscn   →  demo/button/ButtonDemo.tscn
```

Demo 必须能够：

1. **展示组件**：实例化组件本身（不是图片 / 描述）。
2. **展示各种状态**：Normal / Hover / Pressed / Selected / Disabled 全部可触发。
3. **展示参数**：参数面板（Slider / SpinBox / OptionButton）实时修改组件 `@export`，看到效果。
4. **让用户实际操作**：鼠标真实交互。
5. **方便回归**：后续修改组件后，跑一遍 Demo 确认行为没坏（自动化见 `tests/`）。

## 2. 结构约定

```text
demo/<族>/
├── <族>Demo.tscn      # 演示场景
└── <族>_demo.gd       # 演示脚本
```

- Demo 脚本 extends Control，负责：布局、参数面板、状态回显（Label 显示当前 state）。
- Demo 可单独 F6 运行；同时被 `UIShowcase` 动态加载。
- Demo 需要假数据时，写在 Demo 脚本内（常量 / 本地生成），不引入业务层。

## 3. 参数面板约定

- 每个可调参数一组：`Label + HSlider（或 SpinBox）+ 当前值 Label`。
- Slider 范围合理（如 `hover_scale` 0.90 ~ 1.30，`duration` 0.05 ~ 0.50）。
- 修改立即生效（连接 `value_changed`，直接写组件 `@export`）。

## 4. 状态回显

Demo 里放一个状态 Label，连接 `state_changed` 信号显示当前状态名（NORMAL / HOVER / PRESSED / SELECTED / DISABLED），方便验证状态机。

## 5. Showcase 集成

- 所有 Demo 注册进 `demo/showcase/UIShowcase.tscn`（`DEMO_SCENES` 字典）。
- Showcase 左侧分类按钮（ToggleButton 组），右侧 `DemoContainer` 动态实例化对应 Demo。
- 切换 Demo 时释放旧实例（`queue_free`），防叠加。

## 6. Demo 验收清单

- [ ] F6 单独运行无报错
- [ ] 所有状态可触发
- [ ] 参数面板修改生效
- [ ] 状态 Label 正确回显
- [ ] Showcase 中可加载
