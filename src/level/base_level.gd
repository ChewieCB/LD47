extends MarginContainer

signal ui_loaded

export (int) var line_margin_x = 10

onready var chain_manager = $ChainManager
onready var initial_timer = chain_manager.starting_chains * $BreakTimer.wait_time
# UI vars
onready var main_ui = $MainUI/MainUI
onready var ui_overlays = $UIOverlays
onready var ui_tween = $UIOverlays/Tween
onready var game_over_scene = load("res://src/ui/game_over/GameOver.tscn")


func _ready():
	$SummonTimer.start(initial_timer)


func _process(_delta):
	if has_node("BreakTimer"):
		# Update the progress bar ui
		var timer_time_left = $BreakTimer.time_left
		var time_left = chain_manager.number_of_chains * $BreakTimer.wait_time + timer_time_left
		var minutes_left = round(time_left / 60)
		var seconds_left = round(fmod(time_left, 60.0))
		main_ui.timer_count.text = str("%d:%02d" % [minutes_left, seconds_left])
		main_ui.timer_progress.value = (time_left / $BreakTimer.wait_time) * 100
	else:
		main_ui.timer_count.visible = false
		main_ui.timer_progress.visible = false


func game_over():
	# Disable player input
	chain_manager.is_input_available = false
	# Hide the spell UI
	var spell_ui = main_ui.spell_ui
	var spell_ui_tween = main_ui.spell_ui.tween
	spell_ui_tween.interpolate_property(
		spell_ui,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	spell_ui_tween.start()
	var game_over_instance = game_over_scene.instance()
	# Hide the overlay then fade in
	game_over_instance.modulate = Color(1.0, 1.0, 1.0, 0.0)
	ui_overlays.add_child(game_over_instance)
	ui_tween.interpolate_property(
		game_over_instance, 
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	# Load game over overlay
	ui_tween.start()
	emit_signal("ui_loaded")
	#


func _on_BreakTimer_timeout():
	# Break a chain
	var chain
	if $ChainManager/Chains.get_child_count() == 0:
		chain = null
	else:
		chain = $ChainManager/Chains.get_child(0)
	var demon = $Demon
	if chain:
		chain.animation_player.play("break")
		demon.animation_player.play("shake")
		$ChainManager.number_of_chains -= 1
		# Restart the timer
		$BreakTimer.start($BreakTimer.wait_time)
		var summon_time_left = $SummonTimer.time_left
		$SummonTimer.start(summon_time_left + $BreakTimer.wait_time)
	else:
		# Evolve the demon and lose the game
		chain_manager.is_input_available = false
		demon.animation_player.play("evolve")
		$ChainManager/LoseSound.play()
		$ChainManager/BoomSound.play()
		$BreakTimer.queue_free()


func _on_Demon_evolved():
	game_over()

