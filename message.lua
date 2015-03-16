message = {}
message.index = 1

function message.draw()
	if not(message[message.index] == nil) then
		if message[message.index + 1] == nil then
			love.graphics.printf(message[message.index], 5, 5, 360 - 5 * 2)
		else
			love.graphics.printf(message[message.index] .. "\n--다음장--", 5, 5, 360 - 5 * 2)
		end
	end
end

function message.init()
	local a
	for a = 1, #message do
		message[a] = nil
	end
	message.index = 1
	print("[M] message inited")
end

function message.print(msg)
	message[#message + 1] = msg
end

function message.list()
	print("===list of message start===")
	local a
	for a = 1, #message do
		print("[" .. a .. "]:" .. message[a])
	end
	print("===end of message==")
end