extends Container

@onready var player = get_node("../ShipDeckView/SubViewport/ShipDeckTileMap/Player")
var plank_image: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Listen to signals when player picks up or drops an item
	player.plank_pickup.connect(_on_plank_pickup)
	player.plank_drop.connect(_on_plank_drop)
	
	# Prepare the item images
	plank_image = TextureRect.new()
	var image = preload("res://gui/plank_v1.png")
	plank_image.texture = image
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_plank_pickup():
	add_child(plank_image)

func _on_plank_drop():
	remove_child(plank_image)
