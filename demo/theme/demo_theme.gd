class_name DemoTheme
extends RefCounted
## Demo 统一视觉主题（深色圆角卡片风格，对齐库的视觉语言）。
## 注意：组件零依赖——样式只在此处（Demo 层）提供，组件文件不携带任何样式。

const BG := Color(0.09, 0.09, 0.12, 1.0)
const CARD_BG := Color(0.18, 0.18, 0.24, 0.97)
const PANEL_BG := Color(0.12, 0.12, 0.16, 0.97)
const TEXT := Color(0.92, 0.92, 0.95, 1.0)
const TEXT_MUTED := Color(0.6, 0.6, 0.68, 1.0)
const ACCENT := Color(0.36, 0.62, 0.90, 1.0)

## 构建完整 Theme（给 UIShowcase / 各 Demo 根节点挂载，子节点自动继承）。
static func build() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 15

	# --- Button 族（类型链：ScaleButton/ToggleButton → UIButton → Button） ---
	theme.set_stylebox("normal", "Button", _style(CARD_BG, 10))
	theme.set_stylebox("hover", "Button", _style(CARD_BG.lightened(0.14), 10))
	theme.set_stylebox("pressed", "Button", _style(CARD_BG.darkened(0.18), 10))
	theme.set_stylebox("disabled", "Button", _style(CARD_BG.darkened(0.25), 10))
	theme.set_color("font_color", "Button", TEXT)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", Color.WHITE)
	theme.set_color("font_disabled_color", "Button", TEXT_MUTED)

	# --- UIComponent 背景（类型链：BasePanel/UIPopup/BaseCard 自动继承） ---
	theme.set_stylebox("panel", "UIComponent", _style(CARD_BG, 12))

	# --- 侧栏面板 ---
	theme.set_stylebox("panel", "PanelContainer", _style(PANEL_BG, 12))

	# --- Label ---
	theme.set_color("font_color", "Label", TEXT)

	return theme

## 圆角卡片 StyleBox（深色 + 可选描边）。
static func _style(color: Color, radius: int = 10, border_color: Color = Color(1, 1, 1, 0.06), border_width: int = 1) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.set_corner_radius_all(radius)
	if border_width > 0:
		sb.border_color = border_color
		sb.set_border_width_all(border_width)
	sb.content_margin_left = 14.0
	sb.content_margin_right = 14.0
	sb.content_margin_top = 10.0
	sb.content_margin_bottom = 10.0
	return sb
