extends CanvasLayer


func _ready() -> void:
	
	visible=false 
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_pause_button_pressed()
		
func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()

func on_continue_button_pressed():
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func on_exit_button_pressed():
	get_tree().quit()
