extends Area2D

@export var suelo: PackedScene = preload("res://Scene/tierra3.tscn")
@export var suelo2: PackedScene = preload("res://Scene/tierra4.tscn")
@export var generar: PackedScene = preload("res://Scene/masCamino.tscn")

func _on_body_entered(body: Node2D) -> void:
	call_deferred("escenario_infinity")

func escenario_infinity():
		# Variables LOCALES para cada instancia
	var cont_local = 0
	var yY_local = 100
	var tipos_suelo = [suelo, suelo2, suelo, suelo, suelo, suelo]
	
	# Posición inicial basada en este generador
	var posicion_inicial = position.x  # O global_position.x si prefieres
	
	while cont_local < 30:
		var tipo_random = randi() % 6
		var colSuelo = tipos_suelo[tipo_random].instantiate()
		
		# IMPORTANTE: Añadir al mismo padre que este generador
		get_parent().add_child(colSuelo)
		
		# Posición RELATIVA a este generador
		colSuelo.position = Vector2(posicion_inicial + yY_local, 0)
		yY_local += 100
		cont_local += 1
	
	# Crear el siguiente generador
	var colGenerador = generar.instantiate()
	get_parent().add_child(colGenerador)
	colGenerador.position = Vector2(posicion_inicial + yY_local, 0)
