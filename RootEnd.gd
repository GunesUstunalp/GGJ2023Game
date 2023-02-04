extends Area2D

var rootHalfWidth = 5
var slowSpeed = 25
var fastSpeed = 200
var speed = slowSpeed
var rootScene
var groundMatrix #0-> free, 1-> root, 2-> rock

var lastCreatedPosition = Vector2.ZERO 

func _ready():
	rootScene = preload("res://ARoot.tscn")
	
	groundMatrix=[]
	for x in range(1024):
		groundMatrix.append([])
		for _y in range(512):
			groundMatrix[x].append(0) #0  indicate that the space is free

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if Input.is_action_pressed("respawn"):
		position = Vector2(512, 380)
	
	#if lastCreatedPosition.x - 1 < position.x and lastCreatedPosition.x + 1 > position.x and lastCreatedPosition.y - 1 < position.y and lastCreatedPosition.y + 1 > position.y:
	if lastCreatedPosition.distance_to(position) < 5:
		speed = slowSpeed
	else:
		speed = fastSpeed
	
	
	
	if velocity != Vector2.ZERO:
		if groundMatrix[int(position.x)][int(position.y - 512)] == 0:
			create_roots_on_path()
			
		velocity = velocity.normalized() * speed
		position += velocity * delta
		
	print("Speed ", speed, " -- ", lastCreatedPosition.distance_to(position))

func create_roots_on_path():
	lastCreatedPosition = position
	
	var rootInstance = rootScene.instance()
	rootInstance.position = position
	get_parent().add_child(rootInstance)
	
	var rootCenterX = int(position.x) - rootHalfWidth
	var rootCenterY = int(position.y - 512) - rootHalfWidth
	
	for x in range(rootHalfWidth * 2):
		for y in range(rootHalfWidth * 2):
			groundMatrix[rootCenterX + x][rootCenterY + y] = 1
	
	#print("Speed = ",speed)
	
	
#	var shape = RectangleShape2D.new()
#	shape.set_extents(Vector2(5,5))
#	var collision = CollisionShape2D.new()
#	collision.set_shape(shape)
#	collision.position = position
#
#	get_parent().find_node("Roots").add_child(collision)

	raise()

