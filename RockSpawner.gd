extends Node2D
var rockImage
var rockImageScale
var rockHalfWidth = 40
var currRockIndex = 0

signal rock_spawned

func _ready():
	rockImage = preload('res://Resources/stone2.png')
	var th = rockHalfWidth * 2
	var tw = rockHalfWidth * 2
	var imageSize = rockImage.get_size()
	rockImageScale = Vector2(tw/imageSize.x, th/imageSize.y)
	
	var rootEnd = get_node("RootEnd")
	rootEnd.connect("found_rock", self, "_on_found_rock")
	
	spawnRockAtPosition(Vector2(512,512))

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

func _on_found_rock(rootEndPos, foundIndex):
	print("Found Rock!")
#	var connectionLine = Line2D.new()
#	connectionLine.draw_line(Vector2(400,400), Vector2(512,512), Color.aqua, 10)
#	add_child_below_node(get_node("Rocks"), connectionLine)
