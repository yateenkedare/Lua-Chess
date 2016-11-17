local chessEngine = require("scripts.ChessEngine")

function inBounds(pos)
	if 0 <= pos[1] and pos[1] <= 7 and 0 <= pos[2]and pos[2] <= 7 then
		return true
	else
		return false
	end
end

function convertXYToBoardInts(x,y)
	return math.floor((x-70)/60), math.floor((y-60)/60)
end

function displayHoverBox(x,y)
	hoverXd, hoverYd = convertXYToBoardInts(x,y)
	hoverX = (hoverXd * 60) + 70;
	hoverY = (hoverYd * 60) + 56;
end

function displaySolid(i,j)
	if i < 8 and j < 8 then
		solidY = (i * 60) + 56;
		solidX = (j * 60) + 70;
	end
end

function drawPiece(piece,i,j)
  a = (j*60) + (MaxX/10) + 7;
  b = (i*60) + (MaxY/10)
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
	if mousePressedi1 >= 0 and mousePressedj1 >= 0 and mousePressedi1 <= 7 and mousePressedj1 <= 7 and solidBox then
		love.graphics.setColor(0, 255, 0, 80);
		love.graphics.rectangle( "fill", solidX, solidY, 60, 60 ,5);
		love.graphics.setColor(255, 255, 255);
	end
	displayPieces();
  love.graphics.print(string, 620, 200);
	if turn == 1 then
		love.graphics.print("White's Turn", 620, 100)
	else
		love.graphics.print("Black's Turn", 620, 100);
	end
end

function checkTurnAndPiece(x,y)
	if turn ==0 then
		if string.match(board[x][y], '[A-Z]') then
			return true
		else
			return false
		end
	elseif turn == 1 then
		if string.match(board[x][y], '[a-z]') then
			return true
		else
			return false
		end
	else
		return false
	end
end

function love.mousepressed(y1,x1,button)
	if not chessEngine.gameOver then
		turn = chessEngine.turn
		mouseX, mouseY = convertXYToBoardInts(x1+10,y1-10);
		if inBounds({mouseX, mouseY}) then
			if checkPressedTimes == 0 then
				if  checkTurnAndPiece(mouseX, mouseY) then
					mousePressedi1,mousePressedj1 = mouseX, mouseY
					wPiece = board[mouseX][mouseY]
					checkPressedTimes = 1;
					solidBox = true
				else
					solidBox = false
			  end
			elseif checkPressedTimes == 1 then
				wPos = {mouseX,mouseY}
				_G.wPos = wPos
				_G.wPiece = wPiece
				if turn == 0 then
					chessEngine.BlacksTurn()
				elseif turn == 1 then
					chessEngine.WhitesTurn()
				end
				checkPressedTimes = 0
				solidBox = false
			end
		end
		string = chessEngine.displayString
		board = chessEngine.board
		-- update Print String
	end
end

function love.update(dt)
	q,w = love.mouse.getPosition( )
	displayHoverBox(q,w)
	displaySolid(mousePressedi1,mousePressedj1)
end

function love.load()
	checkPressedTimes = 0;
	mousePressedi1,mousePressedj1 = 9,9
	chessEngine.setupBoard();
	board = chessEngine.board
	solidBox = false
  MaxX = love.graphics.getWidth();
  MaxY = love.graphics.getHeight();
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
