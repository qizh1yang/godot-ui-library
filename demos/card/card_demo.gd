extends Control
## Card 积木 Demo：悬停变体（Theme CardHover）/ 点击选中（CardSelected）/ 禁用（CardDisabled）。

const CARD_SCENE: PackedScene = preload("res://blocks/card/Card.tscn")

@onready var _cards_box: HBoxContainer = $Root/Cards
@onready var _log: Label = $Root/Log

func _ready() -> void:
	theme = DemoTheme.build()
	for i in 5:
		var card: Card = CARD_SCENE.instantiate()
		card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if i == 4:
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

func _on_card_clicked(card: Card, index: int) -> void:
	_log.text = "card: clicked #%d (selected=%s)" % [index + 1, card.is_selected]

func _on_card_selected(card: Card, selected: bool, index: int) -> void:
	_log.text = "card: #%d → %s" % [index + 1, "SELECTED" if selected else "DESELECTED"]
