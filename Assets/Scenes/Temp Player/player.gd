extends CharacterBody2D


func damage() -> void:
	print("you suck")


func _process(_delta: float) -> void:
	$DebugFPS.text = str(Engine.get_frames_per_second())
	$DebugBulletCount.text = str(Globals.bullet_count)


func _physics_process(_delta: float) -> void:
	Globals.player_location = position
