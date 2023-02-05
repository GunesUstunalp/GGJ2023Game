extends AnimatedSprite

func _ready():
	var wind = get_parent().get_node("Wind")
	wind.connect("strength_passed_threshold", self, "update_tree_based_on_wind")
	playing = true
	update_tree_based_on_wind(1)

func fall_tree():
	print("Tree has fallen")
	play("BendBroken")
	speed_scale = 1.2

func _on_AnimatedTree_animation_finished():
	if animation == "BendBroken":
		playing = false

func update_tree_based_on_wind(windStrength):
	print("WindStrengthThreshold ", windStrength)
	if windStrength == 1:
		play("BendStage1")
		speed_scale = 0.6
	elif windStrength == 2:
		play("BendStage2")
		speed_scale = 0.9
	elif windStrength == 3:
		play("BendStage3")
		speed_scale = 0.9
