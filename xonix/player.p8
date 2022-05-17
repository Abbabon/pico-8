pos_x = 0
pos_y = 0
speed = 2

function init_player()
 
end

function update_player()
 if (btn(0) and pos_x > 0) then
  pos_x=pos_x-speed
 end

 if (btn(1) and pos_x < 127) pos_x+=1

 if (btn(2) and pos_y > 0) pos_y-=1

 if (btn(3) and pos_y < 127) pos_y+=1  
 
end



function draw_player()
 spr(1,pos_x-4,pos_y-4)
end