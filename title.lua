title = {}

function title.load()
	scene = "title"
	title.namey = 610
	title.name = ""
end

function title.draw()
	--draw title picture
	love.graphics.draw(imgtitle)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 5, title.namey - 3, 350, 30)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("당신의 이름은? " .. title.name .. "_", 10, title.namey)
end

function title.keypressed(key)
	if key == "backspace" then
		title.name = hangul.sub(title.name, 1, utf8.len(title.name) - 1)
	elseif key == "return" then
		--Submit
		if not(title.name == "") then
			--TODO: check save file
			game.load()
		end
	end
end

function title.textinput(text)
	if string.len(title.name) <= 10 then
		title.name = title.name .. text
	end
end