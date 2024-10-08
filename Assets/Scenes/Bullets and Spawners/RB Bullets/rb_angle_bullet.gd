extends Bullet

var sprites : Array[Sprite2D]

# These methods need to be set by the subpattern when it creates this bullet
var speedup_amount := 0.0
var direction_change_reversed := false
var hue_offset := 0.0


func set_sprites_hue() -> void:
	# Helper function unique to this behavior script. Sets color of children sprites.
	for sprite in sprites:
		sprite.self_modulate.h += hue_offset


func setup() -> void:
	# Placing code here is equivalent to placing it at the start of behavior_thread; this just helps 
	# distinguish between behavior code and code that is used for setup and should always be run immediately.
	for node in get_children():
		if node is Sprite2D:
			sprites.push_back(node)
	set_sprites_hue()


func behavior_thread() -> void:
	# Overriding behavior_thread to control behavior process
	await pause(1.0)
	speed += speedup_amount # If we don't need change over time, i.e. a change_speed call, doing this also works.
	direction += 0.5 if direction_change_reversed else -0.5
	change_speed(speed * 0.75, 2.0, false)
	await pause(2.5)
	change_speed(500.0, 1.0, true)
