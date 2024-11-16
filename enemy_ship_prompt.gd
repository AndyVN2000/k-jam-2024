extends Label

signal defeated

var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_return_fire.connect(_on_return_fire)
	$EnemyShipTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Enemy ship is spawned
func _on_enemy_ship_timer_timeout() -> void:
	health = 3
	$FlashingPrompt.start()
	$EnemyShipTimer.stop()
	$AttackTimer.start()


func _on_return_fire():
	health -= 1
	# Enemy has been defeated
	if health <= 0:
		$FlashingPrompt.stop()
		$AttackTimer.stop()
		$EnemyShipTimer.start()
