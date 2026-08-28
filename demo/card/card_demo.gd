extends Control
## Card 族 Demo：BaseCard 悬停 / 点击选中 / 禁用状态 + 信号回显。
## 可 F6 单独运行；也可被 UIShowcase 加载。

const CARD_SCENE: PackedScene = preload("res://src/components/card/base_card/BaseCard.tscn")

## 每张卡片的强调色（纯演示用假数据，卡片组件本身不绑定数据）。
const CARD_ACCENTS: Array[Color] = [
	Color(0.20, 0.23, 0.30),
	Color(0.23, 0.20, 0.30),
	Color(0.20, 0.30, 0.27),
	Color(0.30, 0.27, 0.20),
	Color(0.28, 0.20, 0.20),
]

@onready var _cards_box: HBoxContainer = $Root/Cards
@onready var _log: Label = $Root/Log

func _ready() -> void:
	theme = DemoTheme.build()
	for i in CARD_ACCENTS.size():
		var card: BaseCard = CARD_SCENE.instantiate()
		card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if i == CARD_ACCENTS.size() - 1:
			card.disabled = true # 第 5 张演示禁用态
		_cards_box.add_child(card)

		var label := Label.new()
		label.text = "Card %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		card.add_child(label)

		card.clicked.connect(_on_card_clicked.bind(i))
		card.selected_changed.connect(_on_card_selected.bind(i))
		card.state_changed.connect(_on_card_state.bind(i))

func _on_card_clicked(card: BaseCard, index: int) -> void:
	_log.text = "card: clicked #%d (selected=%s)" % [index + 1, card.is_selected]

func _on_card_selected(card: BaseCard, selected: bool, index: int) -> void:
	_log.text = "card: #%d → %s" % [index + 1, "SELECTED" if selected else "DESELECTED"]

func _on_card_state(from: int, to: int, index: int) -> void:
	_log.text = "card: #%d state %s → %s" % [index + 1, UIState.name_of(from), UIState.name_of(to)]
