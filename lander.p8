pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--yet another lander game
--by abbabon

function _init()
 g=0.025 --gravity
 game_over=false
 win=false
 make_player()
 make_ground()
end

function make_player()
 crash_velocity=1
 p={}
 p.x = 60
 p.y = 8
 p.dx = 0
 p.dy = 0
 p.sprite = 1
 p.alive=true
 p.thrust=0.075
end

function _update()
 if (not game_over) then
  move_player()
  check_land()
 else
  if (btnp(5)) _init()
 end
end

function _draw()
  cls()
  draw_stars()
  draw_ground()
  draw_player()

  if (game_over) then
   if (win) then
    print("a winner is you!", 30, 48, 11)
   else
    print("too bad :(", 40, 48, 8)
   end
   print("press ❎ to play again", 20, 70, 5)
  end
end

function rndb(low,high) --random between
 return flr(rnd(high-low+1)+low)
end

function draw_stars()
 srand(1) --same random, fixates the stars; consider changing every few seconds
 for i=1,50 do
  pset(rndb(0,127),rndb(0,127),rndb(5,7)) --sets a pixel in the graphics buffer
 end
 srand(time())
end

function move_player()
 p.dy+=g --add gravity
 thrust()

 p.x+=p.dx
 p.y+=p.dy

 stay_on_screen()
end

function stay_on_screen()
 if (p.x<0) then --left side
  p.x=0
  p.dx=0
 end
 if (p.x>119) then --right side
  p.x=119
  p.dx=0
 end
 if (p.y<0) then --top
  p.y=0
  p.dy=0
 end
end

function thrust()
 if (btn(0)) p.dx-=p.thrust
 if (btn(1)) p.dx+=p.thrust
 if (btn(2)) p.dy-=p.thrust

 if (btn(0) or btn(1) or btn(2)) sfx(0)
end

function draw_player()
 spr(p.sprite,p.x,p.y)
 if (game_over and win) then
  spr(4,p.x,p.y-8) --flag
 elseif (game_over) then
  spr(5,p.x,p.y) --kaboom
 end
end

function make_ground()
 gnd={}
 local top=96
 local btm=120

 pad={}
 pad.width=15
 pad.x=rndb(0,126-pad.width)
 pad.y=rndb(top,btm)
 pad.sprite=2

 for i=pad.x,pad.x+pad.width do
  gnd[i]=pad.y
 end

 for i=pad.x+pad.width+1,127 do --ground right of pad
  local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
  gnd[i]=mid(top,h,btm)
 end

 for i=pad.x-1,0,-1 do --ground left of pad
  local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
  gnd[i]=mid(top,h,btm)
 end
end

function draw_ground()
 for i=1,127 do
  line(i,gnd[i],i,127,5) --nice line method
  spr(pad.sprite,pad.x,pad.y-3,2,1)
 end
end

function check_land()
 l_x=flr(p.x) --left of ship
 r_x=flr(p.x+7) --right of ship
 b_y=flr(p.y+7) --bottom of ship

 over_pad=l_x>pad.x and r_x<pad.x+pad.width
 on_pad=b_y>pad.y-1
 slow=p.dy<crash_velocity

 if (over_pad and on_pad and slow) then
  end_game(true)
 elseif (over_pad and on_pad) then
  end_game(false)
 else
  for i=l_x,r_x do
   if (gnd[i]<b_y) end_game(false)
  end
 end
end

function end_game (won)
 game_over=true
 win=won

 if (game_over and won) then
  sfx(1) --we won
 elseif (game_over) then
  sfx(2) --kaboom
 end
end


__gfx__
00000000008888000200000000000020000000000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088178802200000000000022000000000899998000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700881117883200000000000022000a6000899aa99800000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700088111188320bbbbbbbbbb32200aa600089aaaa9800000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700088eeee8832222222222222220aaa600089aaaa9800000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700088888800032222222222200000a6000899aa99800000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000e0ee0e00002000000000200000060000899998000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880880880000000000000000000060000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000b61016000170000000018000190001900001000030000500008000090000c0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c0000250502505020050200501e0501e0502405024050011002105024050240500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000035650306502b65026650226501f6501b6501865014650126500f6500d6500b65009650076500665004650036500265001650016500165000650000000000000000000000000000000000000000000000