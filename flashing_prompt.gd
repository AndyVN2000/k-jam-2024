extends Timer

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Make the enemy prompt blink
func _on_timeout() -> void:
	var is_visible = parent.visible
	parent.visible = not is_visible
