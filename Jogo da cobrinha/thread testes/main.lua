require("thread")

local T = Thread:Novo(function()
	local s = love.timer.getTime()
	print("Olá")
	local s = love.timer.getTime()
	Aguardar(0.1)
	print("Aguardar 0.1 segundos levou: ",love.timer.getTime()-s)
	local s = love.timer.getTime()
	Aguardar(0.25)
	print("Aguardar 0.25 segundos levou: ",love.timer.getTime()-s)
	local s = love.timer.getTime()
	Aguardar(0.5)
	print("Aguardar 0.5 segundos levou: ",love.timer.getTime()-s)
	local s = love.timer.getTime()
	Aguardar(1)
	print("Aguardar 1 segundo levou: ",love.timer.getTime()-s)
end)

T:Resumir()

function love.update()
	Thread.Tick()
end