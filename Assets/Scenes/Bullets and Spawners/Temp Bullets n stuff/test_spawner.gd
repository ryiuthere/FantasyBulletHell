extends AbstractSpawner

@export var secondary_bullet_scene : PackedScene

@export var spawner_angular_velocity := 0.0
@export var cooldown := 0.1
@export var bullets_per_shot := 4
@export var arc_length := TAU

@export var angle_bullet_shot_count := 0
@export var linear_bullet_shot_count := 0
@export var temp_bullet_initial_speed := 100.0

var angle_bullet_angles : Array[float]
var linear_bullet_angles : Array[float]
var reverse_direction_change := false

var linear_instance_angle := 0.0


func _ready() -> void:
	angle_bullet_angles = generate_angles_over_arc(arc_length, bullets_per_shot)
	linear_bullet_angles = generate_angles_over_arc(arc_length, floor(bullets_per_shot*1.2))
	behavior_thread()
	
	

func create_secondary_bullet() -> Bullet:
	var bullet: Bullet = secondary_bullet_scene.instantiate()
	return bullet


func spawn_angle_bullet(initial_velocity: float, initial_direction: float, hue_offset: float, speedup_amount=0.0) -> void:
	var bullet: Bullet = create_bullet()
	bullet.position = position
	bullet.origin = position
	bullet.direction = initial_direction
	bullet.rotation = initial_direction
	bullet.speed = initial_velocity
	bullet.hue_offset = hue_offset
	bullet.speedup_amount = speedup_amount
	bullet.direction_change_reversed = reverse_direction_change
	add_child(bullet)

func spawn_linear_bullet(initial_velocity: float, initial_direction: float, speedup_delay: float, speedup_amount=0.0, av=0.0) -> void:
	var bullet: Bullet = create_secondary_bullet()
	bullet.position = position
	bullet.origin = position
	bullet.direction = initial_direction
	bullet.rotation = initial_direction
	bullet.speed = initial_velocity
	bullet.speedup_amount = speedup_amount
	bullet.speedup_delay = speedup_delay
	bullet.angular_velocity = av
	add_child(bullet)


func fire_angle_bullets() -> void:
	for angle in angle_bullet_angles:
		spawn_angle_bullet(temp_bullet_initial_speed, angle + rotation, 0.2, 100.0)
		spawn_angle_bullet(temp_bullet_initial_speed, angle + rotation, 0.35, 200.0)
		spawn_angle_bullet(temp_bullet_initial_speed, angle + rotation, 0.0)
	reverse_direction_change = not reverse_direction_change


func fire_linear_bullets(speedup_delay: float) -> void:
	for angle in linear_bullet_angles:
		spawn_linear_bullet(temp_bullet_initial_speed*1.6, angle + linear_instance_angle, speedup_delay, 0.0)
		spawn_linear_bullet(temp_bullet_initial_speed*1.6, angle + linear_instance_angle, speedup_delay, 125.0)
		spawn_linear_bullet(temp_bullet_initial_speed*1.6, angle + linear_instance_angle, speedup_delay, 250.0)
		

func set_instance_params(second=false) -> void:
	if not second:
		linear_instance_angle = rotation
	else:
		linear_instance_angle += (linear_bullet_angles[1] - linear_bullet_angles[0])/2.0


func behavior_thread() -> void:
	var tween := create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_callback(fire_angle_bullets).set_delay(cooldown)
	tween.tween_callback(fire_angle_bullets).set_delay(cooldown)
	tween.tween_callback(fire_angle_bullets).set_delay(cooldown)
	tween.tween_callback(fire_angle_bullets).set_delay(cooldown)
	tween.tween_callback(fire_angle_bullets).set_delay(cooldown)
	tween.tween_interval(0.2)
	tween.tween_callback(set_instance_params)
	tween.tween_callback(fire_linear_bullets.bind(1.5 - (cooldown*0.6))).set_delay(cooldown*0.6)
	tween.tween_callback(fire_linear_bullets.bind(1.5 - 2.0*(cooldown*0.6))).set_delay(cooldown*0.6)
	tween.tween_callback(fire_linear_bullets.bind(1.5 - 3.0*(cooldown*0.6))).set_delay(cooldown*0.6)
	tween.tween_interval(cooldown*0.6)
	tween.tween_callback(set_instance_params.bind(true))
	tween.tween_callback(fire_linear_bullets.bind(1.5 - 5.0*(cooldown*0.6))).set_delay(cooldown*0.6)
	tween.tween_callback(fire_linear_bullets.bind(1.5 - 6.0*(cooldown*0.6))).set_delay(cooldown*0.6)
	tween.tween_callback(fire_linear_bullets.bind(1.5 - 7.0*(cooldown*0.6))).set_delay(cooldown*0.6)
	tween.tween_interval(1.0)


func physics_update(delta: float) -> void:
	rotation += spawner_angular_velocity * delta
