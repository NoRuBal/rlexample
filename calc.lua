calc = {}

function calc.path(startx, starty, endx, endy, floor, index)
    local collisionmap = calc.getgrid(floor, index)
    --[[
    local a, b, strmap
    strmap = ""
    for a = 1, 40 do
        for b = 1, 25 do
            strmap = strmap .. collisionmap[a][b]
        end
        strmap = strmap .. "\n"
    end
    print(strmap)
    print("Map Size: Height" .. #collisionmap .. ":Width" .. #collisionmap[1])
    ]]--
    -- Library setup
    -- Calls the grid class
    local Grid = require ("/lib/jumper.grid")
    -- Calls the pathfinder class
    local Pathfinder = require ("/lib/jumper.pathfinder")
    local walkable = 0
    local grid = Grid(collisionmap)
    local myFinder = Pathfinder(grid, 'JPS', walkable)
    local path = myFinder:getPath(startx, starty, endx, endy)

    local newx, newy
    if path then
      print(('Path found! Length: %.2f'):format(path:getLength()))
        for node, count in path:nodes() do
            --print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
            if count == 2 then
                return calc.getdirection(startx, starty, node:getX(), node:getY())
            end
        end
    end

    return nil
end

function calc.getdirection(startx, starty, endx, endy)
    if (startx == endx) and (starty == endy) then
        return "same"
    elseif (startx == endx) and (starty > endy) then
        return "up"
    elseif (startx == endx) and (starty < endy) then
        return "down"
    elseif (startx > endx) and (starty == endy) then
        return "left"
    elseif (startx < endx) and (starty == endy) then
        return "right"
    elseif (startx > endx) and (starty > endy) then
        return "upleft"
    elseif (startx > endx) and (starty < endy) then
        return "downleft"
    elseif (startx < endx) and (starty > endy) then
        return "upright"
    elseif (startx < endx) and (starty < endy) then
        return "downright"
    end
end

function calc.cansee(startx, starty, endx, endy, floor)
    --return if start can see x via LOS
    local line = calc.bresenham(startx, starty, endx, endy)

    if #line >= 5 then
        return false
    end
    
    local a
    for a = 1, #line do
        if map[floor][line[a][1]][line[a][2]] == 2 then
            return false
        end
    end

    return true
end

function calc.getgrid(floor, index)
    --get creature index's grid as table
    local a
    local b

    local grid = {}
    local rotatedgrid = {}

    for a = 1, 25 do
        grid[a] = {}
        for b = 1, 40 do
            grid[a][b] = map[floor][a][b]
        end
    end

    for a = 1, #creature do
        if creature[a].floor == floor then
            if not(a == index) then
                if creature[a].enabled == true then
                    grid[creature[a].x][creature[a].y] = 2
                end
            end
        end
    end
    local stairsx, stairsy = stairs.getstairs(floor, "up")
    if not(stairsx == nil) then
        grid[stairsx][stairsy] = 2
    end
    local stairsx, stairsy = stairs.getstairs(floor, "down")
    if not(stairsx == nil) then
        grid[stairsx][stairsy] = 2
    end

    for a = 1, 25 do
        for b = 1, 40 do
            grid[a][b] = grid[a][b] - 1
        end
    end    

    for a = 1, 40 do
        rotatedgrid[a] = {}
        for b = 1, 25 do
            rotatedgrid[a][b] = grid[b][a]
        end
    end
    return rotatedgrid
end

function calc.damage(attack, defence)
    --defence roll
    local rollatk = math.random(1, attack)
    local rolldef = math.random(1, defence)
    local dmg = math.random(1, attack)
	if rollatk > rolldef then
		dmg = dmg - math.floor(math.random(1, defence) / 2)
	end
    if dmg < 0 then
        dmg = 0
    end
	return dmg
end

function calc.hitroll(atkagi, dodagi)
    --return true/false if attack is hit or dodged
    --based on attacker's agility and dodger's agility
    if dodagi <= 0 then
        return true
    end
    if atkagi <= 0 then
        return false
    end
    local atk = math.random(math.floor(atkagi / 2), atkagi)
    local dod = math.random(1, dodagi)
    if atk >= dod then
        return true
    else
        return false
    end
end

function calc.bresenham(x1, y1, x2, y2)
	local tmplist = {}
	
	local delta_x, ix, delta_y, iy, error
    delta_x = x2 - x1
    ix = delta_x > 0 and 1 or -1
    delta_x = 2 * math.abs(delta_x)
 
    delta_y = y2 - y1
    iy = delta_y > 0 and 1 or -1
    delta_y = 2 * math.abs(delta_y)
 
    if delta_x >= delta_y then
        error = delta_y - delta_x / 2
 
        while x1 ~= x2 do
            if (error >= 0) and ((error ~= 0) or (ix > 0)) then
                error = error - delta_x
                y1 = y1 + iy
            end
 
            error = error + delta_y
            x1 = x1 + ix
 
            table.insert(tmplist, {x1, y1})
        end
    else
        error = delta_x - delta_y / 2
 
        while y1 ~= y2 do
            if (error >= 0) and ((error ~= 0) or (iy > 0)) then
                error = error - delta_y
                x1 = x1 + ix
            end
 
            error = error + delta_x
            y1 = y1 + iy
 
            table.insert(tmplist, {x1, y1})
        end
    end
	
	return tmplist
end

