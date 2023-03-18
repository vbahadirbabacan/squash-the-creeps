extends Label

var combo_score = 1

func on_combo_add():
	combo_score += 1
	if combo_score > 1:
		text = "Combo: %s" % combo_score
		show()
	
func on_combo_end():
	hide()
	combo_score = 1
