extends CharacterBody2D

signal cannon_ball_pickup
signal cannon_ball_drop
signal plank_pickup
signal plank_drop
signal can_steer_wheel
signal cannot_steer_wheel

@onready var smoke = get_node("../CannonArea/CannonSmoke")

var speed = 125.0
var holding_cannon_ball: bool = false
var holding_plank: bool = false
@export var hole_scene: PackedScene

func _ready() -> void:
	SignalBus.on_repair.connect(_on_repair)
	

func _physics_process(delta: float) -> void:
	# Controls over player character disabled while steering ship
	if is_in_group("disabled_scripts"):
		return
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.play()
		velocity.x -= 1
		velocity.y += 1
	elif Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.play()
		velocity.x += 1
		velocity.y += 1
	elif Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.play()
		velocity.x -= 1
		velocity.y -= 1
	elif Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.play()
		velocity.x += 1
		velocity.y -= 1
	elif Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.play()
	elif Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.play()
		velocity.x -= 1
	elif Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.animation = "walk_down"
		$AnimatedSprite2D.play()
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.animation = "walk_up"
		$AnimatedSprite2D.play()
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
	cannon_ball_drop.emit()
	SignalBus.on_return_fire.emit()
	
	print(smoke)
	smoke.animation = "smoke"
	smoke.play()
	
	$CannonFire.play()

func _on_wheel_area_body_entered(body: Node2D) -> void:
	$WheelPrompt.visible = true
	can_steer_wheel.emit()


func _on_wheel_area_body_exited(body: Node2D) -> void:
	$WheelPrompt.visible = false
	cannot_steer_wheel.emit()


func _on_planks_area_body_entered(body: Node2D) -> void:
	# Bail out fast if already holding plank
	if holding_plank:
		return
	holding_plank = true
	plank_pickup.emit()


func _on_repair() -> void:
	# Bail out fast if not holding a plank
	if not holding_plank:
		return
	holding_plank = false
	plank_drop.emit()
	print("Emitted plank drop")
	# TODO: Should remove hole
	# TODO: Should also heal the ship
