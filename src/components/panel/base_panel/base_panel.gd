class_name BasePanel
extends UIComponent
## 面板基类：开/关生命周期 + 模态遮罩（可选子节点 ModalDim）。
##
## UIComponent 自绘背景（background_style）；子类（UIPopup）在 _on_open/_on_close
## 中加开合动画。
## 对外信号：opened / closed。
## 模态：modal=true 时 open 会显示全屏半透明遮罩（ModalDim），拦截背景输入；
##        点击遮罩（close_on_click_outside=true）关闭面板。

@export var close_on_click_outside: bool = true

var _dim: ColorRect = null

func _ready() -> void:
	super()
	_dim = get_node_or_null("ModalDim") as ColorRect
	if _dim != null:
		_dim.mouse_filter = Control.MOUSE_FILTER_STOP
		_dim.gui_input.connect(_on_dim_input)

func open() -> void:
	if is_open:
		return
	if modal and _dim != null:
		_dim.size = get_viewport_rect().size
		_dim.show()
	super.open()

func close() -> void:
	if not is_open:
		return
	if _dim != null:
		_dim.hide()
	super.close()

func _on_dim_input(event: InputEvent) -> void:
	if close_on_click_outside and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close()
