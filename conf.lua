io.stdout:setvbuf("no")

function love.conf(t)
	t.window.title = "CrappyRLexample"

    t.window.width = 360
    t.window.height = 640
	
	--t.console = true
	
	t.modules.physics = false
end