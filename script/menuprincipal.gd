extends Control




func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/world.tscn")


func _on_button_3_pressed():
	get_tree().quit()