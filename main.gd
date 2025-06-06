extends Node

@onready var rock_spawn_location = get_node("RockPath")
@onready var ship = get_node("SeaMapView/SubViewport/Ship")
@onready var player = get_node("ShipDeckView/SubViewport/ShipDeckTileMap/Player")
@onready var health = get_node("ShipHealth")
@export var rock_scene: PackedScene
@export var game_over_scene: PackedScene
var score
var angle_width = deg_to_rad(60)
var can_steer_wheel = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RockTimer.start()
	$Timer.start()
	player.can_steer_wheel.connect(wheel)
	player.cannot_steer_wheel.connect(no_wheel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_steer_wheel and Input.is_action_just_released("steer_ship"):
		
		if player.is_in_group("disabled_scripts"):
			player.remove_from_group("disabled_scripts")
			ship.add_to_group("disabled_scripts")
		else:
			player.add_to_group("disabled_scripts")
			ship.remove_from_group("disabled_scripts")
		

func wheel():
	can_steer_wheel = true

func no_wheel():
	can_steer_wheel = false

# Translates global positions to the coordinate system of the sea map view
func global_to_viewport_local(global_position: Vector2) -> Vector2:
	# Subtract the reference position (manual origin) from the global position
	var local_position = global_position - $SeaMapView.position
	
	# Return the local position
	return local_position

# Should spawn a rock on the sea map
func _on_rock_timer_timeout() -> void:
	var rock = rock_scene.instantiate()
	rock.position = global_to_viewport_local(get_random_point_on_rock_path())
	rock.visible = true
	get_node("SeaMapView/SubViewport").add_child(rock)


func get_random_point_on_rock_path():
	var rock_spawn_location = $RockPath/RockSpawnLocation
	rock_spawn_location.progress_ratio = randf()
	return rock_spawn_location.position

# NOTE: get_random_point_in_front_of_ship along with get_points_within_angle are fancy methods of
# 	spawning rocks along the way. Does not work. 
# FIXME: Crashes when rotating the ship. `get_points_within_angle` fails to collect points. Leading
# 	to an empty `spawn_points` array
func get_random_point_in_front_of_ship():
	var spawn_points = get_points_within_angle(ship.position, ship.course, angle_width)
	var spawn_point = spawn_points.pick_random()
	return spawn_point

func get_points_within_angle(center: Vector2, direction: Vector2, angle_width: float) -> Array:
	var points_within_angle = []
	var curve = rock_spawn_location.curve

	# Precompute cosine of the maximum angle
	var cos_max_angle = cos(angle_width / 2)

	for i in range(curve.get_point_count()):
		var point = curve.get_point_position(i)
		var vector_to_point = (point - center).normalized()

		# Dot product between direction vector and vector to point
		var dot = direction.dot(vector_to_point)

		# Check if the point lies within the angle range
		if dot >= cos_max_angle:
			points_within_angle.append(point)
	return points_within_angle


func _on_ship_health_game_over() -> void:
	print("GAME OVER")
	var children = get_children()
	for child in children:
		child.queue_free()
	
	var game_over = game_over_scene.instantiate()
	game_over.text = game_over.text + "\n You survived for " + str(time) + " seconds"
	
	add_child(game_over)
	
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	time += 1
