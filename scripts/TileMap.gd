extends TileMapLayer

# grid variables
const COLS : int = 10
const ROWS : int = 20

# game piece variables
var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

# tilemap variables
var tile_id : int = 1
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

func _ready():
	pass
	
func _process(_delta):
	# draw_piece(j[0], Vector2i(5, 1), Vector2i(1, 0))
	pass 

func is_free(pos):
	return get_cell_source_id(pos) == -1

	
