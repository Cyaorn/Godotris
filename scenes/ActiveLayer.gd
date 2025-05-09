extends TileMapLayer

# Not sure why two layers is necessary, but this is needed to follow the 
#   tutorial
@onready var board = get_parent()

# R: 90, 2: 180, L: 270 by SRS standard

var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_R := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_2 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_L := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_R, i_2, i_L]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_R := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_2 := [Vector2i(2, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_L := [Vector2i(1, 0), Vector2i(0, 2), Vector2i(1, 1), Vector2i(1, 2)]
var j := [j_0, j_R, j_2, j_L]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_R := [Vector2i(1, 0), Vector2i(0, 2), Vector2i(1, 1), Vector2i(1, 2)]
var l_2 := [Vector2i(0, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_L := [Vector2i(1, 0), Vector2i(0, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l_0, l_R, l_2, l_L]

# this feels largely unnecessary but keeping it for uniformity
var o_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var o_R := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var o_2 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var o_L := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var o := [o_0, o_R, o_2, o_L]

var s_0 := [Vector2i(2, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1)]
var s_R := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s_2 := [Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(0, 2)]
var s_L := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s := [s_0, s_R, s_2, s_L]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_R := [Vector2i(1, 0), Vector2i(1, 2), Vector2i(1, 1), Vector2i(1, 2)]
var t_2 := [Vector2i(1, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_L := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_R, t_2, t_L]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_R := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2)]
var z_2 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_L := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2)]
var z := [z_0, z_R, z_2, z_L]

# indices need to match order of squares in TileSet
var shapes := [i, t, o, z, s, l, j]
var shapes_bag = shapes.duplicate()

# grid variables
const COLS : int = 10
const ROWS : int = 20

# movement variables
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps : Array
const steps_req : int = 50
const start_pos := Vector2i(5, 1)
var cur_pos : Vector2i
var speed : float

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
	new_game()
	
func new_game(): 
	# reset variables
	speed = 1.0
	steps = [0, 0, 0] # [left, right, down]
	piece_type = pick_piece()
	piece_atlas = Vector2i(shapes.find(piece_type), 0)
	create_piece()
	
func _process(_delta):
	if Input.is_action_pressed("ui_left"):
		steps[0] += 10
	elif Input.is_action_pressed("ui_right"):
		steps[1] += 10
	elif Input.is_action_pressed("ui_down"):
		steps[2] += 10
	
	# apply downward movement every frame
	steps[2] += speed 
	for i in range(steps.size()):
		if steps[i] > steps_req:
			move_piece(directions[i])
			steps[i] = 0

func pick_piece():
	var piece
	if shapes_bag.is_empty():
		shapes_bag = shapes.duplicate()
	shapes_bag.shuffle()
	piece = shapes_bag.pop_front()
	return piece
		
func create_piece():
	# reset variables
	steps = [0, 0, 0] # [left, right, down]
	cur_pos = start_pos
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)
	
func clear_piece():
	for i in active_piece:
		erase_cell(cur_pos + i)

func draw_piece(piece, pos, atlas):
	for i in piece:
		set_cell(pos + i, tile_id, atlas)

func move_piece(dir):
	if can_move(dir):
		clear_piece()
		cur_pos += dir
		draw_piece(active_piece, cur_pos, piece_atlas)

func can_move(dir):
	# check if there is space to move
	for i in active_piece:
		if not is_free(i + cur_pos + dir):
			return false
	return true

func is_free(pos):
	return board.is_free(pos)
