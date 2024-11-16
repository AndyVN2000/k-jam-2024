extends Timer



func _on_timeout() -> void:
	SignalBus.on_enemy_attack.emit()
