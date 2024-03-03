extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_completed = false
var stick = 0
var apples = 0
var slime = 0

func _process(delta):
	if quest1_active:
		if stick == 6 and apples == 7 and slime == 6:
			print("completed")
			quest1_active = false
			quest1_completed = true
			play_finish_quest_anim()
			get_tree().change_scene_to_file("res://scene/finish.tscn")
	#if quest2

func quest1_chat():
	$quest1_ui.visible = true
	
func next_quest():
	if !quest1_completed:
		quest1_chat()
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false


func _on_aceptar_botton_pressed():
	$quest1_ui.visible = false
	$advice.visible = true
	await get_tree().create_timer(2).timeout
	$advice.visible = false
	quest1_active = true
	stick = 0
	apples = 0
	slime = 0
	emit_signal("quest_menu_closed")


func _on_cancelar_botton_2_pressed():
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")

func stick_collected():
	stick += 1
	print("stick for quest")

func apple_collected():
	apples += 1
	print("apple for quest")

func slime_collected():
	slime += 1
	print("slime for quest")

func play_finish_quest_anim():
	$quest_finished.visible = true
	await get_tree().create_timer(3).timeout
	$quest_finished.visible = false
