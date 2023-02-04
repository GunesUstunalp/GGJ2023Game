extends AnimatedSprite

func _on_AnimatedSprite_animation_finished():
	frame = 9
	playing = false
