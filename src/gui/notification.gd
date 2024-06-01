class_name Notification
extends Resource

@export var message: String
@export var duration: float = 10


func create_panel() -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var label: Label = Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	panel.add_child(label)
	return panel
