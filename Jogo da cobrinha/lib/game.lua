game = {
	Threads = {},
	Telas = {}
}
local eventos = {
	"draw","update","keypressed","mousemoved","mousepressed","mousereleased","fixedupdate"
}

game.scale = Vetor:Novo()
game.CorBackground = Cor:Novo(0,0,0)
game.setColor = function(cor)
	love.graphics.setColor(cor.R/255,cor.G/255,cor.B/255)
end
game.DesenharBackground = function()
	game.setColor(game.CorBackground)
end

for _,key in pairs(eventos) do
	local evento =  Evento:Novo()
	evento.Removivel = true
	game[key] = evento
	love[key] = function(...)
		evento:Ativar(...)
	end
end


local function fixed_update(dt)
	game.fixedupdate:Ativar(dt)
end

-- Aguarda as threads e resume os waits
game.update:Conectar(function(dt)
	math.randomseed(love.timer.getTime())
	for i=1,10 do Thread.Tick(dt) end 
	fixed_update(dt)
	collectgarbage("collect")
	FinalizarThread()
end)


game.draw:Conectar(function()
	for _,tela in pairs(game.Telas) do
		tela:Desenhar()
	end
	FinalizarThread()
end)
game.AguardarKey = function(key)
	local ok = false
	local connect = game.keypressed:Conectar(function(pkey)
		ok = pkey == key
	end)
	while true do
		if ok then break end
		game.keypressed:Aguardar()
	end
	FinalizarThread()
end

return game