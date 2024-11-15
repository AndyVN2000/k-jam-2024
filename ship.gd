extends Area2D

var angular_speed = PI
var course = Vector2.ZERO # The general direction of the ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	
	rotation += angular_speed * direction * delta
	
	course = Vector2.RIGHT.rotated(rotation)
	
	
