pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- colorful life
-- by abbabon

grid={}
n=32
cols=n
rows=n
res=128/n

function create_grid(randomize)
 newgrid={}
 for x=1,cols do
  newgrid[x]={}
  for y=1,rows do
    if randomize then
     newgrid[x][y]=flr(rnd(2))
    else
     newgrid[x][y]=0
    end
  end
 end
return newgrid
end

function count_neighbours(grid,x,y)
 local sum =0

 for i=-1,1 do
  for j=-1,1 do
   local row = x+i
   local col = y+j

   if (row < 1) then row = rows end
   if (row > rows) then row = 1 end
   if (col < 1) then col = cols end
   if (col > cols) then col = 1 end

   if grid[row][col] >= 1 then
    sum += 1
   end

  end
 end -- end loops

 if grid[x][y] >= 1 then
  sum -= 1
 end

 return sum
end

function _init()
	grid = create_grid(true)
end

function update_cells ()
 local new_grid = create_grid(false)
 for x=1,rows do
  for y=1,cols do
    local n = count_neighbours(grid,x,y)
    local alive = grid[x][y] >= 1

    if alive then
     if n < 2 or n > 3 then
      new_grid[x][y] = 0
     else
      new_grid[x][y] = grid[x][y]+1
     end
    end

    if not alive and n == 3 then
     new_grid[x][y] = 1
    end
  end
 end
 grid = newgrid
end

function _draw()
 cls()
 camera(res, res)
 for x=1,rows do
			for y=1,cols do
    local color = 0

				rectfill(
					x*res,
					y*res,
					x*res+res,
					y*res+res,
					grid[x][y]
				)

			end
		end
  flip()
  update_cells()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
