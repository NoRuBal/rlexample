player = {}

function player.init(name)
	player.name = name
	player.maxhp = 10
	player.hp = player.maxhp
	player.maxsatiety = 1000
	player.satiety = 700
	player.speed = 100
	player.state = ""
	player.regen = 5

	player.baseatk = 2
	player.basedef = 0
	player.baseagi = 5
	
	player.protein = 0
	player.mineral = 0
	player.vitamin = 0
	
	player.floor = 1
	player.x = 1
	player.y = 1
	
	player.action = nil
	player.passedtime = 0
	
	player.fov = {}
end

function player.getattribute(attribute)
	if attribute == "attack" then
		--TODO:calculate attack
		return player.baseatk + math.floor(player.floor / 3)
	elseif attribute == "defence" then
	    --TODO:calculate defence
	    return player.basedef + math.floor(player.floor / 3)
	elseif attribute == "agility" then
		--TODO:calculate agility
		return player.baseagi + math.floor(player.floor / 3)
	end
end

function player.die()
	message.init()
	message.print("죽었다...")
	message.print("")
	player.state = "dead"
end

function player.move(direction)
	--move player
	local fakex = player.x
	local fakey = player.y
	
	if direction == "up" then
		fakey = fakey - 1
	elseif direction == "down" then
		fakey = fakey + 1
	elseif direction == "left" then
		fakex = fakex - 1
	elseif direction == "right" then
		fakex = fakex + 1
	elseif direction == "upleft" then
		fakex = fakex - 1
		fakey = fakey - 1
	elseif direction == "upright" then
		fakex = fakex + 1
		fakey = fakey - 1
	elseif direction == "downleft" then
		fakex = fakex - 1
		fakey = fakey + 1
	elseif direction == "downright" then
		fakex = fakex + 1
		fakey = fakey + 1
	end
	
	if (fakex >= 1) and (fakex <= 25) then
		if (fakey >= 1) and (fakey <= 40) then
			if not(map[player.floor][fakex][fakey] == 2) then
				--check collision with creature
				local colcreature = creature.getcreature(fakex, fakey, player.floor)
				if colcreature == nil then
					player.x = fakex
					player.y = fakey
					player.action = "move"
				else
					--attack creature
					local creaturename = creature.gettable(creature[colcreature].id, "name")
					if calc.hitroll(player.getattribute("agility"), creature.gettable(creature[colcreature].id, "agility")) == true then
						--player attacks creature
						local dmg = calc.damage(player.getattribute("defence"), creature.gettable(creature[colcreature].id, "attack"))
						if dmg == 0 then
							message.print(creaturename .. hangul.getJosa(creaturename, "unnun") .. " 당신의 공격을 막았다.")
						else
							message.print("당신은 "..creaturename .. hangul.getJosa(creaturename, "urrur") .." 공격했다!")
							creature[colcreature].hp = creature[colcreature].hp - dmg
							if creature[colcreature].hp <= 0 then
								--Creature dead and gain item
								creature[colcreature].hp = 0
								creature[colcreature].enabled = false
								message.print("당신은 "..creaturename .. hangul.getJosa(creaturename, "urrur") .." 죽였다!")
								player.satiety = player.satiety + math.random(1, 100)
								if player.satiety >= player.maxsatiety then
									player.satiety = player.maxsatiety
								end
							end
						end
					else
					    --player missed creature
					    message.print(creaturename .. hangul.getJosa(creaturename, "unnun") .. " 당신의 공격을 피했다.")
					end
					player.action = "attack"
				end
			end
		end
	end
	
	--calculate FOV
	player.calcFOV()
	
	--reveal map
	map.minimap.refresh()
end

function player.calcpassedtime(action)
	local passedtime = aptable[action] * 100 / player.speed
	return passedtime
end

