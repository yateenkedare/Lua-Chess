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

movePiece("k0", {6, 3})

printBoard()

movePiece("k0", {6, 4})

printBoard()

movePiece("k0", {6, 4})

printBoard()

--movePiece("p0")

