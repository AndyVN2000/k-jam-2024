extends Area2D

@onready var ship = get_node("../Ship")
var speed = 25
var course: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = ship.course * -1
	if direction != Vector2.ZERO:
		course = direction
	position += course * delta * speed
