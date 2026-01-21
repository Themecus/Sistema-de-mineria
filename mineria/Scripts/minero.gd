extends CharacterBody2D
const speed = 400.0


func _process(delta):
	controles(delta)

func controles(delta):
	if Input.is_action_pressed("Derecha") || Input.is_action_pressed("Izquierda") || Input.is_action_pressed("Arriba")|| Input.is_action_pressed("Abajo"):
		if Input.is_action_pressed("Derecha"):
			velocity.x= speed
		if Input.is_action_pressed("Izquierda"):
			velocity.x= -speed
		if Input.is_action_pressed("Arriba"):
			velocity.y= -speed
		if Input.is_action_pressed("Abajo"):
			velocity.y= speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	velocity = velocity.normalized() * speed  # Normalizar para movimiento diagonal
	set_velocity(velocity)
	move_and_slide()
	
