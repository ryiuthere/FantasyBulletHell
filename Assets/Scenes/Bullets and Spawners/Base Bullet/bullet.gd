class_name Bullet
extends Area2D

var speed : float
var direction : float

var origin : Vector2
var angular_velocity : float


func setup() -> void:
	pass


func _ready() -> void:
	Globals.bullet_count += 1
	setup()
	behavior_thread()


func clear_if_exited(max_distance: float) -> void:
	# This doesn't actually free the bullets, just hides them and stops processing
	if position.distance_to(origin) >= max_distance:
		set_process(false)
		set_physics_process(false)
		hide()
		Globals.bullet_count -= 1


func create_physics_tween() -> Tween:
	## Creates a tween that runs on physics ticks and is bound to this bullet, meaning it will be killed
	## if the bullet is freed.
	return self.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)


func change_speed(value: float, term: float, relative: bool, trans:Tween.TransitionType=Tween.TRANS_LINEAR, ease_type:Tween.EaseType=Tween.EASE_IN_OUT) -> void:
	var tween := create_physics_tween().set_trans(trans).set_ease(ease_type)
	var target_value : float
	if relative:
		target_value = speed + value
	else:
		target_value = value
	tween.tween_property(self, "speed", target_value, term)
	

func change_direction(value: float, term: float, relative: bool, trans:Tween.TransitionType=Tween.TRANS_LINEAR, ease_type:Tween.EaseType=Tween.EASE_IN_OUT) -> void:
	var tween := create_physics_tween().set_trans(trans).set_ease(ease_type)
	var target_value : float
	if relative:
		target_value = direction + value
	else:
		target_value = value
	tween.tween_property(self, "direction", target_value, term)
	

func change_angular_velocity(value: float, term: float, relative: bool, trans:Tween.TransitionType=Tween.TRANS_LINEAR, ease_type:Tween.EaseType=Tween.EASE_IN_OUT) -> void:
	var tween := create_physics_tween().set_trans(trans).set_ease(ease_type)
	var target_value : float
	if relative:
		target_value = angular_velocity + value
	else:
		target_value = value
	tween.tween_property(self, "angular_velocity", target_value, term)


func get_radial_movement_vector(delta: float) -> Vector2:
	return speed * Vector2(cos(direction), sin(direction) * -1.0) * delta
	

func get_tangential_movement_vector(delta: float) -> Vector2:
	return (position - ((position - origin).rotated(angular_velocity * delta) + origin))
	

func adjusted_tangential_movement_for_overshooting(unadjusted_position: Vector2, d_before_moved: float) -> Vector2:
	# Because the tangential movement vector method doesn't accurately model UCM, this method 
	# compensates by setting the bullet's distance to origin back to what it was before movement.
	var overshoot := unadjusted_position.distance_to(origin) - d_before_moved
	return unadjusted_position.direction_to(origin) * overshoot


func move(delta: float) -> void:
	var d_before_moved := position.distance_to(origin)
	var movement := get_tangential_movement_vector(delta)
	movement += adjusted_tangential_movement_for_overshooting(movement + position, d_before_moved)
	direction += angular_velocity * delta
	movement += get_radial_movement_vector(delta)
	position += movement
	rotation = atan2(movement.y, movement.x)
	

func pause(term: float) -> void:
	await get_tree().create_timer(term, true, true).timeout
	

func behavior_thread() -> void:
	pass


func _process(_delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	move(delta)
	clear_if_exited(2500.0)
