extends Area2D

signal hit_taken

var angular_speed = PI
var course = Vector2.RIGHT # The general direction of the ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("disabled_scripts")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Can't steer the ship if you are not at the wheel!
	if is_in_group("disabled_scripts"):
		return
	
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
	if Input.is_action_pressed("move_right"):
		direction = 1
	
	rotation += angular_speed * direction * delta
	course = Vector2.RIGHT.rotated(rotation)


func _on_area_entered(area: Area2D) -> void:
	print("WE HAVE BEEN HIT!")
	hit_taken.emit()
