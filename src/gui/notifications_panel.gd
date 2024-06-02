class_name NotificationsPanel
extends VBoxContainer

var duration_in: float = .5
var duration_out: float = 2


func add_notification(notification: Notification) -> PanelContainer:
	var panel: PanelContainer = notification.create_panel()
	var tween: Tween = create_tween()
	panel.modulate.a = 0
	add_child(panel)
	tween.set_parallel(false)
	tween.tween_property(panel, 'modulate:a', 1, duration_in)
	tween.tween_property(panel, 'modulate:a', 1, notification.duration)
	tween.tween_property(panel, 'modulate:a', 0, duration_out)
	tween.tween_callback(panel.queue_free)
	return panel
