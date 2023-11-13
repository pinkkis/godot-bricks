extends CharacterBody2D
class_name Ball

signal ball_lost
signal brick_hit

@export var ball_start_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var target_object = collision_info.get_collider()
		if target_object.is_in_group("bricks"):
			target_object.queue_free()
			brick_hit.emit()
		if target_object.is_in_group("death"):
			ball_lost.emit()
			queue_free()
		velocity = velocity.bounce(collision_info.get_normal())

		if target_object.is_in_group("paddle"):
			velocity = velocity + collision_info.get_collider_velocity() / 10

func _on_timer_timeout():
	velocity = Vector2(randf_range(-100, 100), 100).normalized() * ball_start_speed

func _on_speed_up_timer_timeout():
	velocity = velocity * 1.05
