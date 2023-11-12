extends Node2D

@export var lives = 3
@export var ball_start_speed = 100
@export var paddle_base_speed = 100

@onready var ball_start_position = $BallStartPosition
@onready var paddle_start_position = $PaddleStartPosition
@onready var start = $StartButton
@onready var lives_label = $LivesLabel
@onready var bricks = $Bricks
@onready var score_label = $ScoreLabel
@onready var game_over_label = $GameOverLabel

var score = 0

var ball_scene = preload("res://scenes/ball.tscn")
var paddle_scene = preload("res://scenes/paddle.tscn")
var paddle: Paddle

# Called when the node enters the scene tree for the first time.
func _ready():
	lives_label.text = str(lives)

func _process(_delta):
	pass

func spawn_ball():
	var ball: Ball = ball_scene.instantiate()
	ball.ball_start_speed = ball_start_speed
	ball.global_position = ball_start_position.global_position
	ball.ball_lost.connect(_on_ball_ball_lost)
	ball.brick_hit.connect(_on_ball_brick_hit)
	add_child(ball)
	lives -= 1
	lives_label.text = str(lives)

func spawn_paddle():
	paddle = paddle_scene.instantiate()
	paddle.global_position = paddle_start_position.global_position
	paddle.SPEED = paddle_base_speed
	add_child(paddle)
	
func _on_ball_ball_lost():
	print("ball lost")
	if lives == 0:
		game_over_label.visible = true
		paddle.queue_free()
	else:
		spawn_ball()

func _on_ball_brick_hit():
	score += 100
	score_label.text = str(score)

func _on_start_pressed():
	spawn_ball()
	spawn_paddle()
	start.queue_free()
