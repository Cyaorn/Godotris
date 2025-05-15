extends TileMapLayer

@onready var BoardLayer = $board

# R: 90, 2: 180, L: 270 by SRS standard

var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_R := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_2 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_L := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i_piece := [i_0, i_R, i_2, i_L]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_R := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_2 := [Vector2i(2, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_L := [Vector2i(1, 0), Vector2i(0, 2), Vector2i(1, 1), Vector2i(1, 2)]
var j_piece := [j_0, j_R, j_2, j_L]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_R := [Vector2i(1, 0), Vector2i(2, 2), Vector2i(1, 1), Vector2i(1, 2)]
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
var t_R := [Vector2i(1, 0), Vector2i(1, 2), Vector2i(1, 1), Vector2i(2, 1)]
var t_2 := [Vector2i(1, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_L := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_R, t_2, t_L]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_R := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2)]
var z_2 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_L := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2)]
var z := [z_0, z_R, z_2, z_L]

# indices need to match order of squares in TileSet
var shapes := [i_piece, t, o, z, s, l, j_piece]
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
var ghost_pos : Vector2i
var speed : float
var fall_speed : int
var horizontal_speed : int

# game piece variables
var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array
var held := [[]]  # empty on init, will never be empty afterwards
var used_swap : bool = false

# tilemap variables
var ghost_tile_id : int = 0
var tile_id : int = 1
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i
var held_piece_atlas : Vector2i

# game variables
var is_running : bool = true

func _ready():
	new_game()
	$board/HUD/StartGameButton.pressed.connect(new_game)
	
# instantiates the whole game, currently tied to new game button
func new_game(): 
	# reset variables
	speed = 1.0
	fall_speed = 10
	horizontal_speed = 15
	steps = [0, 0, 0] # [left, right, down]
	is_running = true
	$board/HUD/GameOverLabel.hide()
	BoardLayer.reset_score()
	
	# clear everything
	clear_piece()
	clear_board()
	clear_panel()
	
	piece_type = _pick_piece()
	piece_atlas = Vector2i(shapes.find(piece_type), 0)
	next_piece_type = _pick_piece()
	next_piece_atlas = Vector2i(shapes.find(next_piece_type), 0)
	create_piece()
	
# handles all types of inputs
func _process(_delta):
	if (is_running):
		# enables single-tap to always travel 1 square max
		# if horizontal_speed is too fast holding might feel too slippery
		if Input.is_action_just_pressed("ui_a"):
			steps[0] = steps_req
		elif Input.is_action_just_pressed("ui_d"):
			steps[1] = steps_req
		# ------------------------------------------------
		elif Input.is_action_just_pressed("ui_w"):
			clear_piece()
			cur_pos = ghost_pos
			steps[2] = steps_req
		elif Input.is_action_just_pressed("ui_q"):
			if not used_swap:
				hold_piece()
				# create_piece()
				used_swap = true
		elif Input.is_action_pressed("ui_a"):
			steps[0] += horizontal_speed
		elif Input.is_action_pressed("ui_d"):
			steps[1] += horizontal_speed
		elif Input.is_action_pressed("ui_s"):
			steps[2] += fall_speed
			
		# must add these to the Input Map in Project > Settings
		if Input.is_action_just_pressed("ui_left"):
			if can_rotate(false):
				rotate_piece(false)
		elif Input.is_action_just_pressed("ui_up"):
			if can_rotate(true):
				rotate_piece(true)
		
		# apply downward movement every frame
		steps[2] += speed 
		for i in range(steps.size()):
			if steps[i] > steps_req:
				move_piece(directions[i])
				steps[i] = 0

# helper to generate a single piece from the current bag
func _pick_piece():
	var piece
	if shapes_bag.is_empty():
		shapes_bag = shapes.duplicate()
	shapes_bag.shuffle()
	piece = shapes_bag.pop_front()
	return piece
		
# handles logic involving generating the next pieces
func cycle_piece(is_init = false):
	if is_init:
		piece_type = _pick_piece()
	else:
		piece_type = next_piece_type
	piece_atlas = next_piece_atlas
	next_piece_type = _pick_piece()
	next_piece_atlas = Vector2i(shapes.find(next_piece_type), 0)
	
# handles logic for instantiating the next active piece
func create_piece():
	# reset variables
	steps = [0, 0, 0] # [left, right, down]
	rotation_index = 0
	cur_pos = start_pos
	active_piece = piece_type[rotation_index]
	update_ghost_pos()
	draw_ghost(active_piece, piece_atlas)
	draw_piece(active_piece, cur_pos, piece_atlas)
	
	# draw upcoming piece also
	draw_piece(next_piece_type[0], Vector2i(15, 10), next_piece_atlas)
	
