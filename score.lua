score = {}

function score.load()
	scene = "score"
end

function score.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("잘가게, ".. player.name .. ".", 5, 5)
	love.graphics.print("==========명예의 전당==========", 5, 50)
	local a, score, name
	for i, score, name in highscore() do
	    love.graphics.print(name, 5, i * 20 + 55)
	    love.graphics.print(score .. "층에서 사망.", 100, i * 20 + 55)
	end
end

function score.keypressed(key)
	if key == "return" then
		love.event.quit()
	end
end