extends Node2D

@onready var ship = get_node("../../../SeaMapView/SubViewport/Ship")
@onready var hole_cells: TileMapLayer = get_node("LayerHolder/HoleLayer")
@export var hole_scene: PackedScene

const top_left = Vector2(8, 12)
const bottom_right = Vector2(29, 20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.connect("hit_taken", _create_hole)
	SignalBus.on_enemy_attack.connect(_create_hole)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Create a hole on the hull
func _create_hole():
	var coordinate = get_random_tile_coordinate()
	var hole = hole_scene.instantiate()
	hole.position = coordinate
	hole.visible = true
	call_deferred("add_child", hole)


func get_random_tile_coordinate():
	# Get a random position within the defined area
	var x = (randi() % int(bottom_right.x - top_left.x)) + top_left.x
	var y = (randi() % int(bottom_right.y - top_left.y)) + top_left.y
	
	var cell = hole_cells.map_to_local(Vector2(x, y))
	return cell
