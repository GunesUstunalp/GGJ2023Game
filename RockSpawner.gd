extends Node2D
var rockImage
var rockImageScale
var rockHalfWidth = 40
var currRockIndex = 0

var animatedRock
var rockPositionsArr = []
var rng = RandomNumberGenerator.new()

signal rock_spawned

func _ready():
	rockImage = preload('res://Resources/stoneanimation2/0.png')
	var th = rockHalfWidth * 2
	var tw = rockHalfWidth * 2
	var imageSize = rockImage.get_size()
	rockImageScale = Vector2(tw/imageSize.x, th/imageSize.y)
	
	var rootEnd = get_node("RootEnd")
	rootEnd.connect("found_rock", self, "_on_found_rock")
	
	spawnRockAtPosition(Vector2(480,400))
	
	animatedRock = preload('res://AnimatedRock.tscn')
	rng.randomize()

func _process(delta):
	pass
	
func spawnRockAtPosition(posToSpawn : Vector2):
	var rockInstance = Sprite.new()
	rockInstance.texture = rockImage
	rockInstance.scale = rockImageScale
	rockInstance.position = posToSpawn
	get_node("Rocks").add_child(rockInstance)
	emit_signal("rock_spawned", posToSpawn, rockHalfWidth, currRockIndex)
	currRockIndex += 1
	rockPositionsArr.append(posToSpawn)

func _on_found_rock(rootEndPos, foundIndex):
	print("Found Rock!")
	
	var animatedRockInstance = animatedRock.instance()
	animatedRockInstance.scale = rockImageScale
	animatedRockInstance.position = rockPositionsArr[foundIndex]
	animatedRockInstance.play("found_rock")
	get_node("AnimatedRocks").add_child(animatedRockInstance)
	
	if foundIndex == 0: #spawn an extra rock if it's the first time we found a rock
		spawnRockAtRandomPosition() 
	
	spawnRockAtRandomPosition()
	
#	var connectionLine = Line2D.new()
#	connectionLine.draw_line(Vector2(400,400), Vector2(512,512), Color.aqua, 10)
#	add_child_below_node(get_node("Rocks"), connectionLine)

func spawnRockAtRandomPosition():
	print("Spawn Rock at Random Pos")
	var randX = rng.randf_range(0 + rockHalfWidth, 1024 - rockHalfWidth)
	var randY = rng.randf_range(300 + rockHalfWidth, 812 - rockHalfWidth)
	
	if get_node("RootEnd").call("is_there_space_for_a_rock_there", Vector2(randX, randY), rockHalfWidth):
		spawnRockAtPosition(Vector2(randX, randY))
	else:
		spawnRockAtRandomPosition()
