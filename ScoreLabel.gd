extends Label

var score = 0

func _on_Mob_Squashed():
	score += 1
	text = "Score: %s" % score
