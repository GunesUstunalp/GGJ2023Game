extends Area2D

var rootHalfWidth = 5
var slowSpeed = 35
var fastSpeed = 150
var rootOriginPoint = Vector2(512, 300)
var speed = slowSpeed
var rootScene
var groundMatrix #0-> free, 1-> root, 2-> rock
var generatedRootImage
var rootImageScale

var lastCreatedPosition = Vector2.ZERO 

signal found_rock

func _ready():
	position = rootOriginPoint
	generatedRootImage = preload('res://Resources/rootcolor.jpg')
	
	var th = rootHalfWidth * 2
	var tw = rootHalfWidth * 2
	var imageSize = generatedRootImage.get_size()
	rootImageScale = Vector2(tw/imageSize.x, th/imageSize.y)
	
	groundMatrix=[]
	for x in range(1024):
		groundMatrix.append([])
		for _y in range(512):
			groundMatrix[x].append(0) #0  indicate that the space is free
	
	var mainScene = get_parent()
	mainScene.connect("rock_spawned", self, "_on_rock_spawned")

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if Input.is_action_pressed("respawn"):
		respawn()

	var x_to_check = position.x + (velocity.x * 5)
	var y_to_check = position.y - 300 + (velocity.y * 5)
	if x_to_check >= 1024 or y_to_check >= 512:
		print("X= ",position.x, " Y= ", position.y, " VelX= ", velocity.x, " VelY= ", velocity.y)
	if x_to_check < 1023 and y_to_check < 511 and groundMatrix[x_to_check][y_to_check] == 0:
		speed = slowSpeed
	elif x_to_check < 1023 and y_to_check < 511 and groundMatrix[x_to_check][y_to_check] != 1:
		respawn()
		emit_signal("found_rock", position, groundMatrix[x_to_check][y_to_check] - 2) #position and rockIndex
	else:
		speed = fastSpeed
	
	if velocity != Vector2.ZERO:
		if groundMatrix[int(position.x)][int(position.y - 300)] == 0:
			create_roots_on_path()
		else:
			create_dummy_root_on_path()
			
		velocity = velocity.normalized() * speed
		
		var newPosition = position + velocity * delta
		
		#print(newPosition.x, " ", newPosition.y - 300)
		if(newPosition.x < 1 or newPosition.x > 1023 or newPosition.y - 300 > 511):
			respawn()
		else:
			position = newPosition

func create_roots_on_path():
	lastCreatedPosition = position
	
	var generatedRootInstance = Sprite.new()
	generatedRootInstance.texture = generatedRootImage
	generatedRootInstance.scale = rootImageScale
	generatedRootInstance.position = position
	get_parent().find_node("Roots").add_child(generatedRootInstance)
	
	var rootCenterX = int(position.x) - rootHalfWidth
	var rootCenterY = int(position.y - 300) - rootHalfWidth
	
	for x in range(rootHalfWidth * 2):
		for y in range(rootHalfWidth * 2):
			if rootCenterX + x > 0 and rootCenterX + x < 1024 and rootCenterY + y < 512:
				groundMatrix[rootCenterX + x][rootCenterY + y] = 1
	raise()
	
func create_dummy_root_on_path():
	var generatedRootInstance = Sprite.new()
	generatedRootInstance.texture = generatedRootImage
	generatedRootInstance.scale = rootImageScale
	generatedRootInstance.position = position
	get_parent().add_child(generatedRootInstance)
	raise()

func respawn():
	position = rootOriginPoint

func _on_rock_spawned(posToSpawn, rockHalfWidth, currRockIndex):
	posToSpawn.x -= rockHalfWidth
	posToSpawn.y -= rockHalfWidth
	
	for x in range(rockHalfWidth * 2):
		for y in range(rockHalfWidth * 2):
			groundMatrix[posToSpawn.x + x][posToSpawn.y - 300 + y] = currRockIndex + 2
			#print(posToSpawn.x + x, "  ", posToSpawn.y - 300 + y)
	print("Rock spawned")
