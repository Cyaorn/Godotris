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
var speed : float
var fall_speed : int
var horizontal_speed : int

# game piece variables
var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

# tilemap variables
var tile_id : int = 1
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

# game variables
var is_running : bool = true

func _ready():
	new_game()
	$board/HUD/StartGameButton.pressed.connect(new_game)
	
func new_game(): 
	# reset variables
	speed = 1.0
	fall_speed = 10
	horizontal_speed = 10
	steps = [0, 0, 0] # [left, right, down]
	is_running = true
	$board/HUD/GameOverLabel.hide()
	BoardLayer.reset_score()
	
	# clear everything
	clear_piece()
	clear_board()
	clear_panel()
	
	piece_type = pick_piece()
	piece_atlas = Vector2i(shapes.find(piece_type), 0)
	next_piece_type = pick_piece()
	next_piece_atlas = Vector2i(shapes.find(next_piece_type), 0)
	create_piece()
	
func _process(_delta):
	'''
	Future implementation would probably involve using just_pressed for
	single-tap movement with a buffer timer before allowing full left or right
	movement
	'''
	if (is_running):
		if Input.is_action_pressed("ui_left"):
			steps[0] += horizontal_speed
		elif Input.is_action_pressed("ui_right"):
			steps[1] += horizontal_speed
		# enables single-tap to always travel 1 square max
		# if horizontal_speed is too fast holding might feel too slippery
		elif Input.is_action_just_released("ui_left"):
			steps[0] = steps_req + 1
		elif Input.is_action_just_released("ui_right"):
			steps[1] = steps_req + 1
		# ------------------------------------------------
		elif Input.is_action_pressed("ui_down"):
			steps[2] += fall_speed
		elif Input.is_action_just_pressed("ui_up"):
			pass # hard drop
			
		# must add these to the Input Map in Project > Settings
		if Input.is_action_just_pressed("ui_q"):
			if can_rotate(false):
				rotate_piece(false)
		elif Input.is_action_just_pressed("ui_e"):
			if can_rotate(true):
				rotate_piece(true)
		
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
	rotation_index = 0
	cur_pos = start_pos
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)
	
	# draw upcoming piece also
	draw_piece(next_piece_type[0], Vector2i(15, 10), next_piece_atlas)
	
func clear_piece():
	for i in active_piece:
		erase_cell(cur_pos + i)

func draw_piece(piece, pos, atlas):
	for i in piece:
		set_cell(pos + i, tile_id, atlas)

func rotate_piece(is_clockwise):
	var mod = 1 if is_clockwise else -1
	clear_piece()
	rotation_index = (rotation_index + mod) % 4
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)

func move_piece(dir):
	if can_move(dir):
		clear_piece()
		cur_pos += dir
		draw_piece(active_piece, cur_pos, piece_atlas)
	else:
		if dir == Vector2i.DOWN:
			land_piece()
			BoardLayer.check_rows()
			piece_type = next_piece_type
			piece_atlas = next_piece_atlas
			next_piece_type = pick_piece()
			next_piece_atlas = Vector2i(shapes.find(next_piece_type), 0)
			clear_panel()
			create_piece()
			check_game_over()

func can_move(dir):
	# check if there is space to move
	for i in active_piece:
		if not is_free(i + cur_pos + dir):
			return false
	return true

# will replace with wall kick implementation later
func can_rotate(is_clockwise):
	var mod = 1 if is_clockwise else -1
	var temp_rotation_index = (rotation_index + mod) % 4
	for i in piece_type[temp_rotation_index]:
		if not is_free(i + cur_pos):
			return false
	return true

func is_free(pos):
	return BoardLayer.is_free(pos)

func land_piece():
	# transfer cells from active layer to board layer
	for i in active_piece:
		erase_cell(cur_pos + i)
		BoardLayer.set_cell(cur_pos + i, tile_id, piece_atlas)
		
func clear_panel():
	for i in range(14, 19):
		for j in range(9, 13):
			erase_cell(Vector2i(i, j))
			
func clear_board():
	BoardLayer.clear_board()
	
func check_game_over():
	for i in active_piece:
		if not is_free(i + cur_pos):
			land_piece()
			$board/HUD/GameOverLabel.show()
			is_running = false