# clears the current piece
func clear_piece():
	for i in active_piece:
		erase_cell(cur_pos + i)

# draws the current piece
func draw_piece(piece, pos, atlas):
	for i in piece:
		set_cell(pos + i, tile_id, atlas)

# handles logic involving rotating a piece
func rotate_piece(is_clockwise):
	var mod = 1 if is_clockwise else -1
	clear_ghost()
	clear_piece()
	rotation_index = (rotation_index + mod) % 4
	active_piece = piece_type[rotation_index]
	update_ghost_pos()
	draw_ghost(active_piece, piece_atlas)
	draw_piece(active_piece, cur_pos, piece_atlas)

# handles logic involving moving a piece in any direction a single tile
func move_piece(dir):
	if can_move(dir):
		clear_ghost()
		clear_piece()
		cur_pos += dir
		update_ghost_pos()
		# draw ghost first so it is automatically overlapped by piece
		draw_ghost(active_piece, piece_atlas)
		draw_piece(active_piece, cur_pos, piece_atlas)
	else:
		if dir == Vector2i.DOWN:
			land_piece()
			create_piece()
			check_game_over()

# clears the held piece panel
func clear_held():
	for i in range(14, 19):
		for j in range(4, 8):
			erase_cell(Vector2i(i, j))
	
# draws the held piece inside the panel
func draw_held():
	draw_piece(held[0], Vector2i(15, 5), held_piece_atlas)

# handles logic involving holding a piece
func hold_piece():
	clear_piece()
	clear_panel()
	clear_ghost()
	var temp = held
	held = piece_type  # want to store the entire piece, not just the rot. index
	var temp_atlas = held_piece_atlas
	held_piece_atlas = piece_atlas
	piece_type = temp  # init swapped piece at default rotation index
	# for the first swap, we just want the next piece to come forward
	if piece_type == [[]]:
		cycle_piece()
	else:
		piece_atlas = temp_atlas
	clear_held()
	draw_held()
	create_piece()

# helper to return the lowest possible pos for the current piece
func _find_ghost_pos():
	# Check starting from the top and pick the first spot before the piece hits
	# 	something to prevent the ghost from going past overhangs
	# Also want to start counting from past the current position to prevent the
	#	ghost from appearing above the actual piece
	for i in range(cur_pos.y + 1, ROWS):
		for j in active_piece:
			if not is_free(Vector2i(cur_pos.x, i) + j):
				return Vector2i(cur_pos.x, i - 1)
	# return bottom row if no obstructions
	return Vector2i(cur_pos.x, ROWS - 1)

# clears ghost piece
func clear_ghost():
	for i in active_piece:
		erase_cell(ghost_pos + i)
	
# draws the ghost piece, very similar logic to draw_piece
func draw_ghost(piece, atlas):
	for i in piece:
		set_cell(ghost_pos + i, ghost_tile_id, atlas)

# updates the global ghost_pos variable depending on cur_pos
#  mostly exists for readability, not strictly necessary as a one-liner
func update_ghost_pos():
	ghost_pos = _find_ghost_pos()

# checks if piece can move freely in a given direction
func can_move(dir):
	# check if there is space to move
	for i in active_piece:
		if not is_free(i + cur_pos + dir):
			return false
	return true

# currently checks if piece is able to rotate freely,
#  will implement wall kicking in the future
func can_rotate(is_clockwise):
	var mod = 1 if is_clockwise else -1
	var temp_rotation_index = (rotation_index + mod) % 4
	for i in piece_type[temp_rotation_index]:
		if not is_free(i + cur_pos):
			return false
	return true

# checks if a specific tile is available
func is_free(pos):
	return BoardLayer.is_free(pos)

# handles logic involving when a piece lands
func land_piece():
	# transfer cells from active layer to board layer
	for i in active_piece:
		erase_cell(cur_pos + i)
		BoardLayer.set_cell(cur_pos + i, tile_id, piece_atlas)
	
	# reset a bunch of stuff before the next piece
	BoardLayer.check_rows()
	cycle_piece()
	clear_panel()
	used_swap = false # reset swap status after every piece
		
# clears next piece panel
func clear_panel():
	for i in range(14, 19):
		for j in range(9, 13):
			erase_cell(Vector2i(i, j))
			
# clears entire board
func clear_board():
	BoardLayer.clear_board()
	
# checks for game over state
func check_game_over():
	for i in active_piece:
		if not is_free(i + cur_pos):
			land_piece()
			$board/HUD/GameOverLabel.show()
			is_running = false
