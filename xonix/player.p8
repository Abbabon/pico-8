pos_x = 1
pos_y = 1
speed = 1

board = {}

function init_player()
  
  printh("clear","logs/default",overwrite)

  for row = 1, 128 do
    board[row] = {}
    for column = 1, 128 do
      if (row <= 2 or column <= 2 or row >= 127 or column >= 127) then
        board[row][column] = 1
      else
         board[row][column] = 0
      end
    end
  end
end

function update_player()
 if (btn(0) and pos_x > 0) then
  new_pos_x=pos_x-speed
  if new_pos_x >= 1 then
    where = board[new_pos_x][pos_y]
    if (where == 1) then
     pos_x = new_pos_x
    end
  end
 end

 if (btn(1) and pos_x < 127) then
   new_pos_x=pos_x+speed
   if new_pos_x <= 128 then
     where = board[new_pos_x][pos_y]
     if (where == 1) then
      pos_x = new_pos_x
     end
   end
 end

 if (btn(2) and pos_y > 0) then
   new_pos_y=new_pos_y-speed
   if new_pos_y >= 1 then
     where = board[pos_x][new_pos_y]
     if (where == 1) then
      pos_y = new_pos_y
     end
   end

 end

 if (btn(3) and pos_y < 127) then
   new_pos_y=pos_y+speed
   if new_pos_y <= 128 then
     where = board[pos_x][new_pos_y]
     if (where == 1) then
      pos_y = new_pos_y
     end
   end
 end
 
end



function draw_player()
 
 for row = 1, 128 do
   for column = 1, 128 do
    

    if(board[row][column] == 0) then
      pset(column-1,row-1,1)
    end
    
    if(board[row][column] == 1) then
      pset(column-1,row-1,12)
    end

   end
 end

 spr(1,pos_x-4,pos_y-4)


end