extends Node2D

var imagen: AnimatedSprite2D
var texto: Label

var escenas = [
	"Hace mucho tiempo, en esta región, dos montañas dominaban estas tierras...",
	"Al norte se alzaba Monte Sol, una montaña venerada por quienes buscaban su luz y su poder.",
	"Al sur se encontraba Monte Luna, rodeado de misterio y venerado por quienes seguían la fuerza de la noche.",
	"Durante generaciones, los seguidores de ambos montes convivieron separados...",
	"Pero con el paso del tiempo, sus creencias comenzaron a enfrentarse.",
	"Algo antiguo despertó entre las dos montañas...",
	"Y una nueva historia estaba a punto de comenzar."
]

var escena_actual := 0
var escribiendo := true
var velocidad_texto := 0.04
var tiempo_texto := 0.0


func _ready():
	# Busca los nodos automáticamente, sin importar si Panel está
	# dentro o fuera de AnimatedSprite2D.
	imagen = find_child("AnimatedSprite2D", true, false) as AnimatedSprite2D
	texto = find_child("Label", true, false) as Label

	if imagen == null:
		print("ERROR: No encuentro AnimatedSprite2D")
		return

	if texto == null:
		print("ERROR: No encuentro Label")
		return

	imagen.frame = escena_actual
	mostrar_texto()


func mostrar_texto():
	texto.text = escenas[escena_actual]
	texto.visible_characters = 0
	escribiendo = true
	tiempo_texto = 0.0


func _process(delta):
	if texto == null:
		return

	if escribiendo:
		tiempo_texto += delta

		if tiempo_texto >= velocidad_texto:
			tiempo_texto = 0.0
			texto.visible_characters += 1

			if texto.visible_characters >= texto.get_total_character_count():
				texto.visible_characters = -1
				escribiendo = false

	if Input.is_action_just_pressed("ui_accept"):
		if escribiendo:
			texto.visible_characters = -1
			escribiendo = false
		else:
			siguiente_escena()


func siguiente_escena():
	escena_actual += 1

	if escena_actual >= escenas.size():
		escena_actual = escenas.size() - 1
		return

	imagen.frame = escena_actual
	mostrar_texto()