function player.movestairs(direction)
	if direction == "up" then
		if player.floor == 1 then
			--first floor go up
			message.print("들어올 때는 마음대로였지만, 나갈 때는 아니란다.")
			return
		else
			if map[player.floor - 1] == nil then
				--generate map
				map.generate(player.floor - 1)
				player.maxhp = player.maxhp + 2
			end
			player.x, player.y = stairs.getstairs(player.floor - 1, "down")
			player.floor = player.floor - 1
		end
		message.print("던전 ".. player.floor .."층으로 올라왔다.")
	elseif direction == "down" then
		if player.floor == map.maxfloor then
			--TODO: There is no sorta thing, faggot!
			return
		else
			if map[player.floor + 1] == nil then
				--generate map
				map.generate(player.floor + 1)
			end
			player.x, player.y = stairs.getstairs(player.floor + 1, "up")
			player.floor = player.floor + 1
		end
		message.print("던전 ".. player.floor .."층으로 내려왔다.")
	end
	player.calcFOV()
	map.minimap.refresh()
end

function player.calcFOV()
	player.fov = {}
	local mapx, mapy
	local a, b
	for a = 1, 9 do
		player.fov[a] = {}
		for b = 1, 9 do
			mapx = player.x + a - 5
			mapy = player.y + b - 5
			player.fov[a][b] = 3
			if (mapx >= 1) and (mapx <= 25) then
				if (mapy >= 1) and (mapy <= 40) then
					if map.minimap[player.floor][mapx][mapy] == 1 then
						player.fov[a][b] = 2
					end
				end
			end
		end
	end
	
	--calculate fov
	local tblline
	for a = -4, 4 do
		--print("draw line: \n" .. player.x .. ":" .. player.y .. "/" .. player.x + a .. ":" .. player.y - 4 .. "\n")
		tblline = calc.bresenham(player.x, player.y, player.x + a, player.y - 4)
		
		for b = 1, #tblline do
			if map[player.floor][tblline[b][1]][tblline[b][2]] == 1 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
			elseif map[player.floor][tblline[b][1]][tblline[b][2]] == 2 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
				break
			end
		end
	end
	
	for a = -4, 4 do
		tblline = calc.bresenham(player.x, player.y, player.x + a, player.y + 4)
		
		for b = 1, #tblline do
			if map[player.floor][tblline[b][1]][tblline[b][2]] == 1 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
			elseif map[player.floor][tblline[b][1]][tblline[b][2]] == 2 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
				break
			end
		end
	end
	
	for a = -3, 3 do
		tblline = calc.bresenham(player.x, player.y, player.x + 4, player.y + a)
		
		for b = 1, #tblline do
			if map[player.floor][tblline[b][1]][tblline[b][2]] == 1 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
			elseif map[player.floor][tblline[b][1]][tblline[b][2]] == 2 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
				break
			end
		end
	end
	
	for a = -3, 3 do
		tblline = calc.bresenham(player.x, player.y, player.x - 4, player.y + a)
		
		for b = 1, #tblline do
			if map[player.floor][tblline[b][1]][tblline[b][2]] == 1 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
			elseif map[player.floor][tblline[b][1]][tblline[b][2]] == 2 then
				player.fov[tblline[b][1] - player.x + 5][tblline[b][2] - player.y + 5] = 1
				break
			end
		end
	end
	
	player.fov[5][5] = 1 --always can see player itself
end

function player.drawFOV()
	local a
	local b

	for a = 1, 9 do
		for b = 1, 9 do
			if player.fov[b][a] == 1 then --visible
				love.graphics.setColor(0, 0, 0, 0)
			elseif player.fov[b][a] == 2 then --visited
				love.graphics.setColor(0, 0, 0, 64)
			elseif player.fov[b][a] == 3 then --covered
				love.graphics.setColor(0, 0, 0, 255)
			end
			love.graphics.rectangle("fill", (b - 1) * game.tilesize, (a - 1) * game.tilesize, game.tilesize, game.tilesize)
		end
	end
	
	love.graphics.setColor(255, 255, 255)
end