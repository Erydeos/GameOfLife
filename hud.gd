extends CanvasLayer

signal step_change
signal reset
signal random
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update(label: Label, text):
	label.text = str(text)


func _on_time_slider_value_changed(value: float) -> void:
	$Steps.text = "S: " + str($TimeSlider.value)
	step_change.emit()


func _on_reset_pressed() -> void:
	reset.emit()


func _on_random_pressed() -> void:
	random.emit()


func _on_density_value_changed(value: float) -> void:
	$Random.text = "Random: " + str(int($Density.value)) + "%"
