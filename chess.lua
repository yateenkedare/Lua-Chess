function setupBoard()
	board = {}
	for i = 0, 7 do
		board[i] = {}
		for j = 0, 7 do
			board[i][j] = "  "
		end
	end

	--NOTE: Switch king and queen positions.
	board[0][0] = "R0"
	--board[0][1] = "H0"
	board[0][2] = "B0"
	board[0][3] = "K0"
	board[0][4] = "Q0"
	board[0][5] = "B1"
	board[0][6] = "H1"
	board[0][7] = "R1"

	board[1][0] = "P0"
	--board[1][1] = "P1"
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
	--board[7][1] = "h0"
	board[7][1] = "  "
	--board[7][2] = "b0"
	board[7][2] = "  "
	board[7][3] = "k0"
	board[7][4] = "q0"
	board[7][5] = "b1"
	board[7][6] = "h1"
	board[7][7] = "r1"
end

function printBoard()
	print("\n    00 01 02 03 04 05 06 07")
	print("   +--+--+--+--+--+--+--+--+")
	for i = 0, 7 do
		io.write("0", i, " ")
		for j = 0, 7 do
			io.write("|", board[i][j])
		end
		print("|")
		print("   +--+--+--+--+--+--+--+--+")
	end
	print()
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
	if board[pos[1]][pos[2]] == "  " then
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

--Unused since GUI implementation can't go out of bounds.
function inBounds(pos)
	if 0 <= pos[1] and pos[1] <= 7 and 0 <= pos[2]and pos[2] <= 7 then
		return true
	else
		return false
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

