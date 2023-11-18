extends Node2D

@export var lives = 3
@export var ball_start_speed = 100
@export var paddle_base_speed = 100

@onready var ball_start_position = $BallStartPosition
@onready var paddle_start_position = $PaddleStartPosition
@onready var level_start_position = $LevelStartPosition

@onready var start = $UI/StartButton
@onready var level_start_timer = $LevelStartTimer
@onready var background = $Background

@onready var lives_label = $UI/LivesLabel
@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var game_win_label = $UI/GameWinLabel
@onready var level_label = $UI/LevelLabel

var score := 0
var ball_scene := preload("res://scenes/ball.tscn")
var paddle_scene := preload("res://scenes/paddle.tscn")
var paddle: Paddle
var ball: Ball
var current_level := 1
var current_level_scene: Node2D

const level_count = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	score_label.text = 'Score 0'
	lives_label.text = 'Lives ' + str(lives)

func spawn_ball():
	ball = ball_scene.instantiate()
	ball.ball_start_speed = ball_start_speed
	ball.global_position = ball_start_position.global_position
	ball.ball_lost.connect(_on_ball_ball_lost)
	ball.brick_hit.connect(_on_ball_brick_hit)
	add_child(ball)
	lives -= 1
	lives_label.text = 'Lives ' + str(lives)

func spawn_paddle():
	paddle = paddle_scene.instantiate()
	paddle.global_position = paddle_start_position.global_position
	paddle.SPEED = paddle_base_speed
	add_child(paddle)
	
func _on_ball_ball_lost():
	if lives == 0:
		game_over_label.visible = true
		paddle.queue_free()
		start.visible = true
	else:
		spawn_ball()

func _on_ball_brick_hit():
	score += 100
	score_label.text = 'Score ' + str(score)
	if current_level_scene.get_child_count() == 1:
		_on_level_end()

func _on_level_end():
	ball.queue_free()
	paddle.queue_free()
	if current_level < level_count:
		current_level += 1
		call_deferred("load_level")
	else:
		score_label.visible = false
		lives_label.visible = false
		game_win_label = 'You Win!\nScore: ' + str(score)
		game_win_label.visible = true 
		start.visible = true

func load_level():
	var level = "res://scenes/levels/level_" + str(current_level) + ".tscn"
	if current_level_scene:
		current_level_scene.free()
	var packed = load(level)
	if not packed is PackedScene:
		push_error("Failed to load scene from %s!" % level)
		return
	current_level_scene = packed.instantiate()
	current_level_scene.global_position = level_start_position.global_position
	add_child(current_level_scene)
	
	# set random background color
	background.modulate = Color.from_hsv((randi() % 12) / 12.0, 1, 1)
	
	level_label.text = 'Level ' + str(current_level)
	level_label.visible = true
	level_start_timer.start(2)

func _on_start_pressed():
	current_level = 1
	lives = 3
	start.visible = false
	score_label.visible = true
	lives_label.visible = true
	game_over_label.visible = false
	game_win_label.visible = false
	load_level()

func _on_start_level():
	
	spawn_ball()
	spawn_paddle()

func _on_level_start_timer_timeout():
	level_label.visible = false
	_on_start_level()
