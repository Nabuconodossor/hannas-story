extends CharacterBody2D

@export var velocidad := 150.0

@onready var sprite = $AnimatedSprite2D

var ultima_direccion := "abajo"

func _physics_process(_delta):
	var direccion = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	velocity = direccion * velocidad

	if direccion != Vector2.ZERO:
		if abs(direccion.x) > abs(direccion.y):
			ultima_direccion = "derecha" if direccion.x > 0 else "izquierda"
		else:
			ultima_direccion = "abajo" if direccion.y > 0 else "arriba"
		sprite.play(ultima_direccion)
	else:
		sprite.play("idle_" + ultima_direccion)

	move_and_slide()
