pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--yet another lander game
--by abbabon

function _init()
 g=0.025 --gravity
 crash_velocity=1
 animation_framerate=30
 create_animations()
 init_particle_system()
 game_setup()
end

function _update()
 update_particle_system()
 if (not game_over) then
  move_player()
  check_land()
 else
  if (btnp(5)) game_setup()
 end
end

function _draw()
  cls()
  draw_stars()
  draw_ground()
  draw_player()
  draw_particles();

  if (game_over) then
   if (win) then
    print("a winner is you!", 30, 48, 11)
   else
    print("too bad :(", 40, 48, 8)
   end
   print("press ❎ to play again", 20, 70, 5)
  end
end

function game_setup()
 reset_particle_system()
 game_over=false
 win=false
 make_player()
 make_ground()
end

function make_player()
 p={}
 p.x = 60
 p.y = 8
 p.dx = 0
 p.dy = 0
 p.sprite = 1
 p.thrustsprite=2
 p.alive=true
 p.thrust=0.075
 p.thrusting=false
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
 if (btn(2)) then
  p.dy-=p.thrust
  p.thrusting=true
 else
  p.thrusting=false
 end

 if (btn(0) or btn(1) or btn(2)) sfx(0)
end

function draw_player()
 if game_over and win then
  spr(4,p.x,p.y-8) --flag
 elseif game_over then
  animate_object(p, animations[1])
 end
 spr(p.sprite,p.x,p.y)
 if (p.thrusting and game_over == false) spr(p.thrustsprite,p.x,p.y+8)
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
  animate_object(pad,animations[2])
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

function end_game(won)
 game_over=true
 win=won

 if (not won) add_particle_effect(p, true, 5, 5)
 if (game_over and won) then
  sfx(1) --we won
 elseif (game_over) then
  sfx(2) --kaboom
 end
end

-->8
-- particle system -> particles_effect -> particle

function init_particle_system()
 particle_settings={}
 particle_settings.g=0.1 --particle gravity
 particle_settings.max_vel=3 --max initial particle velocity
 particle_settings.min_time=2 --min/max time between particles
 particle_settings.max_time=5
 particle_settings.min_life=90 --particle lifetime
 particle_settings.max_life=120
 particle_settings.cols={1,1,1,13,13,12,12,7} --colors
 particle_settings.burst=50
end

function reset_particle_system()
 ps={} --empty particle table
 --TODO: go over all particles and kill?
end

--TODO make gravity optional
--TODO add burst option
--TODO add timed
--TODO add colors
--TODO add positionoffset
function add_particle_effect(gameobject, burst, offsetX, offsetY)
 local newparticleffect={}
 newparticleffect.burst=burst
 newparticleffect.gameobject=gameobject
 newparticleffect.particles={}
 checknil(newparticleffect, "offsetX", offsetX, 0)
 checknil(newparticleffect, "offsetY", offsetY, 0)
 if (burst) then
  for i=1,particle_settings.burst do
    add_particle(newparticleffect)
  end
 else
  newparticleffect.next_p=rndb(particle_settings.min_time,particle_settings.max_time)
  newparticleffect.t=0
 end

 add(ps,newparticleffect)
end

function update_particle_system()
 foreach(ps,update_particle_effect)
end

