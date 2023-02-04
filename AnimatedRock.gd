extends AnimatedSprite

func _on_AnimatedSprite_animation_finished():
	frame = 6
	playing = false
