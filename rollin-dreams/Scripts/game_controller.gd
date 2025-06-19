extends Node

# Signals
signal on_candy_collected(value: int)

# Variables
var candy_count = 0
var total_candies_in_level = 0

func _ready():
	# Count all candy nodes (Star nodes) in the scene tree
	var candies = get_tree().get_nodes_in_group("candies")
	total_candies_in_level = candies.size()
	update_ui()
	# Connect the on_candy_collected signal to _on_candy_collected
	connect("on_candy_collected", Callable(self, "_on_candy_collected"))

func _on_candy_collected(value: int):
	# Update UI when signal is emitted
	update_ui()

func candy_collected(value: int):
	# Called by Star script, increment count and emit signal
	candy_count += value
	emit_signal("on_candy_collected", value)

func update_ui():
	# Update the UI label with current candy count
	var ui_label = get_tree().root.find_child("CandyCountLabel", true, false)
	if ui_label:
		ui_label.text = "Stars: %d / 7" % [candy_count]

func show_level_complete():
	# Show the level complete screen with total candies collected
	var level_complete_ui = get_tree().root.find_child("LevelCompleteUI", true, false)
	if level_complete_ui:
		var label = level_complete_ui.find_child("LevelCompleteLabel", true, false)
		if label:
			label.text = "Level Complete!\nCandies Collected: %d / %d" % [candy_count, total_candies_in_level]
		level_complete_ui.visible = true
		# Pause the game to show the completion screen
		get_tree().paused = true

func reset_level():
	# Reset candy count and reload the scene
	candy_count = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
