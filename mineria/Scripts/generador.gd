extends Node2D

@export var cuevaA: PackedScene = preload("res://Scene/cuevaA.tscn")
@export var cuevaB: PackedScene = preload("res://Scene/cuevaB.tscn")

func _ready() -> void:
	colocador_automatico()

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
	
