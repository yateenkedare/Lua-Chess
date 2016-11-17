-- co-ordinate axis starts from top left like
-- this is done so that integration with front-end will be easier since we
-- are using graphics library
-- Capital letters signify Black Pieces small letters are for White Pieces
--     0   1   2   3   4   5   6   7
-- 0   R0  H0  B0  Q0  K0  B1  H1  R1
-- 1   P0  P1  P2  P3  P4  P5  P6  P7
-- 2
-- 3
-- 4
-- 5
-- 6   p0  p1  p2  p3  p4  p5  p6  p7
-- 7   r0  h0  b0  q0  k0  b1  h1  r1
-- The variable turn defines whose turn it is
-- 0 - BlacksTurn
-- 1 - WhitesTurn

--strings used more than once
STR_INVALID_MOVE = "That is not a valid choice,\nplease try again."
STR_PROMOTE = "What piece would you\nlike to promote\nthis pawn to?"
STR_SELF_CHECK = "You may not place\nyourself in check,\nplease try again."

local M = {}

function updateMVariables()
  M.board = board
  M.gameOver = gameOver
  M.displayString = displayString
  M.turn = turn
end

function setupBoard()
  turn = 1
	board = {}
	for i = 0, 7 do
		board[i] = {}
		for j = 0, 7 do
			board[i][j] = "0"
		end
	end
	board[0][0] = "R0"
	board[0][1] = "H0"
	board[0][2] = "B0"
	board[0][3] = "Q0"
	board[0][4] = "K0"
	board[0][5] = "B1"
	board[0][6] = "H1"
	board[0][7] = "R1"

	board[1][0] = "P0"
	board[1][1] = "P1"
	board[1][2] = "P2"
	board[1][3] = "P3"
	board[1][4] = "P4"
	board[1][5] = "P5"
	board[1][6] = "P6"
	board[1][7] = "P7"

	board[6][0] = "p0"
	board[6][1] = "p1"
	board[6][2] = "p2"
	board[6][3] = "p3"
	board[6][4] = "p4"
	board[6][5] = "p5"
	board[6][6] = "p6"
	board[6][7] = "p7"

	board[7][0] = "r0"
	board[7][1] = "h0"
	board[7][2] = "b0"
	board[7][3] = "q0"
	board[7][4] = "k0"
	board[7][5] = "b1"
	board[7][6] = "h1"
	board[7][7] = "r1"

  --Castling variables
	R0move = false
	R1move = false
	K0move = false
	r0move = false
	r1move = false
	k0move = false

	sim = false

  displayString = " "
  gameOver = false
  updateMVariables()
end

function copyBoard()
	copy = {}
	for i = 0, 7 do
		copy[i] = {}
		for j = 0, 7 do
			copy[i][j] = board[i][j]
		end
	end
	return copy
end

function copyBack(copy1)
	for i = 0, 7 do
		for j = 0, 7 do
			board[i][j] = copy1[i][j]
		end
	end
end

function pieceLoc(piece)
	for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] == piece then
				return {i, j}
			end
		end
	end
end

function occupied(pos, piece)
	--NOTE: May want to add inBounds check here.
	if piece == string.lower(piece) then
		side = "w"
	else
		side = "b"
	end
	if board[pos[1]][pos[2]] == "0" then
		return "n"
	else
		if board[pos[1]][pos[2]] == string.lower(board[pos[1]][pos[2]]) then
			if side == "w" then
				return "a"
			else
				return "e"
			end
		else
			if side == "w" then
				return "e"
			else
				return "a"
			end
		end
	end
end

function inTable(table, e)
	for _, val in pairs(table) do
		if val == e then
			return true
		end
	end
	return false
end

function castle(piece, square)
	c = copyBoard()
	lower = piece:sub(1, 1) == "k"
	for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] ~= "0" and (string.lower(board[i][j]:sub(1, 1)) == board[i][j]:sub(1, 1)) ~= lower then
				if movePiece(board[i][j], square) == true then
					copyBack(c)
					return true
				end
			end
		end
	end
	return false
end

