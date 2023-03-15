extends Node

@export var mob_scene: PackedScene

func _ready():
	randomize()
	$UserInterface/Retry.hide()


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
	$MobTimer.stop()
