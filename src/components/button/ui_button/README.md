# UIButton — 按钮基类（状态机）

**分类**：button（组件族基类）

| 项 | 路径 |
|---|---|
| Demo | `res://demo/button/ButtonDemo.tscn` |
| Scene | `res://src/components/button/ui_button/UIButton.tscn` |
| Script | `res://src/components/button/ui_button/ui_button.gd` |

## 功能

把原生 Button 的交互信号映射到统一状态机（UIState）：NORMAL ↔ HOVER ↔ PRESSED，禁用 → DISABLED。
子类实现 `_apply_state()` 获得视觉反馈（见 ScaleButton / ToggleButton）。

## 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| text | String | "" | 按钮文字（Button 原生） |
| disabled | bool | false | 禁用（Button 原生） |

## 使用方法

```gdscript
var btn := UIButton.new()
btn.text = "确定"
btn.state_changed.connect(func(from: int, to: int) -> void:
    print("state:", UIState.name_of(to)))
```

## 参考来源

内部基础组件（无外部参考）。