function movePiece(piece, pos)
	loc = pieceLoc(piece)
	count = 0
	empty = true
	--NOTE: Add logic for not being able to move on same spot.
	if piece:sub(1, 1) == "p" then
		if loc[1] == 6 and pos[1] == loc[1] - 2 and loc[2] == pos[2] and occupied(pos, piece) == "n" and occupied({pos[1] + 1, pos[2]}, piece) == "n"then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			insert = true
		elseif pos[1] == loc[1] - 1 and loc[2] == pos[2] and occupied(pos, piece) == "n" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] - 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) == "e" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] - 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and inTable(pawns, board[pos[1] + 1][pos[2]]) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[pos[1] + 1][pos[2]] = "  "
		else
			print("That move is invalid, please try again.")
		end
		if pieceLoc(piece)[1] == 0 then
			while true do
				print("What piece would you like to promote this pawn to?")
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
					print("That is not a valid choice, please try again.")
				end
			end
		end
	end
	if piece:sub(1, 1) == "P" then
		if loc[1] == 1 and pos[1] == loc[1] + 2 and loc[2] == pos[2] and occupied(pos, piece) == "n" and occupied({pos[1] - 1, pos[2]}, piece) == "n" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			insert = true
		elseif (pos[1] == loc[1] + 1 and loc[2] == pos[2] and occupied(pos, piece) == "n") or
		(pos[1] == loc[1] + 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) == "e") then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] + 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and inTable(pawns, board[pos[1] - 1][pos[2]]) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[pos[1] - 1][pos[2]] = "  "
		else
			print("That move is invalid, please try again.")
		end
		if pieceLoc(piece)[1] == 7 then
			while true do
				print("What piece would you like to promote this pawn to?")
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
					print("That is not a valid choice, please try again.")
				end
			end
		end
	end
	if string.lower(piece:sub(1, 1)) == "r" then
		if ((pos[1] == loc[1] and pos[2] > loc[2]) or (pos[2] == loc[2] and pos[1] > loc[1])) and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1], loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "  "
				board[pos[1]][pos[2]] = piece
			end
		elseif ((pos[1] == loc[1] and pos[2] < loc[2]) or (pos[2] == loc[2] and pos[1] < loc[1])) and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1], loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "  "
				board[pos[1]][pos[2]] = piece
			end
		else
			empty = false
		end
		if empty == false then
			print("That move is invalid, please try again.")
		end
	end
	if string.lower(piece:sub(1, 1)) == "h" then
		if ((pos[1] == loc[1] + 2 or pos[1] == loc[1] - 2) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) ~= "a") or
		((pos[1] == loc[1] + 1 or pos[1] == loc[1] - 1) and (pos[2] == loc[2] - 2 or pos[2] == loc[2] + 2) and occupied(pos, piece) ~= "a") then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		else
			print("That move is invalid, please try again.")
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
				board[pos[1]][pos[2]] = piece
			end
		else
			empty = false
		end
		if empty == false then
			print("That move is invalid, please try again.")
		end
	end
	if string.lower(piece:sub(1, 1)) == "q" then
		if ((pos[1] == loc[1] and pos[2] > loc[2]) or (pos[2] == loc[2] and pos[1] > loc[1])) and occupied(pos, piece) ~= "a" then
			while loc[2] + count + 1 < pos[2] do
				if occupied({loc[1], loc[2] + count + 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "  "
				board[pos[1]][pos[2]] = piece
			end
		elseif ((pos[1] == loc[1] and pos[2] < loc[2]) or (pos[2] == loc[2] and pos[1] < loc[1])) and occupied(pos, piece) ~= "a" then
			while loc[2] - count - 1 > pos[2] do
				if occupied({loc[1], loc[2] - count - 1}, piece) ~= "n" then
					empty = false
				end
				count = count + 1
			end
			if empty == true then
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
				board[pos[1]][pos[2]] = piece
			end
		else
			empty = false
		end
		if empty == false then
			print("That move is invalid, please try again.")
		end
	end
	if string.lower(piece:sub(1, 1)) == "k" then
		if (pos[1] == loc[1] - 1 or pos[1] == loc[1] + 1 or pos[1] == loc[1]) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1 or pos[2] == loc[2]) and occupied(pos, piece) ~= "a" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		else
			print("That move is invalid, please try again.")
		end
	end
	pawns = {}
	if insert == true then
		table.insert(pawns, piece)
		insert = false
	end
end

setupBoard()

printBoard()

print(pieceLoc("h1")[1])
print(pieceLoc("h1")[2])

print(occupied({7, 1}, "r0") ~= "a")

movePiece("p1", {4, 1})

print(inBounds({7, 1}))

printBoard()

movePiece("p1", {3, 1})

printBoard()

movePiece("p1", {2, 1})

printBoard()

movePiece("p1", {1, 1})

printBoard()

movePiece("P2", {3, 2})

printBoard()

movePiece("P2", {4, 2})

printBoard()

movePiece("p3", {4, 3})

printBoard()

movePiece("p4", {4, 4})

printBoard()

movePiece("P2", {5, 3})

printBoard()

--movePiece("p1", {0, 1})

--printBoard()

movePiece("r0", {7, 3})

printBoard()

movePiece("r0", {5, 1})

printBoard()

movePiece("r0", {7, 1})

function setUpBoard()
	board = {}
	for i = 0, 7 do
		board[i] = {}
		for j = 0, 7 do
			board[i][j] = "  "
		end
	end

	board[0][0] = "R0"
	board[0][1] = "H0"
	--board[0][1] = "  "
	board[0][2] = "B0"
	--board[0][2] = "  "
	board[0][3] = "Q0"
	--board[0][3] = "  "
	board[0][4] = "K0"
	board[0][5] = "B1"
	--board[0][5] = "  "
	board[0][6] = "H1"
	board[0][7] = "R1"

	board[1][0] = "P0"
	board[1][1] = "P1"
	--board[1][1] = "  "
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
	--board[7][1] = "  "
	board[7][2] = "b0"
	--board[7][2] = "  "
	board[7][3] = "q0"
	board[7][4] = "k0"
	board[7][5] = "b1"
	board[7][6] = "h1"
	--board[7][6] = "  "
	board[7][7] = "r1"

	--Castling variables
	R0move = false
	R1move = false
	K0move = false
	r0move = false
	r1move = false
	k0move = false

	sim = false
end

function printBoard()
	print("\n    00 01 02 03 04 05 06 07")
	print("   +--+--+--+--+--+--+--+--+")
	for i = 0, 7 do
		io.write("0", i, " ")
		for j = 0, 7 do
			io.write("|", board[i][j])
		end
		print("|")
		print("   +--+--+--+--+--+--+--+--+")
	end
	print()
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

function printCopy()
	print("\n    00 01 02 03 04 05 06 07")
	print("   +--+--+--+--+--+--+--+--+")
	for i = 0, 7 do
		io.write("0", i, " ")
		for j = 0, 7 do
			io.write("|", copy[i][j])
		end
		print("|")
		print("   +--+--+--+--+--+--+--+--+")
	end
	print()
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
	if board[pos[1]][pos[2]] == "  " then
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

--Unused since GUI implementation can't go out of bounds.
function inBounds(pos)
	if 0 <= pos[1] and pos[1] <= 7 and 0 <= pos[2]and pos[2] <= 7 then
		return true
	else
		return false
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
			if board[i][j] ~= "  " and (string.lower(board[i][j]:sub(1, 1)) == board[i][j]:sub(1, 1)) ~= lower then
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
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			insert = true
		elseif pos[1] == loc[1] - 1 and loc[2] == pos[2] and occupied(pos, piece) == "n" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] - 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) == "e" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] - 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and inTable(pawns, board[pos[1] + 1][pos[2]]) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[pos[1] + 1][pos[2]] = "  "
		else
			return false
			--print("That move is invalid, please try again.")
		end
		if pieceLoc(piece)[1] == 0 and sim == false then
			while true do
				print("What piece would you like to promote this pawn to?")
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
					print("That is not a valid choice, please try again.")
				end
			end
		end
	elseif piece:sub(1, 1) == "P" then
		if loc[1] == 1 and pos[1] == loc[1] + 2 and loc[2] == pos[2] and occupied(pos, piece) == "n" and occupied({pos[1] - 1, pos[2]}, piece) == "n" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			insert = true
		elseif (pos[1] == loc[1] + 1 and loc[2] == pos[2] and occupied(pos, piece) == "n") or
		(pos[1] == loc[1] + 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) == "e") then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		elseif pos[1] == loc[1] + 1 and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and inTable(pawns, board[pos[1] - 1][pos[2]]) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[pos[1] - 1][pos[2]] = "  "
		else
			return false
			--print("That move is invalid, please try again.")
		end
		if pieceLoc(piece)[1] == 7 and sim == false then
			while true do
				print("What piece would you like to promote this pawn to?")
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
					print("That is not a valid choice, please try again.")
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
			board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
				board[loc[1]][loc[2]] = "  "
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
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			K0move = true
		elseif K0move == false and R0move == false and occupied({0, 3}, piece) == "n" and occupied({0, 2}, piece) == "n" and occupied({0, 1}, piece) == "n" and pos[1] == 0 and pos[2] == 2 and castle(piece, {0, 3}) and castle(piece, {0, 2}) and castle(piece, {0, 1}) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[0][0] = "  "
			board[0][3] = "R0"
			K0move = true
			R0move = true
		elseif K0move == false and R1move == false and occupied({0, 5}, piece) == "n" and occupied({0, 6}, piece) == "n" and pos[1] == 0 and pos[2] == 6 and castle(piece, {0, 5}) and castle(piece, {0, 6}) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[0][7] = "  "
			board[0][5] = "R1"
			K0move = true
			R1move = true
		else
			return false
			--print("That move is invalid, please try again.")
		end
	elseif piece:sub(1, 1) == "k" then
		if (pos[1] == loc[1] - 1 or pos[1] == loc[1] + 1 or pos[1] == loc[1]) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1 or pos[2] == loc[2]) and occupied(pos, piece) ~= "a" then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			K0move = true
		elseif k0move == false and r0move == false and occupied({7, 3}, piece) == "n" and occupied({7, 2}, piece) == "n" and occupied({7, 1}, piece) == "n" and pos[1] == 7 and pos[2] == 2 and castle(piece, {7, 3}) and castle(piece, {7, 2}) and castle(piece, {7, 1}) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[7][0] = "  "
			board[7][3] = "r0"
			k0move = true
			r0move = true
		elseif k0move == false and r1move == false and occupied({7, 5}, piece) == "n" and occupied({7, 6}, piece) == "n" and pos[1] == 7 and pos[2] == 6 and castle(piece, {7, 5}) and castle(piece, {7, 6}) then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
			board[7][7] = "  "
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
			if board[i][j] ~= "  " and (string.lower(board[i][j]:sub(1, 1)) == board[i][j]:sub(1, 1)) ~= lower then
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
			if board[x][y] ~= "  " and (string.lower(board[x][y]:sub(1, 1)) == board[x][y]:sub(1, 1)) == lower then
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
		print("Checkmate, Black wins!")
	else
		print("Checkmate, White wins!")
	end
	os.exit()
