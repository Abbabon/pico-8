pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	ps={} --empty particle table
 g=0.1 --particle gravity
 max_vel=3 --max initial particle velocity
 min_time=2 --min/max time between particles
 max_time=5
 min_life=90 --particle lifetime
 max_life=120
 t=0 --ticker
 cols={1,1,1,13,13,12,12,7} --colors
 burst=50
 next_p=rndb(min_time,max_time)
 player={}
 player.x=0
 player.y=0
 player.dx=1.5
 player.dy=1.5
end

function rndb(low,high)
 return flr(rnd(high-low+1)+low)
end

function _update()
 t+=1
 if (t==next_p) then
  add_p(64,64)
  next_p=rndb(min_time,max_time)
  t=0
 end
 --burst
 if (btnp(🅾️)) then
  for i=1,burst do add_p(64,64) end
 end
 
 if (btnp(⬅️)) then
 	player.x-=player.dx
 elseif (btnp(➡️)) then
 	player.x+=player.dx
 elseif (btnp(⬆️)) then
 	player.y-=player.dy
 elseif (btnp(⬇️)) then
  player.y+=player.dy
 end
  
 foreach(ps,update_p)
end


function _draw()
 cls()
 foreach(ps,draw_p)
 print("x: " ..player.x .." y: " ..player.y,2,2,7)
end

function add_p(x,y)
 local p={}
 p.x,p.y=x,y
 p.dx=rnd(max_vel)-max_vel/2
 p.dy=rnd(max_vel)*-1
 p.life_start=rndb(min_life,max_life)
 p.life=p.life_start
 add(ps,p)
end

function update_p(p)
 if (p.life<=0) then
  del(ps,p) --kill old particles
 else
  p.dy+=g --add gravity
 if ((p.y+p.dy)>127) p.dy*=-0.8
  p.x+=p.dx --update position
  p.y+=p.dy
  p.life-=1 --die a little
 end
end

function draw_p(p)
 local pcol=flr(p.life/p.life_start*#cols+1)
 pset(p.x+player.x,p.y+player.y,cols[pcol])
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
