player = {}
board = {}
path = {}
enemies = {}
number_of_tiles = 3844 -- 62 * 62

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

  player.x = 32
  player.y = 1
  player.dx = 0
  player.dy = 0
  player.lives = 3
  player.percentage = 0.0

  init_enemies()

end

function init_enemies()

 enemies_amount = 3

 for enemycount = 1, enemies_amount do

  enemy = {
   x = flr(rnd(59)) + 3,
   y = flr(rnd(59)) + 3,
   dx = flr(rnd(1) - 1), --take sign
   dy = flr(rnd(1) - 1), --take sign
  }

  add(enemies, enemy)

 end


end

function update_board()
 update_player_position()
 update_enemy_position()
 collisions()
end

function draw_ui()
  print("lives: "..player.lives.." percentage: "..flr(player.percentage),0,123,7)
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

function update_enemy_position()
 for enemy in all(enemies) do
   dx = enemy.dx > 0 and 1 or -1
   dy = enemy.dy > 0 and 1 or -1

   if (board[enemy.y][enemy.x + dx] == 0) do
    enemy.dx *= -1
    dx *= -1
   end

   if (board[enemy.y + dy][enemy.x] == 0) do
    enemy.dy *= -1
    dy *= -1
   end

   enemy.x += dx
   enemy.y += dy 

 end
end

function collisions()
 
 for enemy in all(enemies) do
  if (enemy.x == player.x and enemy.y == player.y) then
   trigger_loss()
   break
  end

  for path_tile in all(path) do
   if (enemy.x == path_tile.x and enemy.y == path_tile.y) then
    trigger_loss()
   break
   end  
  end


 end

end

function trigger_loss()
 player.lives -= 1
 player.x = 32
 player.y = 1 

 clear_path(true)

 log("lost!")
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

  -- calculate percentage
  
  empty_tiles = 0
  for row=3,62 do
   for column=3,62 do
    if (board[column][row] == 0) then
     empty_tiles += 1
    end
   end
  end

  player.percentage = (empty_tiles/number_of_tiles)*100

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

 -- enemies
 for enemy in all(enemies) do
  circfill(enemy.x*2-2,enemy.y*2-2,1, 14)
 end

end

function draw_tile(x,y,color)

 rectfill((x*2-2), (y*2-2), (x*2-1), (y*2-1), color)

end

function log(string)
 printh(string,"logs/default",overwrite)
end