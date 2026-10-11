extends CharacterBody2D

@export var velocidad := 150.0

@onready var sprite = $AnimatedSprite2D

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
			if direccion.x > 0:
				sprite.play("derecha")
			else:
				sprite.play("izquierda")
		else:
			if direccion.y > 0:
				sprite.play("abajo")
			else:
				sprite.play("arriba")
	else:
		sprite.stop()

	move_and_slide()
