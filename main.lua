function setupBoard()
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
end

function convertXYToBoardInts(x,y)
	return math.floor((x-70)/60), math.floor((y-60)/60)
end

function displayHoverBox(x,y)
	hoverXd, hoverYd = convertXYToBoardInts(x,y)
	hoverX = (hoverXd * 60) + 70;
	hoverY = (hoverYd * 60) + 56;

	string = "x : " .. math.floor((x-70)/60) .. " :: y: " .. math.floor((y-60)/60) .. "  HoverX : " .. hoverX .. "  hoverY : "..hoverY ;
end

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

function displayPieces()
  for i = 0, 7 do
		for j = 0, 7 do
			if board[i][j] ~= "0" then
        drawPiece(board[i][j],i,j);
      end
		end
	end
end

function love.draw()
  love.graphics.draw(chessBoard, 24,9);
	if hoverXd >= 0 and hoverYd >= 0 and hoverXd <= 7 and hoverYd <= 7  then
		love.graphics.setColor(0, 255, 0, 80);
		love.graphics.rectangle( "fill", hoverX, hoverY, 60, 60 ,5);
		love.graphics.setColor(255, 255, 255);
	end
	displayPieces();
  -- love.graphics.print(string);

end

function love.mousepressed(x1,y1,button)
  if button == 1 then
    printx = x1;
    printy = y1;
  end

	if checkPressedTimes == 0 then
		i1,j1 = convertXYToBoardInts(x1,y1);
		checkPressedTimes = 1;
	elseif checkPressedTimes == 1 then
		i2,j2  = convertXYToBoardInts(x1,y1);
--	send i1,j1(initial cordinates) and i2,j2(destination cordinates) to
--  chess engine
--  expected returns Board, string, int(for determining turns)
		checkPressedTimes = 0;
	end

end

function love.update(dt)
	q,w = love.mouse.getPosition( )
	displayHoverBox(q,w)
end

function love.load()
	checkPressedTimes = 0;
	setupBoard();
  printx = 0;
  printy = 0;
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
