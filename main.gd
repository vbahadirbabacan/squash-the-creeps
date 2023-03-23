extends Node

@export var mob_scene: PackedScene
var player_alive = true

func _ready():
	randomize()
	$UserInterface/Retry.hide()
	$UserInterface/ComboLabel.hide()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_loaction = get_node("SpawnPath/SpawnLocation")
	
	mob_spawn_loaction.progress_ratio = randf()
	var player_position = $Player.transform.origin
	
	mob.initialize(mob_spawn_loaction.position, player_position)
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_Squashed.bind())

	add_child(mob)
	
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_player_hit():
	$UserInterface/Retry.show()
	$UserInterface/ComboLabel.hide()
	$MobTimer.stop()
	player_alive = false

func _on_player_combo_add():
	$UserInterface/ComboLabel.on_combo_add()

func _on_player_combo_break():
	var combo_var = $UserInterface/ComboLabel.combo_score
	if combo_var > 1:
		$UserInterface/ScoreLabel.update_score(combo_var)
	$UserInterface/ComboLabel.on_combo_end()


func _on_debug_timer_timeout():
	if $Player != null:
		print($Player.position.y)
