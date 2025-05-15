extends Node

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
