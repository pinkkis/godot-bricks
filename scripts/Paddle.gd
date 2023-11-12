extends CharacterBody2D
class_name Paddle

@onready var sprite = $CollisionShape2D

@export var SPEED = 300

const PADDLE_WIDTH = 128

func _physics_process(delta):
	
	var viewport_size = get_viewport_rect().size
	
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * SPEED * delta
	
	if global_position.x < 0:
		global_position.x = 0
	if global_position.x > viewport_size.x - PADDLE_WIDTH:
		global_position.x = viewport_size.x - PADDLE_WIDTH
