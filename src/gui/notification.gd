class_name Notification
extends Resource

@export var message: String
@export var duration: float = 10


func create_panel() -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var margin: MarginContainer = MarginContainer.new()
	var label: Label = Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	panel.size_flags_horizontal = Control.SIZE_SHRINK_END
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_bottom", 2)
	margin.add_theme_constant_override("margin_right", 4)

	margin.add_child(label)
	panel.add_child(margin)
	return panel
