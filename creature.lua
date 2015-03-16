creature = {}

--creature name table
require "creature_table"

function creature.new(id, x, y, floor)
	local a
	local index
	
	index = #creature + 1
	
	for a = 1, #creature do
		if creature[a].enabled == false then
			index = a
			break
		end
	end
	
	creature[index] = {}
	creature[index].id = id
	creature[index].x = x
	creature[index].y = y
	creature[index].floor = floor
	creature[index].ap = 0 --action point of creature
	creature[index].hp = creature.gettable(id, "hp")
	creature[index].destination = nil --no destination
	creature[index].enabled = true
end

function creature.getcreature(x, y, floor)
	--get creature index of x, y, floor
	local a
	for a = 1, #creature do
		if creature[a].enabled == true then
			if creature[a].floor == floor then
				if (creature[a].x == x) and (creature[a].y == y) then
					return a
				end
			end
		end
	end
	
	--didn't found creature
	return nil
end

function creature.turn(passedtime)
	print("[Creature's turn!]")
	
	local a
	local ap
	for a = 1, #creature do
		if creature[a].enabled == true then
			if creature[a].floor == player.floor then
				--act creature
				ap = creature.tbl[creature.idtoindex[creature[a].id]].speed * passedtime / 100
				creature[a].ap = ap
				print("index " .. a .. "/" .. creature[a].id .. " Gets ".. ap .. "AP")
				creature.act(a)
			end
		end
	end
	
	print("[End of the creature's turn!]")
end

function creature.gettable(id, key)
	return creature.tbl[creature.idtoindex[id]][key]
end

function creature.act(index)
	print("[Creature] index " ..  index .. ":" .. creature[index].id .. " is acting now")
	local action
	local tblline
	local creaturename
	repeat
		--Look around and set destination
		if calc.cansee(creature[index].x, creature[index].y, player.x, player.y, player.floor) then
			--If creature can see player, update creature's destination
			creature[index].destination = {}
			creature[index].destination.x = player.x
			creature[index].destination.y = player.y
		end

		--Priority 1:melee attack
		tblline = calc.bresenham(player.x, player.y, creature[index].x, creature[index].y)
		if (#tblline == 1) and (creature.checkspecial(creature[index].id, "noattack") == false) then
			print("Melee attack!")
			creaturename = creature.gettable(creature[index].id, "name")
			--damage calculation
			if calc.hitroll(creature.gettable(creature[index].id, "agility"), player.getattribute("agility")) == true then
				--creature attackes player
				local dmg = calc.damage(creature.gettable(creature[index].id, "attack"), player.getattribute("defence"))
				if dmg == 0 then
					message.print("당신은 ".. creaturename .. " 의 공격을 막았다.")
				else
					message.print(creaturename .. hangul.getJosa(creaturename, "unnun") .." 당신을 공격했다!")
					player.hp = player.hp - dmg
					if player.hp <= 0 then
						--Player death scene
						player.hp = 0
						player.die()
					end
				end
			else
			    --creature missed player
			    message.print("당신은 " .. creaturename .. "의 공격을 피했다.")
			end
			action = "attack"
		--elseif -- Priority 2:special:scream
		--elseif -- Priority 3:special:magic
		elseif not(creature[index].destination == nil) and not(creature.tbl[creature.idtoindex[creature[index].id]].movement == "static") then --Priority 4:move
			print("Pathfinding from:" .. creature[index].x .. ":" .. creature[index].y)
			local direction = calc.path(creature[index].x, creature[index].y, creature[index].destination.x, creature[index].destination.y, creature[index].floor, index)
			creature.move(direction, index)
			action = "move"
		else
			--Priority last: idle
			print("Idle")
			action = "nothing"
		end

		creature[index].ap = creature[index].ap - aptable[action]
		print(creature[index].ap .. " AP Left.")
	until(creature[index].ap <= 0)
	print("[END]")
end

function creature.draw()
	local a
	for a = 1, #creature do
		if creature[a].enabled == true then
			if creature[a].floor == player.floor then
				love.graphics.draw(imgcreature, quadcreature[creature.idtoindex[creature[a].id]], (creature[a].x + 4 - player.x) * 40, (creature[a].y + 4 - player.y) * 40)
			end
		end
	end
end


function creature.move(direction, index)
	--move player
	local fakex = creature[index].x
	local fakey = creature[index].y
	
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
			if not(map[creature[index].floor][fakex][fakey] == 2) then
				--check collision with creature
				local colcreature = creature.getcreature(fakex, fakey, creature[index].floor)
				if colcreature == nil then
					creature[index].x = fakex
					creature[index].y = fakey
				end
			end
		end
	end
end

function creature.checkspecial(id, special)
	--check if [id] have [special] ability
	local tblspecial = creature.gettable(id, "special")
	local a
	if tblspecial == nil then
		return false
	else
		for a = 1, #tblspecial do
			if tblspecial[a] == special then
				return true
			end
		end
	end

	return false
end