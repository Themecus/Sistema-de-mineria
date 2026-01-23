extends Area2D

@onready var colision = $CollisionShape2D
@onready var jugador = get_parent()  # Asumiendo que la pala es hijo del jugador, sacaremos la informacion de el
@export var distancia_maxima = 100  # Máxima distancia del jugador y la pala
@export var suavizado = 10.0  # Suavizado del movimiento

var objetivo_posicion = Vector2.ZERO

func _ready():
	visible = false
	colision.disabled = true

func _process(delta):
	controles(delta)
	
	# si esta activado, comenzara la rotacion del raton
	if visible:
		seguir_raton(delta)

func controles(delta):
	if Input.is_action_pressed("Minar"):
		visible = true
		colision.disabled = false
	else:
		visible = false
		colision.disabled = true

func seguir_raton(delta):
	# Obtener posición global del ratón
	var mouse_pos = get_global_mouse_position()
	var jugador_pos = jugador.global_position
	

	var direccion = (mouse_pos - jugador_pos).normalized()#tomalo como la distancia entre el raton y el jugador
	#.normalized() mantiene dirección
	

	var distancia = min(jugador_pos.distance_to(mouse_pos), distancia_maxima)# Limitar distancia máxima de la pala y el jugador
	
	objetivo_posicion = jugador_pos + (direccion * distancia)#permite anclar la posicion de la pala y que no salga volando
	
	# Suavizar movimiento (interpolación)
	global_position = global_position.lerp(objetivo_posicion, suavizado * delta)
	
	# Rotar la pala hacia el ratón
	rotar_hacia_raton()

func rotar_hacia_raton():
	var mouse_pos = get_global_mouse_position()
	var direccion = mouse_pos - global_position
	rotation = direccion.angle()# con el angle obtnemos los radianes del vector, osea, ayuda a que no se quede estatico y gire versatilmente
