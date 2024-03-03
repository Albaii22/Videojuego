extends CharacterBody2D

signal stick_collected
signal apple_collected
signal slime_collected

var speed = 100

var enemy_on_range = false
var enemy_cd = true
var health = 100
var player_alive = true

var player_state

@export var inv: Inv

var bow_equiped = false
var bow_cd = true
var arrow = preload("res://scene/arrow.tscn")
var mouse_loc_from_player = null

func _physics_process(delta):
	slime_attack()
	update_healht()
	player()
	mouse_loc_from_player = get_global_mouse_position() - self.position
	
	if health <= 0:
		player_alive = false # go back to menu
		get_tree().quit()
		health = 0
		print("xd")
		self.queue_free()
		
	var direction = Input.get_vector("left" , "right" , "up" , "down")

	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("q"):
		if bow_equiped:
			bow_equiped = false
			speed = 100
		else:
			bow_equiped = true
			speed = 40
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_click") and bow_equiped and bow_cd:
		bow_cd = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(1.5).timeout
		bow_cd = true
	
	play_anim(direction)
	
func play_anim(dir):
	if !bow_equiped:
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
		
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
	if bow_equiped:
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("n-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
		
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("ne-attack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se-attack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-attack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("nw-attack")
			
func player():
	pass

func collect(item:InvItem):
	inv.insert(item)
	print(item)
	if str(item) == "<Resource#-9223371998955043284>" : #stick
		emit_signal("stick_collected")
	if str(item) == "<Resource#-9223371996270688681>" : #slime
		emit_signal("slime_collected")
	if str(item) == "<Resource#-9223372000012007912>" : #apple
		emit_signal("apple_collected")
	
func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		speed = 50


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		speed = 100


func _on_player_hitbox_body_entered(body):
	if body.has_method("slime"):
		enemy_on_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("slime"):
		enemy_on_range = false
		
func slime_attack():
	if enemy_on_range == true and enemy_cd == true:
		health = health - 25
		enemy_cd = false
		$attack_cd.start()


func _on_attack_cd_timeout():
	enemy_cd = true


func _on_slime_detection_body_entered(body):
	if body.has_method("slime") and bow_equiped:
		speed = 20
	if body.has_method("slime") and !bow_equiped:
		speed = 40


func _on_slime_detection_body_exited(body):
	if body.has_method("slime"):
		print("Xd")

func update_healht():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		

func _on_regn_timer_timeout():
	if health <= 100:
		health = health + 15
		if health > 100:
			health = 100
	if health == 0:
		health = 0
