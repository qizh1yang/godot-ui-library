class_name SlideOutPanel
extends Control
## 侧边滑出面板（Behavior Block）：Panel + ToggleButton 作为【同一整体】从屏幕边缘滑入/滑出。
## 收起时保留 collapsed_visible_size 区域在屏幕内——ToggleButton（手柄）常驻可见，可再次展开。
##
## 原则（积木库）：Theme 管"长什么样"，本脚本只负责"怎么移动"（位置计算 + Tween）。
## 内容（Content 节点）完全可替换：建筑菜单 / 背包 / 单位列表 / 设置 / 商店……
##
## 位置计算（锚点贴边方案，天然抗 Resize——位置相对锚点而非固定屏幕坐标）：
##   RIGHT：根贴右缘，offset_left 展开=-面板宽，收起=-collapsed_visible_size
##   LEFT ：根贴左缘，offset_left 展开=0，       收起=-(面板宽-collapsed)
##   TOP  ：根贴顶，  offset_top  展开=0，       收起=-(面板高-collapsed)
##   BOTTOM：根贴底， offset_top  展开=-面板高， 收起=-collapsed_visible_size

enum Direction { LEFT, RIGHT, TOP, BOTTOM }

signal opened
signal closed

## 滑出方向。
@export var direction: Direction = Direction.RIGHT
## 动画时长（秒）。
@export var duration: float = 0.25
@export var transition: int = Tween.TRANS_CUBIC
@export var ease: int = Tween.EASE_OUT
## 收起后仍保留在屏幕内的尺寸（px）——ToggleButton 所在区域，保证按钮可点击。
@export var collapsed_visible_size: float = 48.0
## 初始是否展开。
@export var start_open: bool = false
## 收起/展开时 ToggleButton 的指示文字（视觉资源由 Inspector 控制，脚本不写死）。
@export var collapsed_icon: String = "<"
@export var open_icon: String = ">"

var is_open: bool = false

var _tween: Tween
var _expanded_offset: float = 0.0
var _collapsed_offset: float = 0.0
var _panel: Control = null
var _toggle_button: Button = null

func _ready() -> void:
	_panel = get_node_or_null("Panel") as Control
	_toggle_button = get_node_or_null("ToggleButton") as Button
	_setup_anchors()
	if _toggle_button != null:
		_toggle_button.pressed.connect(toggle)
	if start_open:
		is_open = true
		_apply_offset(_expanded_offset)
	else:
		_apply_offset(_collapsed_offset)
	_update_icon()

## 按 direction 设置根锚点（贴边 + 全高/全宽）与 ToggleButton 锚点（收起后露出区）。
## 展开/收起位置由锚点 + offset 表达——Viewport 缩放时锚点自动跟随，无需 _resized 重算。
func _setup_anchors() -> void:
	var preset := size
	match direction:
		Direction.LEFT, Direction.RIGHT:
			anchor_top = 0.0
			anchor_bottom = 1.0 # 全高
			var on_left: bool = direction == Direction.LEFT
			anchor_left = 0.0 if on_left else 1.0
			anchor_right = anchor_left
			offset_top = 0.0
			offset_bottom = 0.0
			var width: float = preset.x
			if on_left:
				offset_left = 0.0
				offset_right = width
				_expanded_offset = 0.0
				_collapsed_offset = -width + collapsed_visible_size
			else:
				offset_left = -width
				offset_right = 0.0
				_expanded_offset = -width
				_collapsed_offset = -collapsed_visible_size
		Direction.TOP, Direction.BOTTOM:
			anchor_left = 0.0
			anchor_right = 1.0 # 全宽
			var on_top: bool = direction == Direction.TOP
			anchor_top = 0.0 if on_top else 1.0
			anchor_bottom = anchor_top
			offset_left = 0.0
			offset_right = 0.0
			var height: float = preset.y
			if on_top:
				offset_top = 0.0
				offset_bottom = height
				_expanded_offset = 0.0
				_collapsed_offset = -height + collapsed_visible_size
			else:
				offset_top = -height
				offset_bottom = 0.0
				_expanded_offset = -height
				_collapsed_offset = -collapsed_visible_size
	# ToggleButton 锚定在收起后仍可见的角落（方向相关）
	if _toggle_button != null:
		var s: float = collapsed_visible_size
		match direction:
			Direction.LEFT: # 左上角
				_toggle_button.anchor_left = 0.0
				_toggle_button.anchor_right = 0.0
				_toggle_button.anchor_top = 0.0
				_toggle_button.anchor_bottom = 0.0
				_toggle_button.offset_left = 0.0
				_toggle_button.offset_right = s
				_toggle_button.offset_top = 0.0
				_toggle_button.offset_bottom = s
			Direction.RIGHT: # 右上角
				_toggle_button.anchor_left = 1.0
				_toggle_button.anchor_right = 1.0
				_toggle_button.anchor_top = 0.0
				_toggle_button.anchor_bottom = 0.0
				_toggle_button.offset_left = -s
				_toggle_button.offset_right = 0.0
				_toggle_button.offset_top = 0.0
				_toggle_button.offset_bottom = s
			Direction.TOP: # 右下角（TOP 收起露出底部）
				_toggle_button.anchor_left = 1.0
				_toggle_button.anchor_right = 1.0
				_toggle_button.anchor_top = 1.0
				_toggle_button.anchor_bottom = 1.0
				_toggle_button.offset_left = -s
				_toggle_button.offset_right = 0.0
				_toggle_button.offset_top = -s
				_toggle_button.offset_bottom = 0.0
			Direction.BOTTOM: # 右上角（BOTTOM 收起露出顶部）
				_toggle_button.anchor_left = 1.0
				_toggle_button.anchor_right = 1.0
				_toggle_button.anchor_top = 0.0
				_toggle_button.anchor_bottom = 0.0
				_toggle_button.offset_left = -s
				_toggle_button.offset_right = 0.0
				_toggle_button.offset_top = 0.0
				_toggle_button.offset_bottom = s

# --- 控制 API ---

func open() -> void:
	if is_open:
		return
	is_open = true
	_animate_offset(_expanded_offset)
	_update_icon()

func close() -> void:
	if not is_open:
		return
	is_open = false
	_animate_offset(_collapsed_offset)
	_update_icon()

func toggle() -> void:
	if is_open:
		close()
	else:
		open()

# --- 内部 ---

func _animate_offset(target: float) -> void:
	# 连续触发时 kill 旧 Tween，从当前实际位置继续（不瞬移）
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.set_trans(transition).set_ease(ease)
	_tween.tween_property(self, _axis_property(), target, duration)
	_tween.tween_callback(_on_animation_finished)

func _apply_offset(value: float) -> void:
	set(_axis_property(), value)

func _axis_property() -> String:
	# String → tween_property(NodePath) / set(StringName) 都自动转换；StringName 则都不行
	return "offset_left" if direction == Direction.LEFT or direction == Direction.RIGHT else "offset_top"

func _on_animation_finished() -> void:
	if is_open:
		opened.emit()
	else:
		closed.emit()

func _update_icon() -> void:
	if _toggle_button != null:
		_toggle_button.text = open_icon if is_open else collapsed_icon
