extends Node2D
var rockImage
var rockImageScale
var DefaultRockHalfWidth = 40
var currRockIndex = 0

var animatedRock
var rockPositionsArr = []
var rockScalesArr = []
var rockRotationsArr = []
var foundRockCounter = 0
var rng = RandomNumberGenerator.new()
var topOffset = 70

signal rock_spawned

func _ready():
	rockImage = preload('res://Resources/stoneanimation2/0.png')
	
	var rootEnd = get_node("RootEnd")
	rootEnd.connect("found_rock", self, "_on_found_rock")
	
	spawnRockAtPosition(Vector2(450,410 + topOffset), DefaultRockHalfWidth, 0)
	
	animatedRock = preload('res://AnimatedRock.tscn')
	rng.randomize()

func _process(delta):
	pass
	
func spawnRockAtPosition(posToSpawn : Vector2, rockHalfWidth, rockRotation):
	var rockInstance = Sprite.new()
	rockInstance.texture = rockImage
	var rockScale = calculateImageScaleBasedOnHalfWidth(rockHalfWidth)
	rockInstance.scale = rockScale
	rockInstance.position = posToSpawn
	rockInstance.rotation_degrees = rockRotation
	get_node("Rocks").add_child(rockInstance)
	emit_signal("rock_spawned", posToSpawn, rockHalfWidth, currRockIndex)
	currRockIndex += 1
	rockPositionsArr.append(posToSpawn)
	rockScalesArr.append(rockScale)
	rockRotationsArr.append(rockRotation)

func _on_found_rock(rootEndPos, foundIndex):
	print("Found Rock!")
	foundRockCounter += 1
	
	if foundRockCounter == rockPositionsArr.size():
		print("Game Over! You won!")
	
	var animatedRockInstance = animatedRock.instance()
	animatedRockInstance.scale = rockScalesArr[foundIndex]
	animatedRockInstance.position = rockPositionsArr[foundIndex]
	animatedRockInstance.rotation_degrees = rockRotationsArr[foundIndex]
	animatedRockInstance.play("found_rock")
	get_node("AnimatedRocks").add_child(animatedRockInstance)
	
	if foundIndex == 0: #spawn an extra rock if it's the first time we found a rock
		spawnRockAtRandomPosition(0) 
	
	spawnRockAtRandomPosition(0)
	
#	var connectionLine = Line2D.new()
#	connectionLine.draw_line(Vector2(400,400), Vector2(512,512), Color.aqua, 10)
#	add_child_below_node(get_node("Rocks"), connectionLine)

func spawnRockAtRandomPosition(tryNumber):
	#print("Spawn Rock at Random Pos")
	var randHalfWidth = rng.randf_range(DefaultRockHalfWidth/2, DefaultRockHalfWidth)
	var randX = rng.randf_range(0 + randHalfWidth, 1024 - randHalfWidth)
	var randY = rng.randf_range(300 + topOffset + randHalfWidth, 812 - randHalfWidth)
	var randRotation = rng.randf_range(0,360)
	
	if tryNumber > 50:
		print("Possibly no more space")
		return
	
	if get_node("RootEnd").call("is_there_space_for_a_rock_there", Vector2(randX, randY), randHalfWidth):
		spawnRockAtPosition(Vector2(randX, randY), randHalfWidth, randRotation)
	else:
		spawnRockAtRandomPosition(tryNumber + 1)

func calculateImageScaleBasedOnHalfWidth(rockHalfWidth):
	var th = rockHalfWidth * 2
	var tw = rockHalfWidth * 2
	var imageSize = rockImage.get_size()
	return Vector2(tw/imageSize.x, th/imageSize.y)
