extends CanvasLayer
@onready var sound = $ButtonClick

func _on_pause_btn_pressed() -> void:
	sound.play()
	await get_tree().create_timer(0.9).timeout
	get_tree().paused = false
	queue_free()


func _on_quit_btn_pressed() -> void:
	sound.play()
	await get_tree().create_timer(0.9).timeout
	get_tree().quit()
