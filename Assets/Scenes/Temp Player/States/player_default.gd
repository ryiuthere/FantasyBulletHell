extends State
class_name PlayerDefault

@export var RUN_SPEED: float
@export var FOCUS_SPEED: float
@export var player: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var hurtbox_sprite: Sprite2D

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
		sprite.modulate.a = 0.65
		hurtbox_sprite.visible = true
	else:
		sprite.modulate.a = 1.0
		hurtbox_sprite.visible = false
		
func move(speed: float, axis: Vector2, delta: float) -> void:
	player.move_and_collide(Vector2(speed * axis.x * delta, 0.0))
	player.move_and_collide(Vector2(0.0, speed * axis.y * delta))

func update(_delta: float) -> void:
	var movement_axis := get_movement_axis()
	update_sprite(movement_axis)
	
func physics_update(delta: float):
	var movement_axis := get_movement_axis()
	
	if Input.is_action_pressed("shift"):
		focused = true
		move(FOCUS_SPEED, movement_axis, delta)
	else:
		focused = false
		move(RUN_SPEED, movement_axis, delta)
