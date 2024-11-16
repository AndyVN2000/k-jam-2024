extends Container

@onready var player = get_node("../ShipDeckView/SubViewport/ShipDeckTileMap/CharacterBody2D")
var cannon_ball_image: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Listen to signals when player picks up or drops an item
	player.cannon_ball_pickup.connect(_on_cannon_ball_pickup)
	player.cannon_ball_drop.connect(_on_cannon_ball_drop)
	
	# Prepare the item images
	cannon_ball_image = TextureRect.new()
	var image = preload("res://gui/cannon_ball_v1.png")
	cannon_ball_image.texture = image
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_cannon_ball_pickup():
	add_child(cannon_ball_image)

func _on_cannon_ball_drop():
	remove_child(cannon_ball_image)
