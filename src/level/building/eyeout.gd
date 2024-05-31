extends AnimatedSprite2D

var blink_time_range: Vector2 = Vector2(2, 7)
var double_blink_chance: float = .2

var blink_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blink_timer = Timer.new()
	blink_timer.name = "BlinkTimer"
	blink_timer.autostart = true
	blink_timer.one_shot = true
	blink_timer.timeout.connect(_on_blink_timeout)
	add_child(blink_timer)
	


func _on_blink_timeout() -> void:
	blink(get_blink_count())

func blink(times: int) -> void:
	for i in range(times):
		play("blink")
		await animation_finished
	stop()
	randomize_blink()

func get_blink_count() -> int:
	return 2 if randf() < double_blink_chance else 1

func randomize_blink() -> void:
	blink_timer.wait_time = randf_range(blink_time_range.x, blink_time_range.y)
	blink_timer.start()
