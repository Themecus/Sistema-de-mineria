extends Area2D
@onready var pala=$"."
@onready var colision=$CollisionShape2D
func _ready():
	pala.visible = false
	colision.disabled = true


func _process(delta):
	controles(delta)
	
func controles(delta):
	if Input.is_action_pressed("Minar"):
		pala.visible=true
		colision.disabled = false
	else:
		pala.visible=false
		colision.disabled = true
