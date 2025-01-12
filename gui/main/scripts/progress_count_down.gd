extends TextureProgressBar


func _process(delta: float):
	value += delta
	if value > max_value:
		get_parent().hide()
