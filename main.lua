--[[Function to create a 2D table that holds the state of the chess board.
It also holds variables for castling and en passant capture.]]
function setUpBoard()
	board = {}
	for i = 0, 7 do
		board[i] = {}
		for j = 0, 7 do
			board[i][j] = "  "
		end
	end

	--ASCII representations of chess pieces
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

	pawns = {}
end



--Creates a copy of the current game board.
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

--Replaces the current game board with a stored copy.
function copyBack(copy1)
	for i = 0, 7 do
		for j = 0, 7 do
			board[i][j] = copy1[i][j]
		end
	end
end

--Returns the coordinates of the given piece.
function pieceLoc(piece)
	for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] == piece then
				return {i, j}
			end
		end
	end
end

--[[Checks whether the given position is occupied. It checks for
empty spaces as well as ally and enemy pieces.]]
function occupied(pos, piece)
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

--Function to check if position is in board area.
function inBounds(pos)
	if 0 <= pos[1] and pos[1] <= 7 and 0 <= pos[2]and pos[2] <= 7 then
		return true
	else
		return false
	end
end

--[[Checks whether the given value is in a table.
Used for cheking if a pawn has moved or not.]]
function inTable(table, e)
	for _, val in pairs(table) do
		if val == e then
			return true
		end
	end
	return false
end

--[[A helper function for castling. Checks whether the space the king
moves through is under attack.]]
function castle(piece, square)
	c = copyBoard()
	lower = piece:sub(1, 1) == "k"
	for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] ~= "  " and (string.lower(board[i][j]:sub(1, 1)) == board[i][j]:sub(1, 1)) ~= lower then
				if movePiece(board[i][j], square) == true then
					copyBack(c)
					return false
				end
			end
		end
	end
	return true
end

--[[The function responsible for checking for valid moves and moving the pieces.
All pieces and their special moves (except promotion) are handled within this function.]]
function movePiece(piece, pos)
	local loc = pieceLoc(piece)
	count = 0
	empty = true
	--Logic for moving white pawns.
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
		end
		if pieceLoc(piece)[1] == 0 then
			promote = 1
			pLoc = pieceLoc(piece)
		end
	--Logic for moving black pawns.
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
		end
		if pieceLoc(piece)[1] == 7 then
			promote = 1
			pLoc = pieceLoc(piece)
		end
	--Logic for moving rooks.
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
		end
	--Logic for moving knights.
	elseif string.lower(piece:sub(1, 1)) == "h" then
		if ((pos[1] == loc[1] + 2 or pos[1] == loc[1] - 2) and (pos[2] == loc[2] - 1 or pos[2] == loc[2] + 1) and occupied(pos, piece) ~= "a") or
		((pos[1] == loc[1] + 1 or pos[1] == loc[1] - 1) and (pos[2] == loc[2] - 2 or pos[2] == loc[2] + 2) and occupied(pos, piece) ~= "a") then
			board[loc[1]][loc[2]] = "  "
			board[pos[1]][pos[2]] = piece
		else
			return false
		end
	end
	--Logic for moving bishops.
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
		end
	--Logic for moving queens.
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
		end
	--Logic for moving black king.
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
		end
	--Logic for moving white king.
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
		end
	end
	--Logic for checking pawn initial movement.
	if insert == true then
		table.insert(pawns, piece)
		insert = false
	end
	return true
end

--Function to check if a player is in check.
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

--Function to check if a player is in checkmate.
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
	return true
end

--Converts mouse coordinates to board coordinates.
function convertXYToBoardInts(x,y)
	return math.floor((x-70)/60), math.floor((y-60)/60)
end

--Function to display semi-transparent square above mouseovered piece.
function displayHoverBox(x,y)
	hoverXd, hoverYd = convertXYToBoardInts(x,y)
	hoverX = (hoverXd * 60) + 70;
	hoverY = (hoverYd * 60) + 56;

	string = "x : " .. math.floor((x-70)/60) .. " :: y: " .. math.floor((y-60)/60) .. "  HoverX : " .. hoverX .. "  hoverY : "..hoverY ;
end

