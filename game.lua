game = {}

game.tilesize = 40

function game.load()	
	--TODO:load map
	
	--new game
	game.map = {}
	
	local a, b, c
	for a = 1, 5 do --1st floor ~ 5th floor
		game.map[a] = {}
		for b = 1, 80 do
			game.map[a][b] = {}
			for c = 1, 25 do
				game.map[a][b][c] = 1
			end
		end
	end
	
	player.init(title.name)
	map.generate(1)
	player.x, player.y = stairs.getstairs(1, "up")
	
	game.minimap = true
	
	game.phase = "main"
	scene = "game"
	player.calcFOV()
	map.minimap.refresh()
	message.print("던전에 온 것을 환영하네!, 모험자여!")
end

function game.draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, 360, 360)
	love.graphics.setColor(255, 255, 255)
	--draw map
	map.draw()
	
	--TODO:draw items
	
	--draw stairs
	stairs.draw()
	
	--draw creatures
	creature.draw()
	
	--draw player
	love.graphics.draw(imgplayer, 4 * game.tilesize, 4 * game.tilesize)
	
	--draw FOV
	player.drawFOV()
	
	--draw minimap
	if game.minimap == true then
		map.minimap.draw()
	end
	
	--draw ui
	ui.draw()
	
	--draw message
	message.draw()
end

function game.keypressed(key)
	if game.phase == "main" then
		player.action = nil
		player.passedtime = 0
		
		--minimap toggle on/off
		if key == "m" then 
			if game.minimap == false then
				game.minimap = true
			else
				game.minimap = false
			end
		end		
		
		--check message first
		if not(message[message.index + 1] == nil) then
			--More--
			if (key == " ") or key == "return" then
				message.index = message.index + 1
				if player.state == "dead" then
					highscore.add(player.name, player.floor)
					score.load()
					highscore.save()
				end
			end
			return
		end

		message.init() --init message
		
		--move player
		if key == "up" then
			player.move("up")
		elseif key == "down" then
			player.move("down")
		elseif key == "left" then
			player.move("left")
		elseif key == "right" then
			player.move("right")
		elseif key == "pageup" then
			player.move("upleft")
		elseif key == "pagedown" then
			player.move("upright")
		elseif key == "home" then
			player.move("downleft")
		elseif key == "end" then
			player.move("downright")
		end
		
		--stairs up/down
		local sx, sy
		if key == "," then
			sx, sy = stairs.getstairs(player.floor, "up")
			if (player.x == sx) and (player.y == sy) then
				if player.floor == 1 then
					--TODO: move up from first stairs
				else
					player.movestairs("up")
					player.action = "stairs"
				end
			else
				message.print("그곳에는 올라가는 계단이 없다.")
			end
		elseif key == "." then
			sx, sy = stairs.getstairs(player.floor, "down")
			if (player.x == sx) and (player.y == sy) then
				player.movestairs("down")
				player.action = "stairs"
			else
				message.print("그곳에는 내려가는 계단이 없다.")
			end
		end

		--do nothing
		if key == "s" then
			player.action = "nothing"
		end		

		if key == "q" then
			player.die()
		end

		if not(player.action == nil) then --If player did something in this turn
			--calculate player's passed time
			player.passedtime = player.calcpassedtime(player.action)
			print("[Player] passed time: ".. player.passedtime .. "/action:" .. player.action)
			
			--regen player
			player.regen = player.regen - 1
			if player.regen <= 0 then
				player.regen = 5
				if not(player.hp == player.maxhp) then
					player.hp = player.hp + 1
				end
			end

			--hunger
			player.satiety = player.satiety - math.random(1, player.floor)
			if player.satiety <= 0 then
				player.satiety = 0
				player.die()
			end

			--move creatures
			creature.turn(player.passedtime)

			print("==================================")
		end
	end
end