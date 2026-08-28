# Tests

headless 自动化测试（SceneTree 脚本模式）：

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

覆盖：

- 组件场景可实例化、无脚本错误
- 状态机流转（hover/press/select 防重）
- 组件信号（toggled/clicked/opened/closed/selected_changed）
- UIPopup 开/关生命周期

子目录规划：`components/` `interaction/` `animation/`（按需拆分测试文件，当前集中在 `run_tests.gd`）。

> 注意：`--script` 模式 autoload 不可用，测试不依赖 UISignalBus——这同时验证了组件零依赖原则。
