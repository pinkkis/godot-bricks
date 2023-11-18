extends CharacterBody2D
class_name Paddle

@export var SPEED = 300

const PADDLE_WIDTH = 128
var using_mouse = true
var screen_rect = Vector2(0, 0)

func _ready():
	screen_rect = get_tree().get_root().get_visible_rect().size

func _physics_process(_delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		using_mouse = false
	if Input.get_last_mouse_velocity().x > 0.0:
		using_mouse = true

	if !using_mouse:
		velocity.x = direction * SPEED
		move_and_slide()
	else:
		position.x = clampf(get_global_mouse_position().x, 0.0, screen_rect.x - PADDLE_WIDTH)
		if 1 == 0:
			pass
