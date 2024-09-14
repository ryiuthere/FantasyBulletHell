class_name BulletSpawner
extends Node2D

@export var bullet_scene: PackedScene


#NOTE: these will probably go in a resource
# or we could just hard code each pattern cause each pattern should kinda be different
var max_duration: float
var cooldown_time: float
var bullets_per_ring: int
var initial_velocity: float
var spawner_rotate_speed: float

var active := true
var time_elapsed := 0.0
var time_since_last_shot := 0.0

signal lifetime_expired


func _ready() -> void: # hard coding params for testing
	cooldown_time = 0.15
	bullets_per_ring = 25
	initial_velocity = 350.0
	spawner_rotate_speed = 1.2

func fire() -> void:
	for i in range(bullets_per_ring):
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.origin_position = position
		bullet.position = position
		bullet.direction = TAU / float(max(bullets_per_ring, 1)) * i + rotation
		bullet.velocity = initial_velocity
		bullet.move(-5.5) # HACK very cursed
		add_child(bullet)


func update() -> void:
	if not active:
		return
		
	if max_duration:
		if time_elapsed > max_duration:
			lifetime_expired.emit()
			active = false
			return
	
	if time_since_last_shot >= cooldown_time:
		time_since_last_shot -= cooldown_time
		fire()


func _physics_process(delta: float) -> void:
	update()
	time_elapsed += delta
	time_since_last_shot += delta
	
	rotation += spawner_rotate_speed * delta
	
