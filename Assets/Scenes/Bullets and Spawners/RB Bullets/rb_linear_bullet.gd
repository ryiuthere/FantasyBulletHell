extends Bullet

var speedup_amount := 0.0
var speedup_delay := 1.0

func behavior_thread() -> void:
	await pause(speedup_delay)
	speed += speedup_amount