end

--When prompted to input a piece do so in the form of 'R0' or any other code visible on the board then press enter.
--Coordinates are entered in the form of '24' with 2 corresponding to the row and 4 corresponding to the column.
--NOTE: can move oppenents pieces during your turn, because the check for this should be in the GUI.
function main()
	setUpBoard()
	over = false
	while not over do
		success = false
		while not success do
			printBoard()
			print("White's turn, please enter a piece to move and then coordinates:")
			wPiece = io.read()
			wPos = io.read()
			e = copyBoard()
			success = movePiece(wPiece, {tonumber(wPos:sub(1, 1)), tonumber(wPos:sub(2, 2))})
			if not success then
				print("That move is invalid, please try again.")
			else
				sim = true
				if check("k0") then
					print("You may not place yourself in check, please try again.")
					success = false
					copyBack(e)
				elseif check("K0") then
					if not checkmate("K0") then
						print("Black is in check.")
					end
				sim = false
				end
			end
		end
		success = false
		while not success do
			printBoard()
			print("Black's turn, please enter a piece to move and then coordinates:")
			wPiece = io.read()
			wPos = io.read()
			success = movePiece(wPiece, {tonumber(wPos:sub(1, 1)), tonumber(wPos:sub(2, 2))})
			if not success then
				print("That move is invalid, please try again.")
			else
				sim = true
				if check("K0") then
					print("You may not place yourself in check, please try again.")
					success = false
					copyBack(e)
				elseif check("k0") then
					if not checkmate("k0") then
						print("Black is in check.")
					end
				sim = false
				end
			end
		end
	end