function update_particle_effect(e)
 if e.burst then
  --body...
 else
  e.t+=1
  if (e.t==e.next_p) then
   add_particle(e)
   e.next_p=rndb(particle_settings.min_time,particle_settings.max_time)
   e.t=0
  end
 end

 foreach(e.particles,update_particle)

 if (#e.particles == 0) then
  del(ps,e) --kill old particles
 end
end

function add_particle(e)
 local p={}
 p.e=e
 p.x,p.y=e.gameobject.x+e.offsetX,e.gameobject.y+e.offsetY
 p.dx=rnd(particle_settings.max_vel)-particle_settings.max_vel/2
 p.dy=rnd(particle_settings.max_vel)*-1
 p.life_start=rndb(particle_settings.min_life,particle_settings.max_life)
 p.life=p.life_start
 add(e.particles,p)
end

function update_particle(p)
 if (p.life<=0) then
  del(p.e.particles,p) --kill old particles
 else
  p.dy+=particle_settings.g --add gravity
  if ((p.y+p.dy)>127) then
   p.dy*=-0.8
  end
  p.x+=p.dx --update position
  p.y+=p.dy
  p.life-=1 --die a little
 end
end

function draw_particles()
 foreach(ps,draw_particle_effect)
end

function draw_particle_effect(e)
 foreach(e.particles,draw_particle)
end

function draw_particle(p)
 local pcol=flr(p.life/p.life_start*#particle_settings.cols+1)
 pset(p.x,p.y,particle_settings.cols[pcol])
end

-->8
function rndb(low,high) --random between
 return flr(rnd(high-low+1)+low)
end

function checknil(value, name, checked, default)
 if (checked == nil) then
  value[name] = default
 else
  value[name] = checked
 end
end

-->8
function create_animations()
 animations={}
 add_animation(32,34,1,60)
 add_animation(8,56,16,4)
end

function add_animation(a, b, diff, framerate)
 local newanimation={}
 newanimation.a=a
 newanimation.b=b
 newanimation.diff=diff
 newanimation.framerate=framerate
 newanimation.framecounter=0
 add(animations,newanimation)
end

function animate_object(gameobject, animation)
 animation.framecounter+=1
 if (animation.framecounter > animation_framerate/animation.framerate) then
  animation.framecounter=0
  local newsprite=gameobject.sprite+animation.diff
  if newsprite<animation.a or newsprite>animation.b then
   newsprite=animation.a
  end
  gameobject.sprite=newsprite
 end
end

__gfx__
000000000088880089aaaa9800000000000000000000000000000000000000000200000000000020000000000000000000000000000000000000000000000000
0000000008817880089aa98000000000000000000000000000000000000000002200000000000022000000000000000000000000000000000000000000000000
0070070088111788089aa98000000000000a6000000000000000000000000000b200000000000022000000000000000000000000000000000000000000000000
0007700088111188008998000000000000aa600000000000000000000000000032033333b3333322000000000000000000000000000000000000000000000000
0007700088eeee8800899800000000000aaa60000000000000000000000000003222222222222222000000000000000000000000000000000000000000000000
00700700088888800008800000000000000a60000000000000000000000000000032222222222200000000000000000000000000000000000000000000000000
000000000e0ee0e00000000000000000000060000000000000000000000000000002000000000200000000000000000000000000000000000000000000000000
00000000880880880000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000200000000000020000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000002200000000000022000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003200000000000022000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000b20333bbbbb33322000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003222222222222222000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000032222222222200000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000002000000000200000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888000099990000aaaa0000000000000000000000000000000000000000000200000000000020000000000000000000000000000000000000000000000000
0899998009aaaa900a88889000000000000000000000000000000000000000002200000000000022000000000000000000000000000000000000000000000000
899aa9989aa88aa9a889988a00000000000000000000000000000000000000003200000000000022000000000000000000000000000000000000000000000000
89aaaa989a8888a9a899998a00000000000000000000000000000000000000003207bbbbbbbbb722000000000000000000000000000000000000000000000000
89aaaa989a8888a9a899998a0000000000000000000000000000000000000000b222222222222222000000000000000000000000000000000000000000000000
899aa9989aa88aa9a889988a00000000000000000000000000000000000000000032222222222200000000000000000000000000000000000000000000000000
0899998009aaaa900a8888a000000000000000000000000000000000000000000002000000000200000000000000000000000000000000000000000000000000
008888000099990000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000200000000000020000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000002200000000000022000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003200000000000022000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000b20333bbbbb33322000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003222222222222222000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000032222222222200000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000002000000000200000000000000000000000000000000000000000000000000
__sfx__
000600000b61016000170000000018000190001900001000030000500008000090000c0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c0000250502505020050200501e0501e0502405024050011002105024050240500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000035650306502b65026650226501f6501b6501865014650126500f6500d6500b65009650076500665004650036500265001650016500165000650000000000000000000000000000000000000000000000
