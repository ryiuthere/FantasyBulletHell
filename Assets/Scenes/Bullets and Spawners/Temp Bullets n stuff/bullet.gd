class_name Bullet
extends Area2D

@onready var inner_sprite = $InnerSprite
@onready var outer_sprite = $OuterSprite

var origin_position : Vector2
var velocity := 0.0
var direction := 0.0


func _ready() -> void:
	Globals.bullet_count += 1


func clear_if_exited(max_distance: float) -> void:
	if position.distance_to(origin_position) >= max_distance:
		queue_free()
		Globals.bullet_count -= 1


func move(delta: float) -> void:
	position += Vector2(
			delta * velocity * cos(direction),
			delta * velocity * sin(direction)
	)


func _physics_process(delta: float) -> void:
	move(delta)
	clear_if_exited(2000.0)
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage()
		
