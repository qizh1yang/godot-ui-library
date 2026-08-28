class_name DrawerPanel
extends PanelContainer
## 抽屉（Behavior Block）：从屏幕边缘滑入/滑出（侧边栏/背包式）。
##
## 原则：视觉（背景/边框）交给 Theme（类型名 DrawerPanel）；
##       脚本只负责 Theme 做不了的"屏幕外 → 屏幕内"的位置 Tween。
##
## 用法：拖入场景 → Inspector 设 direction / duration / transition →
##       内容塞进 Content 容器 → open_btn.pressed.connect(drawer.open)
##
## 定位方式：锚点贴边 + offset 偏移。LEFT/RIGHT 自动全高（宽度 = 场景预设宽度），
##          TOP/BOTTOM 自动全宽（高度 = 场景预设高度，请在 Inspector 设置）。

enum Direction { LEFT, RIGHT, TOP, BOTTOM }

signal opened
signal closed

@export var direction: Direction = Direction.RIGHT
@export var duration: float = 0.25
@export var transition: int = Tween.TRANS_CUBIC
@export var ease: int = Tween.EASE_OUT
@export var modal: bool = true
@export var close_on_click_outside: bool = true

var is_open: bool = false
var _animating: bool = false
var _rest_offset := Vector2.ZERO
var _hidden_offset := Vector2.ZERO
var _dim: ColorRect = null

func _ready() -> void:
	# 先取编辑器预设尺寸，再按方向贴边
	var preset_size := size
	match direction:
		Direction.LEFT, Direction.RIGHT:
			anchor_top = 0.0
			anchor_bottom = 1.0 # 全高
			var on_left: bool = direction == Direction.LEFT
			anchor_left = 0.0 if on_left else 1.0
			anchor_right = anchor_left
			offset_top = 0.0
			offset_bottom = 0.0
			if on_left:
				offset_left = 0.0
				offset_right = preset_size.x
			else:
				offset_left = -preset_size.x
				offset_right = 0.0
		Direction.TOP, Direction.BOTTOM:
			anchor_left = 0.0
			anchor_right = 1.0 # 全宽
			var on_top: bool = direction == Direction.TOP
			anchor_top = 0.0 if on_top else 1.0
			anchor_bottom = anchor_top
			offset_left = 0.0
			offset_right = 0.0
			if on_top:
				offset_top = 0.0
				offset_bottom = preset_size.y
			else:
				offset_top = -preset_size.y
				offset_bottom = 0.0
	_rest_offset = Vector2(offset_left, offset_top)
	# 隐藏位置 = 停靠位置 + 向屏幕外方向推一个自身尺寸
	var axis := Vector2(preset_size.x, preset_size.y)
	match direction:
		Direction.LEFT:
			_hidden_offset = _rest_offset + Vector2(-axis.x, 0.0)
		Direction.RIGHT:
			_hidden_offset = _rest_offset + Vector2(axis.x, 0.0)
		Direction.TOP:
			_hidden_offset = _rest_offset + Vector2(0.0, -axis.y)
		Direction.BOTTOM:
			_hidden_offset = _rest_offset + Vector2(0.0, axis.y)
	offset_left = _hidden_offset.x
	offset_top = _hidden_offset.y
	visible = false

	_dim = get_node_or_null("ModalDim") as ColorRect
	if _dim != null:
		_dim.mouse_filter = Control.MOUSE_FILTER_STOP
		_dim.gui_input.connect(_on_dim_input)

func open() -> void:
	if is_open or _animating:
		return
	is_open = true
	_animating = true
	show()
	if modal and _dim != null:
		_dim.global_position = Vector2.ZERO
		_dim.size = get_viewport_rect().size
		_dim.show()
	var tween := create_tween()
	tween.set_trans(transition).set_ease(ease)
	tween.tween_property(self, "offset_left", _rest_offset.x, duration)
	tween.parallel().tween_property(self, "offset_top", _rest_offset.y, duration)
	tween.tween_callback(func() -> void:
		_animating = false
		opened.emit())

func close() -> void:
	if not is_open or _animating:
		return
	is_open = false
	_animating = true
	if _dim != null:
		_dim.hide()
	var tween := create_tween()
	tween.set_trans(transition).set_ease(ease)
	tween.tween_property(self, "offset_left", _hidden_offset.x, duration)
	tween.parallel().tween_property(self, "offset_top", _hidden_offset.y, duration)
	tween.tween_callback(func() -> void:
		_animating = false
		hide()
		closed.emit())

func toggle_open() -> void:
	if is_open:
		close()
	else:
		open()

func _on_dim_input(event: InputEvent) -> void:
	if close_on_click_outside and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close()
