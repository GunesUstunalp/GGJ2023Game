extends AnimatedSprite

var strength = 1
var lastSignaledStrength = 1

var MAX_STRENGTH = 3
var MIN_STRENGTH = 1
var BASE_SPEED = 1.5
var BASE_SCALE = Vector2(0.66, 0.33)
var STRENGTH_UP_RATE = 0.15

var fallTimer
var inFallCountDown = false

signal strength_passed_threshold

func _ready():
	updateWindBasedOnStrength()
	fallTimer = Timer.new()
	add_child(fallTimer)
	var animatedTree = get_parent().get_node("AnimatedTree")
	fallTimer.connect("timeout", animatedTree, "fall_tree")
	fallTimer.connect("timeout", fallTimer, "stop")
	
	var rootEnd = get_parent().get_node("RootEnd")
	rootEnd.connect("found_rock", self, "found_rock")
	
func _process(delta):
	strength += delta * STRENGTH_UP_RATE
	
	if strength > MAX_STRENGTH:
		strength = MAX_STRENGTH
	
#	if strength != MAX_STRENGTH:
#		print("Strength", strength)
	
	if inFallCountDown and strength < MAX_STRENGTH:
		inFallCountDown = false
		fallTimer.stop()
	elif not inFallCountDown and strength == MAX_STRENGTH:
		fallTimer.start(1 / STRENGTH_UP_RATE)
		inFallCountDown = true
	
	updateWindBasedOnStrength()

func updateWindBasedOnStrength():
	speed_scale = BASE_SPEED * strength
	scale = BASE_SCALE * ( 1 + strength / 3)

	if strength == MAX_STRENGTH:
		animation = "Continuous"
	else:
		animation = "default"
		
	if int(strength) != lastSignaledStrength:
		emit_signal("strength_passed_threshold", int(strength))
		lastSignaledStrength = int(strength)
	
	
func found_rock(rockPosition, foundRockIndex):
	update_strength(-1)
	
func update_strength(offset):
	strength += offset
	strength = clamp(strength, MIN_STRENGTH, MAX_STRENGTH)
