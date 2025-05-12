extends TileMapLayer

# grid variables
const COLS : int = 10
const ROWS : int = 20

# tilemap variables
var tile_id : int = 1

# score variables
var scores = [0, 0, 0, 0, 0, 0, 0]
# [single, double, triple, tetris, T-spin single, T-double, T-triple]

func _ready():
	pass
	
func _process(_delta):
	pass 

func is_free(pos):
	return get_cell_source_id(pos) == -1

func check_rows():
	var row : int = ROWS
	while row > 0:
		var count = 0
		for i in range(COLS):
			if not is_free(Vector2i(i + 1, row)):
				count += 1
		# if row is full then erase it	
		if count == COLS:
			shift_rows(row)
			scores[0] += 1
		else:
			row -= 1
	update_score()

func shift_rows(row):
	var atlas
	for i in range(row, 1, -1):
		for j in range(COLS):
			# get atlas of cell above current cell
			atlas = get_cell_atlas_coords(Vector2i(j + 1, i - 1))
			# if cell in above row is empty
			if atlas == Vector2i(-1, -1):
				erase_cell(Vector2i(j + 1, i))
			else:
				set_cell(Vector2i(j + 1, i), tile_id, atlas)
				
func clear_board():
	for i in range(ROWS):
		for j in range(COLS):
			erase_cell(Vector2i(j + 1, i + 1))
			
func reset_score():
	scores = [0, 0, 0, 0, 0, 0, 0]
	update_score()
	
func update_score():
	$HUD/MarginContainer/StatsLabel.text = '''Singles: %d
Doubles: %d
Triples: %d
Tetrises: %d
T-Spin Singles: %d
T-Spin Doubles: %d
T-Spin Triples: %d''' % scores
	
