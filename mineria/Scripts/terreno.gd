extends Node2D

@export var bloque_scene: PackedScene = preload("res://Scene/tierra.tscn")
@export var bloque_scene2: PackedScene = preload("res://Scene/tierra2.tscn")
@export var cuevaA: PackedScene = preload("res://Scene/cuevaA.tscn")
@export var cuevaB: PackedScene = preload("res://Scene/cuevaB.tscn")
@export var suelo: PackedScene = preload("res://Scene/tierra3.tscn")
@export var suelo2: PackedScene = preload("res://Scene/tierra4.tscn")
@export var generar: PackedScene = preload("res://Scene/masCamino.tscn")
@export var deep_suelo = 25
@export var largo_suelo = 25
@export var separacion_x = 130
@export var separacion_y = 130
@export var offset_inicial = Vector2(100, 100)
# Probabilidades
@export var prob_centro_max: float = 0.9    # 90% en centro
@export var prob_borde_min: float = 0.3     # 30% en bordes
@export var zona_llena_centro: float = 0.1  # 20% del centro SIEMPRE lleno
var cont=0
func _ready():
	randomize()
	#bordes()
	#generar_cuadricula()
	#colocador()
	#colocador_automatico()
	escenario_infinity()

func escenario_infinity():
	var yY = 100
	var tipos_suelo = [suelo, suelo2]  # Array con ambas escenas
	
	while cont < 30:
		# Selección 50/50 aleatoria
		var tipo_random = randi() % 2  # 0 o 1
		var colSuelo = tipos_suelo[tipo_random].instantiate()
		
		add_child(colSuelo)
		colSuelo.position = Vector2(100 + yY, 0)
		yY += 100
		cont += 1
	
	var colGenerador = generar.instantiate()
	add_child(colGenerador)
	colGenerador.position = Vector2(yY, 0)
	
func colocador_automatico():
	var total_cuevas = 3
	var cuevas = []
	var conexiones_activas = []  # Array de markers disponibles
	
	# Cueva inicial
	var cueva1 = cuevaA.instantiate()
	cueva1.position = Vector2.ZERO
	add_child(cueva1)
	cuevas.append(cueva1)
	
	# Añadir sus 4 markers como conexiones
	conexiones_activas.append_array([
		cueva1.get_node("Arriba"),
		cueva1.get_node("Abajo"),
		cueva1.get_node("Izquierda"),
		cueva1.get_node("Derecha")
	])
	
	while cuevas.size() < total_cuevas and conexiones_activas.size() > 0:
		# 1. Elegir conexión aleatoria
		var idx_conexion = randi() % conexiones_activas.size()
		var marker_salida = conexiones_activas[idx_conexion]
		
		# 2. Determinar dirección opuesta
		var direccion_salida = marker_salida.name
		var direccion_entrada = ""
		
		match direccion_salida:
			"Arriba": direccion_entrada = "Abajo"
			"Abajo": direccion_entrada = "Arriba"
			"Izquierda": direccion_entrada = "Derecha"
			"Derecha": direccion_entrada = "Izquierda"
		
		# 3. Elegir tipo de cueva aleatoria
		var nueva_cueva = cuevaA.instantiate() if randi() % 2 == 0 else cuevaB.instantiate()
		
		# 4. Verificar que tenga el marker de entrada necesario
		if nueva_cueva.has_node(direccion_entrada):
			add_child(nueva_cueva)
			
			# 5. Conectar
			var marker_entrada = nueva_cueva.get_node(direccion_entrada)
			var offset = marker_salida.global_position - marker_entrada.global_position
			nueva_cueva.global_position += offset
			
			cuevas.append(nueva_cueva)
			
			# 6. Añadir NUEVAS conexiones (excepto la usada)
			for dir in ["Arriba", "Abajo", "Izquierda", "Derecha"]:
				if dir != direccion_entrada:  # No añadir la usada
					var marker = nueva_cueva.get_node(dir)
					if marker:
						conexiones_activas.append(marker)
		
		# 7. Remover conexión usada
		conexiones_activas.remove_at(idx_conexion)
	

func colocador():
	var contador=0
	var mi_lista = []
	var mi_lista2 = []
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var cueva1 = cuevaA.instantiate()
	mi_lista.append(cueva1.get_node("Arriba"))
	mi_lista.append(cueva1.get_node("Abajo"))
	mi_lista.append(cueva1.get_node("Izquierda"))
	mi_lista.append(cueva1.get_node("Derecha"))
	var numeral=randi_range(0, 3) 
	var numeral2=0
	var cueva2 = cuevaB.instantiate()
	mi_lista2.append(cueva2.get_node("Arriba"))
	mi_lista2.append(cueva2.get_node("Abajo"))
	mi_lista2.append(cueva2.get_node("Izquierda"))
	mi_lista2.append(cueva2.get_node("Derecha"))
	
	if mi_lista[numeral]==cueva1.get_node("Arriba"):
		numeral2=1
	if mi_lista[numeral]==cueva1.get_node("Abajo"):
		numeral2=0
	if mi_lista[numeral]==cueva1.get_node("Izquierda"):
		numeral2=3
	if mi_lista[numeral]==cueva1.get_node("Derecha"):
		numeral2=2
	
	cueva1 = cuevaA.instantiate()
	add_child(cueva1)
	
	# Obtener marker de SALIDA de cueva1
	var mark_salida = mi_lista[numeral]  # Debes crear este nodo
	
	cueva2 = cuevaB.instantiate()
	add_child(cueva2)
	
	# Obtener marker de ENTRADA de cueva2  
	var mark_entrada = mi_lista2[numeral2]  # Debes crear este nodo
	
	# Calcular offset para conectar entrada con salida
	var offset = mark_salida.global_position - mark_entrada.global_position
	cueva2.global_position += offset


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