function movePiece(piece, pos)
	local loc = pieceLoc(piece)
	count = 0
	empty = true
	--NOTE: Add logic for not being able to move on same spot.
	if piece:sub(1, 1) == "p" then
		if loc[1] == 6 and pos[1] == loc[1] - 2 and loc[2] == pos[2] and occupied(pos, piece) == "n" and occupied({pos[1] + 1, pos[2]}, piece) == "n"then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			insert = true
		elseif pos[1] == loc[1] - 1 and loc[2] == pos[2] and occupied(pos, piece) == "n" then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] - 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) == "e" then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] - 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and inTable(pawns, board[pos[1] + 1][pos[2]]) then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			board[pos[1] + 1][pos[2]] = "0"
		else
			return false
			--print("That move is invalid, please try again.")
		end
		if pieceLoc(piece)[1] == 0 and sim == false then
			while true do
				--promotion string
				displayString = STR_PROMOTE
				input = io.read()
				count = 0
				if string.lower(input) == "queen" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "q" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "q" .. count
					break
				elseif string.lower(input) == "rook" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "r" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "r" .. count
					break
				elseif string.lower(input) == "knight" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "h" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "h" .. count
					break
				elseif string.lower(input) == "bishop" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "b" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "b" .. count
					break
				else
					--invalid move
					displayString = STR_INVALID_MOVE
				end
			end
		end
	elseif piece:sub(1, 1) == "P" then
		if loc[1] == 1 and pos[1] == loc[1] + 2 and loc[2] == pos[2] and occupied(pos, piece) == "n" and occupied({pos[1] - 1, pos[2]}, piece) == "n" then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			insert = true
		elseif (pos[1] == loc[1] + 1 and loc[2] == pos[2] and occupied(pos, piece) == "n") or
		(pos[1] == loc[1] + 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) == "e") then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] + 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and inTable(pawns, board[pos[1] - 1][pos[2]]) then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			board[pos[1] - 1][pos[2]] = "0"
		else
			return false
			--print("That move is invalid, please try again.")
		end
		if pieceLoc(piece)[1] == 7 and sim == false then
			while true do
				--promotion string
				displayString = STR_PROMOTE
				input = io.read()
				count = 0
				if string.lower(input) == "queen" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "Q" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "Q" .. count
					break
				elseif string.lower(input) == "rook" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "R" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "R" .. count
					break
				elseif string.lower(input) == "knight" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "H" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "H" .. count
					break
				elseif string.lower(input) == "bishop" then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "B" then
								count = count + 1
							end
						end
					end
					board[pos[1]][pos[2]] = "B" .. count
					break
				else
					--invalid move
					displayString = STR_INVALID_MOVE
				end
			end
		end
	elseif string.lower(piece:sub(1, 1)) == "r" then
		if pos[1] == loc[1] and pos[2] > loc[2] and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1], loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
				if piece:sub(1, 1) == "r" then
					if piece:sub(2, 2) == "0" then
						r0move = true
					elseif piece:sub(2, 2) == "1" then
						r1move = true
					end
				elseif piece:sub(1, 1) == "R" then
					if piece:sub(2, 2) == "0" then
						R0move = true
					elseif piece:sub(2, 2) == "1" then
						R1move = true
					end
				end
			end
		elseif pos[2] == loc[2] and pos[1] > loc[1] and occupied(pos, piece) ~= "a" then
			while loc[1] + count + 1 < pos[1] do
				if occupied({loc[1] + count + 1, loc[2]}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
				if piece:sub(1, 1) == "r" then
					if piece:sub(2, 2) == "0" then
						r0move = true
					elseif piece:sub(2, 2) == "1" then
						r1move = true
					end
				elseif piece:sub(1, 1) == "R" then
					if piece:sub(2, 2) == "0" then
						R0move = true
					elseif piece:sub(2, 2) == "1" then
						R1move = true
					end
				end
			end
		elseif pos[1] == loc[1] and pos[2] < loc[2] and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1], loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
				if piece:sub(1, 1) == "r" then
					if piece:sub(2, 2) == "0" then
						r0move = true
					elseif piece:sub(2, 2) == "1" then
						r1move = true
					end
				elseif piece:sub(1, 1) == "R" then
					if piece:sub(2, 2) == "0" then
						R0move = true
					elseif piece:sub(2, 2) == "1" then
						R1move = true
					end
				end
			end
		elseif pos[2] == loc[2] and pos[1] < loc[1] and occupied(pos, piece) ~= "a" then
			while loc[1] - count - 1 > pos[1] do
				if occupied({loc[1] - count - 1, loc[2]}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
				if piece:sub(1, 1) == "r" then
					if piece:sub(2, 2) == "0" then
						r0move = true
					elseif piece:sub(2, 2) == "1" then
						r1move = true
					end
				elseif piece:sub(1, 1) == "R" then
					if piece:sub(2, 2) == "0" then
						R0move = true
					elseif piece:sub(2, 2) == "1" then
						R1move = true
					end
				end
			end
		else
			empty = false
		end
		if empty == false then
			return false
			--print("That move is invalid, please try again.")
		end
	elseif string.lower(piece:sub(1, 1)) == "h" then
		if ((pos[1] == loc[1] + 2 or pos[1] == loc[1] - 2) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) ~= "a") or
		((pos[1] == loc[1] + 1 or pos[1] == loc[1] - 1) and (pos[2] == loc[2] - 2 or pos[2] == loc[2] + 2) and occupied(pos, piece) ~= "a") then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
		else
			return false
			--print("That move is invalid, please try again.")
		end
	end
	if string.lower(piece:sub(1, 1)) == "b" then
		if loc[1] - pos[1] == loc[2] - pos[2] and loc[1] - pos[1] > 0 and loc[2] - pos[2] > 0 and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1] - count - 1, loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == loc[2] - pos[2] and loc[1] - pos[1] < 0 and loc[2] - pos[2] < 0 and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1] + count + 1, loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == -(loc[2] - pos[2]) and loc[1] - pos[1] > 0 and loc[2] - pos[2] < 0 and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1] - count - 1, loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == -(loc[2] - pos[2]) and loc[1] - pos[1] < 0 and loc[2] - pos[2] > 0 and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1] + count + 1, loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		else
			empty = false
		end
		if empty == false then
			return false
			--print("That move is invalid, please try again.")
		end
	elseif string.lower(piece:sub(1, 1)) == "q" then
		if pos[1] == loc[1] and pos[2] > loc[2] and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1], loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif pos[2] == loc[2] and pos[1] > loc[1] and occupied(pos, piece) ~= "a" then
			while loc[1] + count + 1 < pos[1] do
				if occupied({loc[1] + count + 1, loc[2]}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif pos[1] == loc[1] and pos[2] < loc[2] and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1], loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif pos[2] == loc[2] and pos[1] < loc[1] and occupied(pos, piece) ~= "a" then
			while loc[1] - count - 1 > pos[1] do
				if occupied({loc[1] - count - 1, loc[2]}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == loc[2] - pos[2] and loc[1] - pos[1] > 0 and loc[2] - pos[2] > 0 and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1] - count - 1, loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == loc[2] - pos[2] and loc[1] - pos[1] < 0 and loc[2] - pos[2] < 0 and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1] + count + 1, loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == -(loc[2] - pos[2]) and loc[1] - pos[1] > 0 and loc[2] - pos[2] < 0 and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1] - count - 1, loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		elseif loc[1] - pos[1] == -(loc[2] - pos[2]) and loc[1] - pos[1] < 0 and loc[2] - pos[2] > 0 and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1] + count + 1, loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "0"
				board[pos[1]][pos[2]] = piece
			end
		else
			empty = false
		end
		if empty == false then
			return false
			--print("That move is invalid, please try again.")
		end
	elseif piece:sub(1, 1) == "K" then
		if (pos[1] == loc[1] - 1 or pos[1] == loc[1] + 1 or pos[1] == loc[1]) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1 or pos[2] == loc[2]) and occupied(pos, piece) ~= "a" then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			K0move = true
		elseif K0move == false and R0move == false and occupied({0, 3}, piece) == "n" and occupied({0, 2}, piece) == "n" and occupied({0, 1}, piece) == "n" and pos[1] == 0 and pos[2] == 2 and castle(piece, {0, 3}) and castle(piece, {0, 2}) and castle(piece, {0, 1}) then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			board[0][0] = "0"
			board[0][3] = "R0"
			K0move = true
			R0move = true
		elseif K0move == false and R1move == false and occupied({0, 5}, piece) == "n" and occupied({0, 6}, piece) == "n" and pos[1] == 0 and pos[2] == 6 and castle(piece, {0, 5}) and castle(piece, {0, 6}) then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			board[0][7] = "0"
			board[0][5] = "R1"
			K0move = true
			R1move = true
		else
			return false
			--print("That move is invalid, please try again.")
		end
	elseif piece:sub(1, 1) == "k" then
		if (pos[1] == loc[1] - 1 or pos[1] == loc[1] + 1 or pos[1] == loc[1]) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1 or pos[2] == loc[2]) and occupied(pos, piece) ~= "a" then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			K0move = true
		elseif k0move == false and r0move == false and occupied({7, 3}, piece) == "n" and occupied({7, 2}, piece) == "n" and occupied({7, 1}, piece) == "n" and pos[1] == 7 and pos[2] == 2 and castle(piece, {7, 3}) and castle(piece, {7, 2}) and castle(piece, {7, 1}) then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			board[7][0] = "0"
			board[7][3] = "r0"
			k0move = true
			r0move = true
		elseif k0move == false and r1move == false and occupied({7, 5}, piece) == "n" and occupied({7, 6}, piece) == "n" and pos[1] == 7 and pos[2] == 6 and castle(piece, {7, 5}) and castle(piece, {7, 6}) then
			board[loc[1]][loc[2]] = "0"
			board[pos[1]][pos[2]] = piece
			board[7][7] = "0"
			board[7][5] = "r1"
			k0move = true
			r1move = true
		else
			return false
			--print("That move is invalid, please try again.")
		end
	end
	pawns = {}
	if insert == true then
		table.insert(pawns, piece)
		insert = false
	end
	return true
