ui = {}

ui.x = 0
ui.y = 360

function ui.draw()
	--draw ui frame
	love.graphics.draw(imgframe, 0, 360)
	
	--draw name
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(player.name, ui.x + 9, ui.y + 12)
	--current floor
	love.graphics.draw(imgicofloor, ui.x + 100, ui.y + 6)
	love.graphics.print(player.floor .. "층", ui.x + 135, ui.y + 12)
	--attack
	love.graphics.draw(imgattack, ui.x + 169, ui.y + 6)
	love.graphics.print(player.getattribute("attack"), ui.x + 203, ui.y + 12)
	--defence
	love.graphics.draw(imgdefence, ui.x + 230, ui.y + 6)
	love.graphics.print(player.getattribute("defence"), ui.x + 265, ui.y + 12)
	--agility
	love.graphics.draw(imgagility, ui.x + 290, ui.y + 6)
	love.graphics.print(player.getattribute("agility"), ui.x + 325, ui.y + 12)

	--HP
	love.graphics.draw(imghealth, ui.x + 9, ui.y + 43)
	love.graphics.print(player.hp .. "/" .. player.maxhp, ui.x + 44, ui.y + 48)
	--HP Bar
	love.graphics.setColor(127, 127, 127)
	love.graphics.rectangle("fill", ui.x + 90, ui.y + 43, 260, 32)
	if player.hp >= 0 then
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", ui.x + 90, ui.y + 45, 2.6 * (player.hp / player.maxhp * 100), 28)
	end
	love.graphics.setColor(255, 255, 255)
	--Hunger & Hunger bar
	love.graphics.draw(imghunger, ui.x + 9, ui.y + 80)
	love.graphics.setColor(127, 127, 127)
	love.graphics.rectangle("fill", ui.x + 90, ui.y + 80, 260, 32)
	local satiety = ""
	if player.satiety > 750 then
		satiety = "과식"
		love.graphics.setColor(255, 0, 0)
	elseif player.satiety > 500 then
		satiety = "배부름"
		love.graphics.setColor(0, 255, 0)
	elseif player.satiety > 250 then
		satiety = "배고픔"
		love.graphics.setColor(255, 255, 0)
	else
		satiety = "굶주림"
		love.graphics.setColor(0, 0, 0)
	end
	love.graphics.print(satiety, ui.x + 44, ui.y + 85)
	if player.satiety >= 0 then
		love.graphics.rectangle("fill", ui.x + 90, ui.y + 82, 2.6 * (player.satiety / player.maxsatiety * 100), 28)
	end
	love.graphics.setColor(255, 255, 255)
end