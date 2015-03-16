stairs = {}

function stairs.new(floor, x, y, direction)
	local a
	local index
	
	index = #stairs + 1
	
	stairs[index] = {}
	stairs[index].floor = floor
	stairs[index].x = x
	stairs[index].y = y
	stairs[index].direction = direction --up/down
end

function stairs.draw()
	local a
	for a = 1, #stairs do
		if stairs[a].floor == player.floor then
			if collcheck(player.x - 5, player.y - 5, 9, 9, stairs[a].x, stairs[a].y, 1, 1) then
				love.graphics.draw(imgstairs[stairs[a].direction], (stairs[a].x + 4 - player.x) * 40, (stairs[a].y + 4 - player.y) * 40)
			end
		end
	end
end

function stairs.getstairs(floor, direction)
	local a
	for a = 1, #stairs do
		if stairs[a].floor == floor then
			if stairs[a].direction == direction then
				return stairs[a].x, stairs[a].y
			end
		end
	end
	return nil
end