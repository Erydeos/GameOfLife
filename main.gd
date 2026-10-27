extends Node

# Define grid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
				


func _on_game_grid_update_step() -> void:
	$HUD.update($HUD/Generation, "G: " + str($GameGrid.generation))


func _on_hud_step_change() -> void:
	$GameGrid.steps_per_second = $HUD/TimeSlider.value


func _on_game_grid_pause_play() -> void:
	if $GameGrid.running:
		$HUD/Pause_Play.text = "Running"
	else:
		$HUD/Pause_Play.text = "Paused"


func _on_hud_reset() -> void:
	$GameGrid.reset()
	$HUD/Generation.text = "G: 0"


func _on_hud_random() -> void:
	$GameGrid.randomize($HUD/Density.value)
