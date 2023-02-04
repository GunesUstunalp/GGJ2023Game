extends Area2D

var speed = 50
var rootScene

func _ready():
	rootScene = preload("res://ARoot.tscn")

func _process(delta):
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 0.2
		
	if Input.is_action_pressed("respawn"):
		position = Vector2(512, 380)
	
	velocity = velocity * speed
	position += velocity * delta
	
	create_roots_on_path()

func create_roots_on_path():
	var rootInstance = rootScene.instance()
	rootInstance.position = position
	get_parent().add_child(rootInstance)
