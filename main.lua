require "title"
require "game"
require "player"
require "map"
require "stairs"
require "message"
require "ui"
require "calc"
require "creature"
require "aptable"
require "/lib/han/hangul"
highscore = require "/lib/sick/sick"
require "score"

function love.load()
	--make new font
	font = love.graphics.newFont("graphics/nngd.ttf", 15)
	love.graphics.setFont(font)
	
	--load resources
	imgtitle = love.graphics.newImage("graphics/title.png")
	imglogo = love.graphics.newImage("graphics/logo.png")
	imgtile = {}
	imgtile[1] = love.graphics.newImage("graphics/tile_floor.png") --floor
	imgtile[2] = love.graphics.newImage("graphics/tile_wall.png") --wall
	imgframe = love.graphics.newImage("graphics/menu_frame.png") --menu frame
	imgplayer = love.graphics.newImage("graphics/player.png") --player
	imgstairs = {}
	imgstairs["up"] = love.graphics.newImage("graphics/stairs_up.png")
	imgstairs["down"] = love.graphics.newImage("graphics/stairs_down.png")
	imgicofloor = love.graphics.newImage("graphics/icon_floor.png")
	imgcreature = love.graphics.newImage("graphics/creature.png")
	quadcreature = {}
	local a
	for a = 1, #creature.tbl do
		quadcreature[a] = love.graphics.newQuad((a - 1) * 40, 0, 40, 40, 720, 40)
	end
	imgattack = love.graphics.newImage("graphics/attack.png")
	imgdefence = love.graphics.newImage("graphics/defence.png")
	imgagility = love.graphics.newImage("graphics/agility.png")
	imghealth = love.graphics.newImage("graphics/hp.png")
	imghunger = love.graphics.newImage("graphics/hunger.png")

	math.randomseed(os.time())

	highscore.set("rlexample", 20, "norubal", 1)
	
	title.load()
end

function love.draw()
	if scene == "title" then
		title.draw()
	elseif scene == "game" then
		game.draw()
	elseif scene == "score" then
		score.draw()
	end
end

function love.keypressed(key)
	if scene == "title" then
		title.keypressed(key)
	elseif scene == "game" then
		game.keypressed(key)
	elseif scene == "score" then
		score.keypressed(key)
	end
end

function love.textinput(text)
	if scene == "title" then
		title.textinput(text)
	end
end

function collcheck(x1, y1, w1, h1, x2, y2, w2, h2)
-- check pix1 and pix2 are collide
-- usage: collcheck(blabla~) => true|false
    if (x1 + w1) > x2 and x1 < (x2 + w2) then
        if (y1 + h1) > y2 and y1 < (y2 + h2) then
            return true
        end
    end

	return false
end