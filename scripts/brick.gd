extends StaticBody2D

@export var brickTexture: Texture2D

@onready var sprite_2d = $Sprite2D

func _ready():
	sprite_2d.texture = brickTexture

func _process(_delta):
	pass