end

function check(piece)
	c = copyBoard()
	place = pieceLoc(piece)
	lower = piece:sub(1, 1) == "k"
	for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] ~= "0" and (string.lower(board[i][j]:sub(1, 1)) == board[i][j]:sub(1, 1)) ~= lower then
				if movePiece(board[i][j], place) == true then
					copyBack(c)
					return true
				end
			end
		end
	end
	return false
end

function checkmate(piece)
	d = copyBoard()
	place = pieceLoc(piece)
	lower = piece:sub(1, 1) == "k"
	for x = 0, 7 do
		for y = 0, 7 do
			if board[x][y] ~= "0" and (string.lower(board[x][y]:sub(1, 1)) == board[x][y]:sub(1, 1)) == lower then
				for k = 0, 7 do
					for l = 0, 7 do
						if movePiece(board[x][y], {k, l}) == true then
							if check(piece) == false then
								copyBack(d)
								return false
							end
							copyBack(d)
						end
					end
				end
			end
		end
	end
	if lower then
		displayString = "Checkmate, Black wins!"
	else
		displayString = "Checkmate, White wins!"
	end
	gameOver = true
end

local function WhitesTurn()
  wPos = _G.wPos
  wPiece = _G.wPiece
  e = copyBoard()
  success = movePiece(wPiece, wPos)
  if not success then
    displayString = STR_INVALID_MOVE
  else
    sim = true
    if check("k0") then
	  --self check string
      displayString = STR_SELF_CHECK
      success = false
      copyBack(e)
    elseif check("K0") then
      if not checkmate("K0") then
        displayString = "Black is in check."
      end
    sim = false
    end
  end
  if success then
    turn = 0
    displayString = " "
  else turn = 1
  end
  updateMVariables()
end

local function BlacksTurn()
  wPos = _G.wPos
  wPiece = _G.wPiece
  success = movePiece(wPiece, wPos)
  if not success then
    displayString = STR_INVALID_MOVE
  else
    sim = true
    if check("K0") then
	  --self check string
      displayString = STR_SELF_CHECK
      success = false
      copyBack(e)
    elseif check("k0") then
      if not checkmate("k0") then
        displayString = "White is in check."
      end
    sim = false
    end
  end
  if success then
    turn = 1
    displayString = " "
  else turn = 0
  end
  updateMVariables()
end

-- functions and variables for public access
M.setupBoard = setupBoard
M.WhitesTurn = WhitesTurn
M.BlacksTurn = BlacksTurn
updateMVariables()
return M
