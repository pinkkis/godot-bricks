extends CharacterBody2D
class_name Paddle

@export var SPEED = 300

func _physics_process(_delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	move_and_slide()
