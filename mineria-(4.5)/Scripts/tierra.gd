extends StaticBody2D

var puntos_vida=5   
var minando=false
var velocida_minado=3#el punto para accionar la accion
var intervalos=0#el intervalo debe llegar a 3 para ejercer la accion
@onready var pala=$"."

func _process(delta):
	accion(delta)

func accion(delta):
	if(minando):#si esta minando entra aqui
		intervalos+=delta*16#se ira sumando con delta, siendo delta el tiempo transcurrido tras el ultimo frame, es decir, cada segundo tomalo como un frame
		#se ira sumando en base a ese tiempo de forma lenta y no instantanea
		if intervalos>=velocida_minado:#cuando este listo se resetea, para que no se ahaga al instante
			intervalos=0
			puntos_vida=puntos_vida-2#se va restando un punto de vida al bloque
			print("puntos de vida= ", puntos_vida)
		if puntos_vida<=0:# al llegar a cero mata al bloque
			queue_free()
		
			
func _on_area_2d_area_entered(area: Area2D):
	if area.name=="Pala":
		minando=true

func _on_area_2d_area_exited(area: Area2D):
	if area.name=="Pala":
		minando=false