--Matches each ASCII piece to its pictoral representation.
function drawPiece(piece,i,j)
  a = (j*60) + (x/10) + 7;
  b = (i*60) + (y/10)
  if string.match(piece, "R") then love.graphics.draw(blackRook,a,b);
  elseif string.match(piece, "H") then love.graphics.draw(blackKnight,a,b);
  elseif string.match(piece, "B") then love.graphics.draw(blackBishop,a,b);
  elseif string.match(piece, "K") then love.graphics.draw(blackKing, a,b);
  elseif string.match(piece, "Q") then love.graphics.draw(blackQueen, a,b);
  elseif string.match(piece, "P") then love.graphics.draw(blackPawn, a,b);
  elseif string.match(piece, "r") then love.graphics.draw(whiteRook, a,b);
  elseif string.match(piece, "h") then love.graphics.draw(whiteKnight, a,b);
  elseif string.match(piece, "b") then love.graphics.draw(whiteBishop, a,b);
  elseif string.match(piece, "k") then love.graphics.draw(whiteKing, a,b);
  elseif string.match(piece, "q") then love.graphics.draw(whiteQueen, a,b);
  elseif string.match(piece, "p") then love.graphics.draw(whitePawn, a,b);
  end
end

--Iterates through all spaces and calls the draw function for each piece.
function displayPieces()
  for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] ~= "0" then
        drawPiece(board[i][j],i,j);
      end
		end
	end
end

