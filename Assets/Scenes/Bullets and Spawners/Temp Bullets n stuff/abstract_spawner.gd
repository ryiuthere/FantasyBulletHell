extends Node2D
class_name AbstractSpawner

@export var bullet_scene: PackedScene

var time_elapsed := 0.0
var time_since_last_shot := 0.0


func create_bullet() -> Bullet:
	var bullet: Bullet = bullet_scene.instantiate()
	return bullet


## Generates num_points angles across arc_length. Will return netative angle values.
## If sum of spacing angles exceeds TAU-spacing, spacing will be reduced to compensate for the distance 
## between the first and last points, preventing unwanted stacking.
func generate_angles_over_arc(arc_length: float, num_points: int) -> Array[float]:
	if num_points <= 0:
		return []
	elif num_points == 1:
		return [0.0]
		
	arc_length = minf(TAU, absf(arc_length))
	var spacing := arc_length / float(num_points - 1)
	
	if (TAU - arc_length) < spacing:
		spacing = arc_length / float(num_points)
		
	var angles: Array[float]
	
	for i in range(num_points):
		var angle := spacing * float(i)
		angles.push_back(angle - (arc_length / 2.0))
	
	return angles
	

func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
	

func _process(delta: float) -> void:
	update(delta)


func _physics_process(delta: float) -> void:
	physics_update(delta)
	time_elapsed += delta
	time_since_last_shot += delta
