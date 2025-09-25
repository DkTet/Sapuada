extends CanvasLayer

func _on_pause_btn_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
