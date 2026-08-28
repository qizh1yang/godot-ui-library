class_name UIComponent
extends Control
## 库组件统一基类：状态机接线 + 开/关生命周期 + 背景自绘 + 动画助手。
##
## 设计（Godot 单节点脚本限制下的组合策略，见 .ai/architecture.md）：
## - Button 族 extends 原生 Button（组合 UIState），不继承本类；
## - Panel / Card / 未来纯 Control 组件统一继承本类（背景用 StyleBox 自绘，免去 PanelContainer 依赖）。
##
## 组件零依赖：不访问 autoload、不依赖项目资源。样式走 background_style / Theme，默认主题可用。

# --- 状态机 ---
## 状态变化信号（from/to 为 UIState.State 枚举值）。
signal state_changed(from: int, to: int)

## 组件持有的状态机（组合复用，见 src/core/ui_state.gd）。
var state: UIState = UIState.new()

# --- 生命周期（可开合组件：面板/弹窗） ---
signal opened
signal closed

## 模态：打开时拦截背景输入（配合子节点 ModalDim 遮罩使用，见 UIPopup）。
@export var modal: bool = false
var is_open: bool = false

# --- 背景样式（自绘） ---
## 组件背景样式；为空则不绘制（纯逻辑组件可用）。
@export var background_style: StyleBoxFlat = null

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	if background_style != null:
		background_style.changed.connect(queue_redraw)

func _draw() -> void:
	var sb: StyleBox = background_style
	if sb == null:
		# 主题回退：Demo/游戏项目可通过 Theme 的 "UIComponent" 类型统一提供背景（组件零依赖）
		sb = get_theme_stylebox("panel", "UIComponent")
	if sb != null:
		draw_style_box(sb, Rect2(Vector2.ZERO, size))

# --- 状态机接线 ---
## 交互回调统一入口：只做状态切换，不直接播动画。
func _set_state(new_state: int) -> void:
	state.transition(new_state)

func _on_state_changed(from: int, to: int) -> void:
	state_changed.emit(from, to)
	_apply_state(to)

## 子类实现：按状态播放动画 / 切换样式（交互与动画在此解耦）。
func _apply_state(new_state: int) -> void:
	pass

# --- 生命周期 ---
func open() -> void:
	if is_open:
		return
	is_open = true
	show()
	_on_open()
	opened.emit()

func close() -> void:
	if not is_open:
		return
	is_open = false
	_on_close()
	closed.emit()

func toggle_open() -> void:
	if is_open:
		close()
	else:
		open()

## 子类：入场动画（open 已 show()，此处播动画即可）。
func _on_open() -> void:
	pass

## 子类：退场动画。默认立即隐藏；动画退场组件（如 UIPopup）自行在动画回调里 hide()。
func _on_close() -> void:
	hide()

# --- 动画助手 ---
## 缩放类动画前必须居中 pivot（否则以左上角为轴心）。
func set_pivot_centered() -> void:
	pivot_offset = size * 0.5

## 通用属性动画助手（Tween 参数类型是 NodePath，调用时传字符串字面量即可自动转换）。
func tween_property_to(prop: NodePath, target_value: Variant, duration: float, transition: int = Tween.TRANS_QUAD, ease: int = Tween.EASE_OUT) -> Tween:
	var tween := create_tween()
	tween.tween_property(self, prop, target_value, duration).set_trans(transition).set_ease(ease)
	return tween
