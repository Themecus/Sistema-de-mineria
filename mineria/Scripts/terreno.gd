extends Node2D

@export var bloque_scene: PackedScene = preload("res://Scene/tierra.tscn")
@export var deep_suelo = 2  # Bloques verticales
@export var largo_suelo =100    # Bloques horizontales
@export var separacion_x = 130   # Espacio horizontal entre bloques
@export var separacion_y = 130     # Espacio vertical entre bloques
@export var offset_inicial = Vector2(100, 100)  # Posición inicial

func _ready():
	generar_cuadricula()

func generar_cuadricula():
	for fila in range(deep_suelo):#ve esto como una matriz para su fabricacion
		for columna in range(largo_suelo):
			# Crear nuevo bloque
			var nuevo_bloque = bloque_scene.instantiate()#instanceamos el nuevo bloque a colocar
			# Calcular posición
			var pos_x = offset_inicial.x + (columna * separacion_x)#calculamos la posicion del objeto
			var pos_y = offset_inicial.y + (fila * separacion_y)
			nuevo_bloque.position = Vector2(pos_x, pos_y)#le damos esa posicion
			add_child(nuevo_bloque)# Añadir al escenario
	


	
