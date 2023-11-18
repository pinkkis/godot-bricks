extends CharacterBody2D
class_name Ball

signal ball_lost
signal brick_hit

@export var ball_start_speed = 100
@export var ball_lost_sound: AudioStream
@export var wall_hit_sound: AudioStream
@export var paddle_hit_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var target_object = collision_info.get_collider()
		if target_object.is_in_group("bricks"):
			target_object.die()
			brick_hit.emit()
		if target_object.is_in_group("death"):
			ball_lost.emit()
			AudioManager.play_sound(ball_lost_sound)
			queue_free()
		velocity = velocity.bounce(collision_info.get_normal())

		if target_object.is_in_group("wall"):
			AudioManager.play_sound(wall_hit_sound)

		if target_object.is_in_group("paddle"):
			AudioManager.play_sound(paddle_hit_sound)
			velocity = velocity + collision_info.get_collider_velocity() / 10

func _on_timer_timeout():
	velocity = Vector2(randf_range(-100, 100), 100).normalized() * ball_start_speed

func _on_speed_up_timer_timeout():
	velocity = velocity * 1.05
