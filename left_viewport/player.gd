extends CharacterBody2D

signal cannon_ball_pickup
signal cannon_ball_drop

signal can_steer_wheel

var speed = 300.0
var holding_cannon_ball: bool = false


func _physics_process(delta: float) -> void:
	# Controls over player character disabled while steering ship
	if is_in_group("disabled_scripts"):
		return
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta

	move_and_slide()


func _on_cannon_ball_resource_body_entered(body: Node2D) -> void:
	# Bail out fast if already holding cannon ball
	if holding_cannon_ball:
		return
	holding_cannon_ball = true
	cannon_ball_pickup.emit()


func _on_cannon_area_body_entered(body: Node2D) -> void:
	# Bail out fast if not holding a cannon ball
	if not holding_cannon_ball:
		return
	holding_cannon_ball = false
	print("FIRE AT WILL")
	# TODO: Update UI to indicate cannon ball is no longer held
	cannon_ball_drop.emit()
	# TODO: Harm some enemy ships
	
	pass # Replace with function body.


func _on_wheel_area_body_entered(body: Node2D) -> void:
	can_steer_wheel.emit()
	pass # Replace with function body.
