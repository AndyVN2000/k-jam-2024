extends Container

@onready var player = get_node("../ShipDeckView/SubViewport/ShipDeckTileMap/CharacterBody2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.cannon_ball_pickup.connect(_on_cannon_ball_pickup)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_cannon_ball_pickup():
	var cannon_ball = TextureRect.new()
	var image = preload("res://gui/cannon_ball_v1.png")
	cannon_ball.texture = image
	cannon_ball.z_index = 5
	add_child(cannon_ball)
	print(get_child_count())
