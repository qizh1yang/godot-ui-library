class_name DemoTheme
extends RefCounted
## Demo 主题：定义所有 Block 的视觉（颜色/边框/圆角全在此处，Block 脚本零样式）。
## 用户项目不需要本文件——在项目自己的 Theme 里配同样的类型/变体即可。

const BG := Color(0.09, 0.09, 0.12, 1.0)
const CARD_BG := Color(0.18, 0.18, 0.24, 0.97)
const PANEL_BG := Color(0.12, 0.12, 0.16, 0.97)
const ACCENT := Color(0.36, 0.62, 0.90, 1.0)
const TEXT := Color(0.92, 0.92, 0.95, 1.0)
const TEXT_MUTED := Color(0.6, 0.6, 0.68, 1.0)

static func build() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 15

	# --- Button 族（Button / ScaleButton / ToggleButton 类型链回退到 Button） ---
	theme.set_stylebox("normal", "Button", _style(CARD_BG, 10))
	theme.set_stylebox("hover", "Button", _style(CARD_BG.lightened(0.14), 10))
	theme.set_stylebox("pressed", "Button", _style(ACCENT.darkened(0.15), 10))
	theme.set_stylebox("disabled", "Button", _style(CARD_BG.darkened(0.25), 10))
	theme.set_color("font_color", "Button", TEXT)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", Color.WHITE)
	theme.set_color("font_disabled_color", "Button", TEXT_MUTED)

	# --- Panel 系（Panel / PopupPanel / DrawerPanel，类型链回退到 PanelContainer） ---
	theme.set_stylebox("panel", "PanelContainer", _style(PANEL_BG, 12))
	theme.set_stylebox("panel", "UIPopup", _style(PANEL_BG, 12))
	theme.set_stylebox("panel", "DrawerPanel", _style(PANEL_BG, 12))

	# --- Card 变体（脚本切 theme_type_variation） ---
	theme.set_stylebox("panel", "Card", _style(CARD_BG, 12))
	theme.set_stylebox("panel", "CardHover", _style(CARD_BG.lightened(0.12), 12, Color(1, 1, 1, 0.25), 2))
	theme.set_stylebox("panel", "CardSelected", _style(CARD_BG.lightened(0.22), 12, ACCENT, 2))
	theme.set_stylebox("panel", "CardDisabled", _style(CARD_BG.darkened(0.25), 12))

	# --- Demo 建筑槽 ---
	theme.set_stylebox("panel", "BuildingSlot", _style(CARD_BG, 8))
	theme.set_stylebox("panel", "BuildingSlotHover", _style(CARD_BG.lightened(0.12), 8, Color(1, 1, 1, 0.25), 2))

	# --- Label ---
	theme.set_color("font_color", "Label", TEXT)

	return theme

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
