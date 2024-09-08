extends State
class_name PlayerDefault

@export var RUN_SPEED: float
@export var FOCUS_SPEED: float
@export var player: CharacterBody2D
@export var sprite: AnimatedSprite2D

var facing := "down"
var focused := false #TODO: Can add focus as its own state later if it gets special properties

func get_movement_axis() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func update_sprite(movement: Vector2) -> void: 
#TODO: Can move this to an autoload SpriteHandler script if other objects and states need to use it too
	if movement.is_zero_approx():
		match facing:
			"left":
				sprite.animation = "idle_left"
			"down":
				sprite.animation = "idle_down"
			"up":
				sprite.animation = "idle_up"
			"right":
				sprite.animation = "idle_right"
	else:
		if not is_zero_approx(movement.y):
			sprite.animation = "move_down" if movement.y > 0 else "move_up"
			facing = "down" if movement.y > 0 else "up"
		else:
			sprite.animation = "move_right" if movement.x > 0 else "move_left"
			facing = "right" if movement.x > 0 else "left"
			
	sprite.play()
	
	if focused:
		sprite.modulate.a = 0.8
	else:
		sprite.modulate.a = 1.0

func update(_delta: float) -> void:
	var movement_axis := get_movement_axis()
	update_sprite(movement_axis)
	
func physics_update(delta: float):
	var movement_axis := get_movement_axis()
	
	if Input.is_action_pressed("shift"):
		focused = true
		player.move_and_collide(movement_axis * FOCUS_SPEED * delta)
	else:
		focused = false
		player.move_and_collide(movement_axis * RUN_SPEED * delta)
