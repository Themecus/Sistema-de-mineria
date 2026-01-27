extends Node2D

@export var bloque_scene: PackedScene = preload("res://Scene/tierra.tscn")
@export var bloque_scene2: PackedScene = preload("res://Scene/tierra2.tscn")
@export var deep_suelo = 25
@export var largo_suelo = 25
@export var separacion_x = 130
@export var separacion_y = 130
@export var offset_inicial = Vector2(100, 100)

# Probabilidades
@export var prob_centro_max: float = 0.9    # 90% en centro
@export var prob_borde_min: float = 0.3     # 30% en bordes
@export var zona_llena_centro: float = 0.1  # 20% del centro SIEMPRE lleno

func _ready():
	randomize()
	#bordes()
	generar_cuadricula()

func bordes():
	var random = RandomNumberGenerator.new()
	random.randomize()
	# Calcular dimensiones totales
	var ancho_total = (largo_suelo - 1) * separacion_x
	var alto_total = (deep_suelo - 1) * separacion_y
	
	# Crear marco indestructible (25x25)
	
	for col in range(largo_suelo):
		var nuevo_bloque = bloque_scene2.instantiate()
		var pos_x = offset_inicial.x + (col * separacion_x)
		var pos_y = offset_inicial.y
		nuevo_bloque.position = Vector2(pos_x, pos_y)
		var numeral=randi_range(0, 1)  #con esto decimos los numeros entre y entre que saldran
		if numeral==0:
			add_child(nuevo_bloque)
	
	for col in range(largo_suelo):
		var nuevo_bloque = bloque_scene2.instantiate()
		var pos_x = offset_inicial.x + (col * separacion_x)
		var pos_y = offset_inicial.y + ((deep_suelo - 1) * separacion_y)
		nuevo_bloque.position = Vector2(pos_x, pos_y)
		var numeral=randi_range(0, 1)  #con esto decimos los numeros entre y entre que saldran
		if numeral==0:
			add_child(nuevo_bloque)
	
	for fila in range(1, deep_suelo - 1):  # Evitar repetir esquinas
		var nuevo_bloque = bloque_scene2.instantiate()
		var pos_x = offset_inicial.x
		var pos_y = offset_inicial.y + (fila * separacion_y)
		nuevo_bloque.position = Vector2(pos_x, pos_y)
		var numeral=randi_range(0, 1)  #con esto decimos los numeros entre y entre que saldran
		if numeral==0:
			add_child(nuevo_bloque)
	
	for fila in range(1, deep_suelo - 1):  # Evitar repetir esquinas
		var nuevo_bloque = bloque_scene2.instantiate()
		var pos_x = offset_inicial.x + ((largo_suelo - 1) * separacion_x)
		var pos_y = offset_inicial.y + (fila * separacion_y)
		nuevo_bloque.position = Vector2(pos_x, pos_y)
		var numeral=randi_range(0, 1)  #con esto decimos los numeros entre y entre que saldran
		if numeral==0:
			add_child(nuevo_bloque)

func generar_cuadricula():
	# Calcular centro de la cuadrícula
	var centro_x = largo_suelo / 2.0
	var centro_y = deep_suelo / 2.0
	
	for fila in range(deep_suelo):
		for columna in range(largo_suelo):
			# Calcular distancia normalizada al centro (0 a 1)
			var dist_x = abs(columna - centro_x) / centro_x
			var dist_y = abs(fila - centro_y) / centro_y
			var distancia_al_centro = max(dist_x, dist_y)  # Usamos la mayor distancia
			
			# INVERTIDO: Más probabilidad cerca del centro
			var probabilidad = lerp(prob_centro_max, prob_borde_min, distancia_al_centro)
			
			# Zona central siempre llena
			var en_centro_absoluto = (dist_x < zona_llena_centro and dist_y < zona_llena_centro)
			
			# Decidir si colocar bloque
			if en_centro_absoluto or randf() < probabilidad:
				var nuevo_bloque = bloque_scene.instantiate()
				crear_bloque(fila, columna, nuevo_bloque)
			else:
				var nuevo_bloque2 = bloque_scene2.instantiate()
				crear_bloque(fila, columna, nuevo_bloque2)#creamos un blouque indestrutible

func crear_bloque(fila, columna, nuevo_bloque):
	var pos_x = offset_inicial.x + (columna * separacion_x)
	var pos_y = offset_inicial.y + (fila * separacion_y)
	nuevo_bloque.position = Vector2(pos_x, pos_y)
	add_child(nuevo_bloque)
