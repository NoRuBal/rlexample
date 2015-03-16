map = {}

map.width = 25
map.height = 40

map.minimap = {} --minimap[floor][x][y] = 1(revealed)/2(covered)
map.minimap.x = 0
map.minimap.y = 360 - map.height * 3
map.minimap.ratio = 3

function map.generate(floor)
	--generate map of 'floor'th floor
	map[floor] = {}
	local a
	local b
	for a = 1, 25 do
		map[floor][a] = {}
		for b = 1, 40 do
			map[floor][a][b] = 2
		end
	end
	
	lstrooms = {}
	
	local rooms = math.random(6, 10)
	
	local a
	local b
	local isoverlap = false
	local tmproom = {}
	local count = 0
	for a = 1, rooms do
		--generate rooms
		count = 0
		::genmap::
		tmproom = {}
		tmproom.x = math.random(1, map.width)
		tmproom.y = math.random(1, map.height)
		tmproom.width = math.random(5, 10)
		tmproom.height = math.random(5, 15)
		isoverlap = false
		
		--check if room is fit in the map
		if map.mapcheck(tmproom.x, tmproom.y, tmproom.width, tmproom.height) then
			--check if there is any overlaping room
			for b = 1, #lstrooms do
				if map.collcheck(lstrooms[b].x, lstrooms[b].y, lstrooms[b].width, lstrooms[b].height, tmproom.x, tmproom.y, tmproom.width, tmproom.height) then
					isoverlap = true
					break
				end
			end
			if isoverlap == false then
				--add room
				table.insert(lstrooms, tmproom)
			else
				if count > 100 then
					--too many loops..
				else
					count = count + 1
					goto genmap
				end
			end
		else
			if count > 100 then
				--too many loops...
			else
				count = count + 1
				goto genmap
			end
		end
	end
	
	--draw to map
	local c
	for a = 1, #lstrooms do
		for b = 1, lstrooms[a].width do
			for c = 1, lstrooms[a].height do
				map[floor][lstrooms[a].x + b][lstrooms[a].y + c] = 1
			end
		end
	end
	
	--generate corridors
	for a = 1, #lstrooms - 1 do
		local x1, y1, w1, h1, x2, y2, w2, h2, px1, py1, px2, py2
		local mx, my
		x1 = lstrooms[a].x
		y1 = lstrooms[a].y
		w1 = lstrooms[a].width
		h1 = lstrooms[a].height
		x2 = lstrooms[a + 1].x
		y2 = lstrooms[a + 1].y
		w2 = lstrooms[a + 1].width
		h2 = lstrooms[a + 1].height
		
		if (x1 + w1 < x2) then--vertical 1 is left, 2 is right
			px1 = x1 + w1 - 1
			py1 = math.random(y1, y1 + h1)
			
			px2 = x2 + 1
			py2 = math.random(y2, y2 + h2)
			
			mx = math.random(px1, px2)

			for b = px1, mx do
				map[floor][b][py1] = 1
			end
			
			for b = mx, px2 do
				map[floor][b][py2] = 1
			end
			
			local plus
			
			if py1 >= py2 then
				plus = -1
			elseif py2 > py1 then
				plus = 1
			end
			
			for b = py1, py2, plus do
				map[floor][mx][b] = 1
			end
		
		elseif (x2 + w2 < x1) then --vertical 2 is left, 1 is right
			
			px2 = x2 + w2 - 1
			py2 = math.random(y2, y2 + h2)
			
			px1 = x1 + 1
			py1 = math.random(y1, y1 + h1)
			
			mx = math.random(px2, px1)

			for b = px2, mx do
				map[floor][b][py2] = 1
			end
			
			for b = mx, px1 do
				map[floor][b][py1] = 1
			end
			
			local plus
			
			if py1 >= py2 then
				plus = -1
			elseif py2 > py1 then
				plus = 1
			end
			
			for b = py1, py2, plus do
				map[floor][mx][b] = 1
			end
			
		elseif (y1 + h1 < y2) then --horizontal 1 is up, 2 is down
			
			px1 = math.random(x1, x1 + w1)
			py1 = y1 + h1 - 1
			
			px2 = math.random(x2, x2 + w2)
			py2 = y2 + 1
			
			my = math.random(py1, py2)
			
			for b = py1, my do
				map[floor][px1][b] = 1
			end
			
			for b = my, py2 do
				map[floor][px2][b] = 1
			end

			local plus
			
			if px1 >= px2 then
				plus = -1
			elseif px2 > px1 then
				plus = 1
			end
			
			for b = px1, px2, plus do
				map[floor][b][my] = 1
			end
			
			
		elseif (y2 + h2 < y1) then --horizontal 2 is down, 1 is up
			
			px2 = math.random(x2, x2 + w2)
			py2 = y2 + h2 - 1
			
			px1 = math.random(x1, x1 + w1)
			py1 = y1 + 1
			
			my = math.random(py2, py1)
			
			for b = py2, my do
				map[floor][px2][b] = 1
			end
			
			for b = my, py1 do
				map[floor][px1][b] = 1
			end

			local plus
			
			if px1 >= px2 then
				plus = -1
			elseif px2 > px1 then
				plus = 1
			end
			
			for b = px1, px2, plus do
				map[floor][b][my] = 1
			end
			
		end
	end
	
	--generate stairs
	stairs.new(floor, math.random(lstrooms[1].x + 1, lstrooms[1].x + lstrooms[1].width - 1), math.random(lstrooms[1].y + 1, lstrooms[1].y + lstrooms[1].height - 1), "up")
	stairs.new(floor, math.random(lstrooms[#lstrooms].x + 1, lstrooms[#lstrooms].x + lstrooms[#lstrooms].width - 1), math.random(lstrooms[#lstrooms].y + 1, lstrooms[#lstrooms].y + lstrooms[#lstrooms].height - 1), "down")

	--generate creatures
	local a, b, numcreatures
	local rndx, rndy, success
	numcreatures = 10 + math.random(1, floor)
	if not(numcreatures <= 0) then
		for b = 1, numcreatures do
			success = false
			repeat
				rndx = math.random(1, 25)
				rndy = math.random(1, 40)
				if map[floor][rndx][rndy] == 1 then
					if map.checkstairs(rndx, rndy) == false then
						creature.new(creature.tbl[math.random(1, 12)].id, rndx, rndy, floor)
						success = true
					end
				end
			until(success == true)
		end
	end

	--init minimap
	map.minimap[floor] = {}
	local a
	local b
	for a = 1, 25 do
		map.minimap[floor][a] = {}
		for b = 1, 40 do
			map.minimap[floor][a][b] = 2
		end
	end
end

function map.checkstairs(x, y, floor)
	local sx, sy
	if not(stairs.getstairs(floor, "down")) == nil then
		sx, sy = stairs.getstairs(floor, "down")
		if (sx == x) and (sy == y) then
			return true
		end
	end

	if not(stairs.getstairs(floor, "up")) == nil then
		sx, sy = stairs.getstairs(floor, "up")
		if (sx == x) and (sy == y) then
			return true
		end
	end

	return false
end

function map.collcheck(x1, y1, w1, h1, x2, y2, w2, h2)
-- check pix1 and pix2 are collide
-- usage: map.collcheck(blabla~) => true|false
	x1 = x1 - 1
	y1 = y1 - 1
	w1 = w1 + 2
	h1 = h1 + 2
	x2 = x2 - 1
	y2 = y2 - 1
	h2 = h2 + 2
	w2 = w2 + 2
    if (x1 + w1) > x2 and x1 < (x2 + w2) then
        if (y1 + h1) > y2 and y1 < (y2 + h2) then
            return true
        end
    end

	return false
end

function map.draw()
	local a
	local b
	
	local mapx
	local mapy
	
	for a = 1, 9 do
		for b = 1, 9 do
			mapx = player.x - 5 + b
			mapy = player.y - 5 + a
			if (mapx >= 1) and (mapx <= 25) then
				if (mapy >= 1) and (mapy <= 40) then
					if map[player.floor][mapx][mapy] == 1 then --floor
						love.graphics.draw(imgtile[1], (b - 1) * game.tilesize, (a - 1) * game.tilesize)
					elseif map[player.floor][mapx][mapy] == 2 then --wall
						love.graphics.draw(imgtile[2], (b - 1) * game.tilesize, (a - 1) * game.tilesize)
					end
				end
			end
		end
	end
end

function map.minimap.draw()
	local a
	local b
	--draw terrain
	for a = 1, map.width do
		for b = 1, map.height do
			if map[player.floor][a][b] == 1 then --floor
				if map.minimap[player.floor][a][b] == 1 then --revealed
				love.graphics.setColor(255, 255, 255, 128)
				love.graphics.rectangle("fill", map.minimap.x + (a - 1) * map.minimap.ratio, map.minimap.y + (b - 1) * map.minimap.ratio, map.minimap.ratio, map.minimap.ratio)
				love.graphics.setColor(255, 255, 255)
				end
			end
		end
	end
	
	--draw stairs
	local sx, sy = stairs.getstairs(player.floor, "up")
	if map.minimap[player.floor][sx][sy] == 1 then
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", map.minimap.x + (sx - 1) * map.minimap.ratio, map.minimap.y + (sy - 1) * map.minimap.ratio, map.minimap.ratio, map.minimap.ratio)
		love.graphics.setColor(255, 255, 255)
	end
	local sx, sy = stairs.getstairs(player.floor, "down")
	if map.minimap[player.floor][sx][sy] == 1 then
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", map.minimap.x + (sx - 1) * map.minimap.ratio, map.minimap.y + (sy - 1) * map.minimap.ratio, map.minimap.ratio, map.minimap.ratio)
		love.graphics.setColor(255, 255, 255)
	end
	
	--draw player
	love.graphics.setColor(255, 0, 0, 128)
	love.graphics.rectangle("fill", map.minimap.x + (player.x - 1) * map.minimap.ratio, map.minimap.y + (player.y - 1) * map.minimap.ratio, map.minimap.ratio, map.minimap.ratio)
	love.graphics.setColor(255, 255, 255)
	
	--draw minimap border
	love.graphics.setColor(0, 0, 255, 128)
	love.graphics.rectangle("line", map.minimap.x + (player.x - 5) * map.minimap.ratio, map.minimap.y + (player.y - 5) * map.minimap.ratio, 9 * map.minimap.ratio, 9 * map.minimap.ratio)
	love.graphics.setColor(255, 255, 255)
end

function map.minimap.refresh()
	local a
	local b
	
	local mapx
	local mapy
	
	--with player's fov
	for a = 1, 9 do
		for b = 1, 9 do
			if player.fov[a][b] == 1 then --visible
				map.minimap[player.floor][player.x + a - 5][player.y + b - 5] = 1
			end
		end
	end
end

function map.mapcheck(x, y, width, height)
	if (x <= 1) or (x + width >= map.width) then
		return false
	else
		if (y <= 1) or (y + height >= map.height) then
			return false
		end
	end
	return true
end