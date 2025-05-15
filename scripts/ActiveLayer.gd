extends TileMapLayer

@onready var BoardLayer = $board

# R: 90, 2: 180, L: 270 by SRS standard

var _i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)] 
var _i_R := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var _i_2 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var _i_L := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var I := [_i_0, _i_R, _i_2, _i_L]

var _j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var _j_R := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var _j_2 := [Vector2i(2, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var _j_L := [Vector2i(1, 0), Vector2i(0, 2), Vector2i(1, 1), Vector2i(1, 2)]
var J := [_j_0, _j_R, _j_2, _j_L]

var _l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var _l_R := [Vector2i(1, 0), Vector2i(2, 2), Vector2i(1, 1), Vector2i(1, 2)]
var _l_2 := [Vector2i(0, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var _l_L := [Vector2i(1, 0), Vector2i(0, 0), Vector2i(1, 1), Vector2i(1, 2)]
var L := [_l_0, _l_R, _l_2, _l_L]

# this feels largely unnecessary but keeping it for uniformity
var _o_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var _o_R := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var _o_2 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var _o_L := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
var O := [_o_0, _o_R, _o_2, _o_L]

var _s_0 := [Vector2i(2, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1)]
var _s_R := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var _s_2 := [Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(0, 2)]
var _s_L := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var S := [_s_0, _s_R, _s_2, _s_L]

var _t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var _t_R := [Vector2i(1, 0), Vector2i(1, 2), Vector2i(1, 1), Vector2i(2, 1)]
var _t_2 := [Vector2i(1, 2), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var _t_L := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var T := [_t_0, _t_R, _t_2, _t_L]

var _z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var _z_R := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2)]
var _z_2 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var _z_L := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(1, 1), Vector2i(1, 2)]
var Z := [_z_0, _z_R, _z_2, _z_L]

# 0->R,2->R / 0->L,0->L / R->0,R->2 / L->0,L->2 are the same tests
var _to_R := [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), 
			  Vector2i(0, 2), Vector2i(-1, 2)]
var _from_R := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), 
				Vector2i(0, -2), Vector2i(1, -2)]
var _to_L := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1), 
			  Vector2i(0, 2), Vector2i(1, 2)]
var _from_L := [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, 1), 
				Vector2i(0, -2), Vector2i(1, -2)]
var rot_tests = [_to_R, _from_R, _from_R, _to_R, 
				 _to_L, _from_L, _from_L, _to_L]

# I piece rotation follows a different set of rules
var _i0_R := [Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), 
			  Vector2i(-2, 1), Vector2i(1, -2)]
var _iR_0 := [Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), 
			  Vector2i(2, -1), Vector2i(-1, 2)]
var _iR_2 := [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), 
			  Vector2i(-1, -2), Vector2i(2, 1)]
var _i2_R := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), 
			  Vector2i(1, 2), Vector2i(-2, -1)]
var _i2_L := [Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), 
			  Vector2i(2, -1), Vector2i(-1, +2)]
var _iL_2 := [Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), 
			  Vector2i(-2, 1), Vector2i(1, -2)]
var _iL_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), 
			  Vector2i(1, 2), Vector2i(-2, -1)]
var _i0_L := [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), 
			  Vector2i(-1, -2), Vector2i(2, 1)]
var i_rot_tests = [_i0_R, _iR_0, _iR_2, _i2_R, _i2_L, _iL_2, _iL_0, _i0_L]

# test indices correspond to [0->R, R->0, R->2, 2->R, 2->L, L->2, L->0, 0->L]

# indices need to match order of squares in TileSet
var shapes := [I, T, O, Z, S, L, J]
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
			rotate_piece(false)
		elif Input.is_action_just_pressed("ui_up"):
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
	var kick = can_rotate(is_clockwise)
	if kick == null:  # cancel rotation if cannot rotated
		return
	var mod = 1 if is_clockwise else -1
	clear_ghost()
	clear_piece()
	rotation_index = (rotation_index + mod) % 4
	active_piece = piece_type[rotation_index]
	cur_pos += kick  # adjust cursor position by the amount of kick needed
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

# checks if piece is able to rotate freely
#  if a test passes, returns the distance needed to kick the piece
func can_rotate(is_clockwise):
	var mod = 1 if is_clockwise else -1
	var temp_rotation_index = (rotation_index + mod) % 4
	var rot_test = _get_rot_test(is_clockwise)
	for test in rot_test:
		var passed = true
		for i in piece_type[temp_rotation_index]:
			if not is_free(i + cur_pos + test):
				passed = false
				break
		if passed:
			return test
	return null

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

# helper to find which rotation tests to perform in the given state
#  There's definitely a way to make this a more concise formula 
#  but the match statements are much more readable
func _get_rot_test(is_clockwise):
	var index
	# print(rotation_index)
	if is_clockwise: # 0->R, R->2, 2->L, L->0
		match rotation_index:
			0, -4: index = 0
			1, -3: index = 2
			2, -2: index = 4
			3, -1: index = 6
			_: print("This should never happen")
	else:  # 0->L, L->2, 2->R, R->0
		match rotation_index:
			0, -4: index = 7
			1, -3: index = 5
			2, -2: index = 3
			3, -1: index = 1
			_: print("This should never happen")
	if piece_type == I:
		return i_rot_tests[index]
	else:
		return rot_tests[index]
