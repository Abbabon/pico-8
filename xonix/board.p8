player = {}
board = {}
path = {}

-- empty - 0, fill - 1; overlays - player - 2, enemy - 3, path - 4

function init_board()
  
  for row = 1, 64 do
    board[row] = {}
    for column = 1, 64 do
      if (row <= 2 or column <= 2 or row >= 63 or column >= 63) then
         board[row][column] = 0
      else
         board[row][column] = 1
      end
    end
  end

  player.x = 1
  player.y = 1

end

function update_board()
 update_player_position()
 update_enemy_position()
 collisions()
end

last_frame_safe = true
fill_end_point = {}

function update_player_position()

  move = false
  prev = {
   x = player.x,
   y = player.y
  }

  if (btn(0) and player.x > 1 and not move) then --move left
   move_player(-1,0)
   move = true
  end

  if (btn(1) and player.x < 64 and not move) then --move right
    move_player(1,0)
    move = true
  end

  if (btn(2) and player.y > 1 and not move) then --move up
    move_player(0,-1)
    move = true
  end

  if (btn(3) and player.y < 64 and not move) then --move down
    move_player(0,1)
    move = true
  end

  safe = (board[player.y][player.x] == 0)
  changed_safe_state = safe != last_frame_safe
  last_frame_safe = safe

  if (changed_safe_state and safe) then

   fill_end_point = {x=prev.x, y=prev.y}
   if (prev.x != player.x) fill(true)
   if (prev.y != player.y) fill(false)
   
   clear_path(false)
  end


  if (not safe and move) then
   add(path, {x=player.x, y=player.y})
   board[player.y][player.x] = 2
  end

end

function fill(horizontal)
 
  x_one = horizontal and (fill_end_point.x) or (fill_end_point.x-1)
  x_two = horizontal and (fill_end_point.x) or (fill_end_point.x+1)
  y_one = horizontal and (fill_end_point.y-1) or fill_end_point.y
  y_two = horizontal and (fill_end_point.y+1) or fill_end_point.y

  one_tiles = {}
  one_amount = flood_fill(x_one,y_one, one_tiles)
  reset_fill()

  two_tiles = {}
  two_amount = flood_fill(x_two,y_two,two_tiles)
  reset_fill()

  if (one_amount > two_amount) then 
   fill_conquer(two_tiles)
  else 
   fill_conquer(one_tiles)
  end


  reset_fill()


  -- conider enemies
  -- path

  for path_tile in all(path) do
   board[path_tile.y][path_tile.x] = 0
  end


  -- reset_fill()
end

function reset_fill()
  for row = 1, 64 do
   for column = 1, 64 do
    if (board[row][column] == -1) board[row][column] = 1
    end
  end 
end

function flood_fill(x,y,filled)
 if (x < 1 or y < 1 or x > 64 or y > 64) return 0
 if (board[y][x] == 0 or board[y][x] == 2 or board[y][x] == -1) return 0

 board[y][x] = -1
 add(filled, {x = x, y = y})
 filled_amount = 1
 filled_amount += flood_fill(x-1, y, filled)
 filled_amount += flood_fill(x+1, y, filled)
 filled_amount += flood_fill(x, y-1, filled)
 filled_amount += flood_fill(x, y+1, filled)

 return filled_amount

end

function fill_conquer(tiles)
 for tile in all(tiles) do
  board[tile.y][tile.x] = 0
 end
end

function clear_path(change_board)
 for path_tile in all(path) do
    del(path, path_tile)
    if (change_board) then
     board[path_tile.y][path_tile.x] = 1
    end
   end
end

function move_player(x_diff, y_diff)
  
  player.x = player.x + x_diff
  player.y = player.y + y_diff
  
end

function update_enemy_position()
end

function collisions()
end


function draw_board()


 -- board 
 for row = 1, 64 do
   for column = 1, 64 do
    tile_content = board[row][column]

    if(tile_content == 0) then
      draw_tile(column,row,12)
    end
    
    if(tile_content == 1) then
      draw_tile(column,row,1)
    end

    if(tile_content == 2) then
      draw_tile(column,row,2)
    end

   end
 end

 -- player
 draw_tile(player.x,player.y,9)

end

function draw_tile(x,y,color)

 rectfill((x*2-2), (y*2-2), (x*2-1), (y*2-1), color)

end