end

main()

setUpBoard()

printBoard()

test = copyBoard()

movePiece("p1", {5, 1})

printBoard()

printCopy()

copyBack(test)

printBoard()

--os.exit()

--print(pieceLoc("h1")[1])
--print(pieceLoc("h1")[2])

print(occupied({7, 1}, "r0") ~= "a")

movePiece("p1", {4, 1})

print(inBounds({7, 1}))

printBoard()

movePiece("p1", {3, 1})

printBoard()

movePiece("p1", {2, 1})

printBoard()

movePiece("p1", {1, 1})

printBoard()

movePiece("P2", {3, 2})

printBoard()

movePiece("P2", {4, 2})

printBoard()

movePiece("p3", {4, 3})

printBoard()

movePiece("p4", {4, 4})

printBoard()

movePiece("P2", {5, 3})

printBoard()

--movePiece("p1", {0, 1})

--printBoard()

movePiece("r0", {7, 3})

printBoard()

movePiece("r0", {5, 1})

printBoard()

movePiece("r0", {7, 1})

printBoard()

movePiece("P5", {3, 5})

printBoard()

movePiece("P5", {4, 4})

printBoard()

movePiece("H1", {2, 5})

printBoard()

movePiece("H1", {4, 6})

printBoard()

movePiece("H1", {6, 7})

printBoard()

--setupBoard()

--printBoard()

movePiece("b1", {4, 2})

printBoard()

movePiece("b1", {2, 4})

printBoard()

movePiece("b1", {6, 0})

printBoard()

movePiece("q0", {4, 4})

printBoard()

movePiece("q0", {2, 4})

printBoard()

movePiece("q0", {3, 3})

printBoard()

movePiece("q0", {3, 7})

printBoard()

--movePiece("k0", {6, 3})

--printBoard()

--movePiece("k0", {6, 4})

--printBoard()

--movePiece("k0", {6, 4})

--rintBoard()

movePiece("R1", {0, 6})

printBoard()

movePiece("R1", {0, 7})

printBoard()

movePiece("K0", {0, 6})

printBoard()

movePiece("k0", {7, 6})

printBoard()

movePiece("P6", {2, 6})

printBoard()

movePiece("B1", {2, 7})

printBoard()

movePiece("B1", {6, 3})

printBoard()

movePiece("R1", {0, 5})

printBoard()

movePiece("R1", {5, 5})

printBoard()

movePiece("R1", {5, 4})

printBoard()

movePiece("H1", {5, 5})

printBoard()

--movePiece("k0", {7, 3})

--printBoard()

movePiece("Q0", {7, 3})

printBoard()

movePiece("R0", {7, 0})

printBoard()

print(check("k0"))

print(checkmate("k0"))

--copyBack()

printBoard()

--movePiece("p0")


printBoard()

movePiece("q0", {3, 7})

printBoard()

movePiece("k0", {6, 3})

printBoard()

movePiece("k0", {6, 4})

printBoard()

movePiece("k0", {6, 4})

printBoard()

--movePiece("p0")