--[[A callback function provided by the Love game engine that is called continuously to draw the game.
It draws everything as well as contains the main game loop which switches players, displays instructions,
and controls the overall flow of the game.]]
function love.draw()

	love.graphics.draw(chessBoard, 24,9);
	if hoverXd >= 0 and hoverYd >= 0 and hoverXd <= 7 and hoverYd <= 7  then
		love.graphics.setColor(0, 255, 0, 80);
		love.graphics.rectangle( "fill", hoverX, hoverY, 60, 60 ,5);
		love.graphics.setColor(255, 255, 255);
	end
	if mousePressedi1 >= 0 and mousePressedj1 >= 0 and mousePressedi1 <= 7 and mousePressedj1 <= 7 and checkPressedTimes == 1 then
		love.graphics.setColor(0, 255, 0, 80);
		love.graphics.rectangle( "fill", solidX, solidY, 60, 60 ,5);
		love.graphics.setColor(255, 255, 255);
	end
	displayPieces();

	_promote_select = nil

	--if a pawn is waiting to get promoted, draw promotion icons
	if promote == 1 and (turn == 4 or turn == 5) then
		--check to see which promotion icon is selected
		q,w  = love.mouse.getPosition( )

		if q > 620 and q < 680 and w > 250 and w < 310 then
			_promote_select = 1
		elseif q > 700 and q < 760 and w > 250 and w < 310 then
			_promote_select = 2
		elseif q > 620 and q < 680 and w > 330 and w < 390 then
			_promote_select = 3
		elseif q > 700 and q < 760 and w > 330 and w < 390 then
			_promote_select = 4
		end


		--if the pawn is white (NOT CHECKED since black doesn't stand out against the background
		--if turn == 4 then

		--draw promotion icon larger if mouse is over it
		love.graphics.draw(whiteQueen, 620, 250, 0, _promote_select == 1 and 2.5 or 2, _promote_select == 1 and 2 or 1.6);
		love.graphics.draw(whiteRook, 700,250, 0, _promote_select == 2 and 2.5 or 2, _promote_select == 2 and 2 or 1.6);
		love.graphics.draw(whiteKnight, 620, 330, 0, _promote_select == 3 and 2.5 or 2, _promote_select == 3 and 2 or 1.6);
		love.graphics.draw(whiteBishop, 700, 330, 0, _promote_select == 4 and 2.5 or 2, _promote_select == 4 and 2 or 1.6);

		--[[else
			love.graphics.draw(blackRook, 620,250, 0, 2, 1.6);
			love.graphics.draw(blackKnight, 700, 250, 0, 2, 1.6);
			love.graphics.draw(blackBishop, 620, 330, 0, 2, 1.6);
			love.graphics.draw(blackQueen, 700, 330, 0, 2, 1.6);
		end]]

	end

	if turn == 0 then
		if i1 ~= nil and j1 ~= nil then
			if board[j1][i1] == "  " then
				i1, j1, i2, j2 = nil, nil, nil, nil
				checkPressedTimes = 0
			elseif not (string.lower(board[j1][i1]) == board[j1][i1]) then
				state = 1
				i1, j1, i2, j2 = nil, nil, nil, nil
				checkPressedTimes = 0
			elseif i2 ~= nil and j2 ~= nil then
				wPiece = board[j1][i1]
				wPos = {j2, i2}
				e = copyBoard()
				success = movePiece(wPiece, {wPos[1], wPos[2]})
				if not success then
					state = 2
					checkPressedTimes = 0
				else
					if check("k0") then
						state = 3
						checkPressedTimes = 0
						success = false
						copyBack(e)
					elseif promote == 1 then
						state = 6
						turn = 4
					elseif check("K0") then
						if not checkmate("K0") then
							state = 4
							turn = 1
						else
							state = 0
							turn = 3
						end
					else
						state = 0
						turn = 1
					end
				end
				i1, j1, i2, j2 = nil, nil, nil, nil
				checkPressedTimes = 0
			end
		end
	--Logic for Black player.
	elseif turn == 1 then
		if i1 ~= nil and j1 ~= nil then
			if board[j1][i1] == "  " then
				i1, j1, i2, j2 = nil, nil, nil, nil
				checkPressedTimes = 0
			elseif (string.lower(board[j1][i1]) == board[j1][i1]) then
				state = 1
				i1, j1, i2, j2 = nil, nil, nil, nil
				checkPressedTimes = 0
			elseif i2 ~= nil and j2 ~= nil then
				wPiece = board[j1][i1]
				wPos = {j2, i2}
				e = copyBoard()
				success = movePiece(wPiece, {wPos[1], wPos[2]})
				if not success then
					state = 2
					checkPressedTimes = 0
				else
					if check("K0") then
						state = 3
						checkPressedTimes = 0
						success = false
						copyBack(e)
					elseif promote == 1 then
						state = 6
						turn = 5
					elseif check("k0") then
						if not checkmate("k0") then
							state = 5
							turn = 0
						else
							state = 0
							turn = 2
						end
					else
						state = 0
						turn = 0
					end
				end
				i1, j1, i2, j2 = nil, nil, nil, nil
				checkPressedTimes = 0
			end
		end
	end

	if turn == 0 or turn == 4 then
		love.graphics.print("White's turn.", 600, 100);
	elseif turn == 1 then
		love.graphics.print("Black's turn.", 600, 100);
	elseif turn == 2 then
		love.graphics.print("Black wins.", 600, 120);
	elseif turn == 3 then
		love.graphics.print("White wins.", 600, 120);
	end
	if state == 1 then
		love.graphics.print("That is not your piece.", 600, 120);
	elseif state == 2 then
		love.graphics.print("That move is invalid.", 600, 120);
	elseif state == 3 then
		love.graphics.print("Can't move into check.", 600, 120);
	elseif state == 4 then
		love.graphics.print("Black is in check.", 600, 120);
	elseif state == 5 then
		love.graphics.print("White is in check.", 600, 120);
	elseif state == 6 then
		love.graphics.print("Choose a piece. Click", 600, 120);
		love.graphics.print("starting position of", 600, 140);
		love.graphics.print("piece to be promoted.", 600, 160);
	end

end

function love.mousepressed(x1,y1,button)
	mouseX, mouseY = convertXYToBoardInts(x1+10,y1-10);
	if inBounds({mouseX, mouseY}) then
		if button == 1 then
			if checkPressedTimes == 0 then
				i1,j1 = mouseX, mouseY;
				checkPressedTimes = 1;
				mousePressedi1,mousePressedj1 = mouseY, mouseX
			elseif checkPressedTimes == 1 then
				i2,j2  = mouseX, mouseY;
				checkPressedTimes = 0;
				mousePressedi1,mousePressedj1 = 9,9
			end
		end
	end

	--if pawn promotion is pending, promote to piece currently hovered over
	count = 0

	if promote == 1 then
		if turn == 4 then
			if _promote_select == 1 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "q" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "q" .. count
					promote = 0
					turn = 1
					state = 0
			elseif _promote_select == 2 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "r" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "r" .. count
					promote = 0
					turn = 1
					state = 0
			elseif _promote_select == 3 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "h" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "h" .. count
					promote = 0
					turn = 1
					state = 0
			elseif _promote_select == 4 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "b" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "b" .. count
					promote = 0
					turn = 1
					state = 0
			end
			if promote == 0 then
					if check("K0") then
						if not checkmate("K0") then
							state = 4
							turn = 1
						else
							state = 0
							turn = 3
						end
					else
						state = 0
						turn = 1
					end
			end
			i1, j1, i2, j2 = nil, nil, nil, nil
			checkPressedTimes = 0

	--Logic for promoting Black pawns.
		elseif turn == 5 then
			if _promote_select == 1 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "Q" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "Q" .. count
					promote = 0
					turn = 0
					state = 0
			elseif _promote_select == 2 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "R" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "R" .. count
					promote = 0
					turn = 0
					state = 0
			elseif _promote_select == 3 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "H" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "H" .. count
					promote = 0
					turn = 0
					state = 0
			elseif _promote_select == 4 then
					for i = 0, 7 do
						for j = 0, 7 do
							if board[i][j]:sub(1, 1) == "B" then
								count = count + 1
							end
						end
					end
					board[pLoc[1]][pLoc[2]] = "B" .. count
					promote = 0
					turn = 0
					state = 0
			end
			if promote == 0 then
					if check("K0") then
						if not checkmate("k0") then
							state = 4
							turn = 0
						else
							state = 0
							turn = 2
						end
					else
						state = 0
						turn = 0
					end
			end
			i1, j1, i2, j2 = nil, nil, nil, nil
			checkPressedTimes = 0

	--Control block for printing messages.
--[[Function to get the coordinates of mouse presses. Recordes two clicks, one
for piece selection and one for move selection]]
		end
	end
end

--Creates square for piece selection.
function displaySolid(i,j)
	if i < 8 and j < 8 then
		solidY = (i * 60) + 56;
		solidX = (j * 60) + 70;
	end
end

--[[Callback function that is called continuously. It is used to constantly get mouse position
and update mouseover box.]]
function love.update(dt)
	q,w = love.mouse.getPosition( )
	displayHoverBox(q,w)
	displaySolid(mousePressedi1,mousePressedj1)
end

--[[Callback function that is called once when the game loads. It initializes some
variables and loads the images used for the game.]]
function love.load()
	love.window.setTitle("Chess")
	turn = 0
	checkPressedTimes = 0;
	setUpBoard();
	printx = 0;
	printy = 0;
	mousePressedi1,mousePressedj1 = 9,9;
	x = love.graphics.getWidth();
	y = love.graphics.getHeight();
	chessBoard = love.graphics.newImage("Chess-Pieces/chessBoard.png");
	whiteKing = love.graphics.newImage("Chess-Pieces/white_king.png");
	whiteQueen = love.graphics.newImage("Chess-Pieces/white_queen.png");
	whiteBishop = love.graphics.newImage("Chess-Pieces/white_bishop.png");
	whiteKnight = love.graphics.newImage("Chess-Pieces/white_knight.png");
	whiteRook = love.graphics.newImage("Chess-Pieces/white_rook.png");
	whitePawn = love.graphics.newImage("Chess-Pieces/white_pawn.png");
	blackKing = love.graphics.newImage("Chess-Pieces/black_king.png");
	blackQueen = love.graphics.newImage("Chess-Pieces/black_queen.png");
	blackBishop = love.graphics.newImage("Chess-Pieces/blac_bishop.png");
	blackKnight = love.graphics.newImage("Chess-Pieces/black_knight.png");
	blackRook = love.graphics.newImage("Chess-Pieces/black_rook.png");
	blackPawn = love.graphics.newImage("Chess-Pieces/black_pawn.png");
end
