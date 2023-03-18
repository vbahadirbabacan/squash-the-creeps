extends Label

var score = 0

func _on_Mob_Squashed():
	score += 1
	text = "Score: %s" % score
	
func update_score(added_score):
	score += added_score
	text = "Score: %s" % score
