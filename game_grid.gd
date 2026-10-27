extends Node2D

signal update_step
signal pause_play

# Define grid
@export var columns: int = 100
@export var rows: int = 60
@export var cell_size: int = 16
@export var wrap_edges: bool = true
@export var birth_min: int = 3
@export var birth_max: int = 3
var birth = range(birth_min, birth_max + 1)
@export var survive_min: int = 2
@export var survive_max: int = 3
var survive = range(survive_min, survive_max + 1)

var grid := PackedByteArray()
var next_grid := PackedByteArray()
var generation: int = 0
var running = false
var _accumulator: float = 0.0
@export var steps_per_second: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.resize(columns * rows)
	next_grid.resize(columns * rows)
	get_window().size = Vector2i(columns * cell_size, rows * cell_size)

	
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if running:
		_accumulator += delta
		var interval: float = 1.0 / steps_per_second
		while _accumulator >= interval:
			_accumulator -= interval
			step()
	_handle_mouse()
	
	
func _draw() -> void:
	var background = Rect2(0, 0, columns * cell_size, rows * cell_size)
	draw_rect(background, Color.BLACK)
	for y in range(rows):
		for x in range(columns):
			if grid[y * columns + x] == 1:
				var cell = Rect2(x * cell_size, y * cell_size, cell_size, cell_size)
				draw_rect(cell, Color.WHITE)
				
func set_cell(x: int, y: int, alive: bool) -> void:
	if x < 0 or x >= columns or y < 0 or y >= rows:
		return
	grid[y * columns + x] = 1 if alive else 0
	queue_redraw()

func _handle_mouse() -> void:
	var drawing: bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	var erasing: bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if not (drawing or erasing):
		return
	var pos: Vector2 = get_local_mouse_position()
	var cell: Vector2i = Vector2i((pos / cell_size).floor())
	set_cell(cell.x, cell.y, drawing)
	
func count_neighbors(x: int, y: int) -> int:
	var n: int = 0
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx: int = dx + x
			var ny: int = dy + y
			if wrap_edges:
				nx = posmod(nx, columns)
				ny = posmod(ny, rows)
			elif nx < 0 or nx > columns or ny < 0 or ny > rows:
					continue
			n += grid[ny * columns + nx]
	return n
			
func step() -> void:
	for y in rows:
		for x in columns:
			var i: int = y * columns + x
			var n: int = count_neighbors(x, y)
			var alive: bool = grid[i] == 1
			next_grid[i] = 1 if (
				(not alive and (n in birth)) or 
				(alive and (n in survive))
				) else 0			
	var tmp: PackedByteArray = grid
	grid = next_grid
	next_grid = tmp
		
	generation += 1
	queue_redraw()
	update_step.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_S:
				play_pause()
			KEY_ESCAPE:
				get_tree().quit()

func play_pause():
	running = not running
	pause_play.emit()
	
func reset():
	grid.fill(0)
	generation = 0
	if running:
		play_pause()
	queue_redraw()
	
func randomize(density: int):
	print(density)
	for i in grid.size():
		grid[i] = 1 if randf() < (float(density)/100) else 0
	generation = 0
	if running:
		play_pause()
	queue_redraw()
