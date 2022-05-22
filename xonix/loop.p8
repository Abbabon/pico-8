function _init()
 init_board()
end


function _update()
 update_board()
end


function _draw()
 cls()
 draw_board()
 draw_stats()
 draw_ui()
end

function draw_stats()
 print(stat(7),0,0,7)
end
