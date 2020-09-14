require("lib.load")

local V1 = Vetor:Novo(1,0.5)
local V2 = Vetor:Novo(0,5)



local Tela1 = Tela:Novo()
local Pos_Comida = nil

local function NovaComida()
	local x = math.random(0,9)/10
	local y = math.random(0,9)/10

	Pos_Comida = Vetor:Novo(x,y):ABS()
	Pos_Comida.X = math.round(Pos_Comida.X,50)
	Pos_Comida.Y = math.round(Pos_Comida.Y,50)
	for _,p in pairs(Cobra.Corpo) do
		if p == Pos_Comida then
			NovaComida()
			break
		end
	end
	if Cobra.Posicao == Pos_Comida then
		NovaComida()
	end
end

Cobra = {
	Corpo = {},
	Historico = {},
	Mover = function(Cobra,Posicao)
		local final = Posicao + Cobra.Tamanho
		local w,h = love.graphics.getWidth(),love.graphics.getHeight()
		if (final.X > w or final.Y > h) or (Posicao.X < 0 or Posicao.Y < 0 ) then
			Cobra:Morrer()
			return
		end
		Cobra.Posicao = Posicao
		table.insert(Cobra.Historico,Posicao)
		for i,v in pairs(Cobra.Corpo) do
			if v:Distancia(Posicao) < 5 then
				Aguardar(0.2)
				Cobra:Morrer()
				return 
			end
			Cobra.Corpo[i] = Cobra.Historico[#Cobra.Historico-i]
		end
		
		if Posicao:Distancia(Pos_Comida) < 5 then
			Cobra:Comer()
		end
	end,
	Comer = function(Cobra)
		local Pos = Cobra.Historico[#Cobra.Historico - #Cobra.Corpo-1]
		table.insert(Cobra.Corpo,Pos)
		NovaComida()
		Cobra.Score = Cobra.Score + 1 

		local function mudar_cor()

			local Tween1 = Tween:Novo(Cobra.Cor,"G",0,0.25)
			local t1_2 = Tween:Novo(Cobra.Cor,"B",0,0.5)
			local Tween2 = Tween:Novo(Cobra.Cor,{"G","B"},{255,255},0.5)
			Cobra.Delay = Cobra.Delay/1.5
			Tween1:Resumir()
			t1_2:Resumir()
			Tween1.Terminou:Aguardar()
			Aguardar(0.2)
			Cobra.Delay = Cobra.Delay*1.5
			Tween2:Resumir()
		end
		local thread = Thread:Novo(mudar_cor)
		thread:Resumir()
	end,
	Morrer =function(Cobra)
		Aguardar(0.2)
		Cobra.Corpo = {}
		Cobra.Posicao = Vetor:Novo(50,50)
		Cobra.Historico = {[1] = Cobra.Posicao}
		Cobra.Key = "d"
		Cobra.Dir = Pos.d
		NovaComida()
		Cobra:Inicializar()
	end,
	Tamanho = Vetor:Novo(23*2,23*2),
	Posicao = Vetor:Novo(50,50),
	vel = 2,
	Delay = 0.1,
	Cor = Cor:Novo(255,255,255),
}


local abss = Cobra.Tamanho
local w,h = abss.X,abss.Y

local function Desenhar()
	love.graphics.setColor(Cobra.Cor:Unpack())
	for _,posicao in pairs(Cobra.Corpo) do
		local posicao = posicao
		local x,y = posicao.X,posicao.Y
		love.graphics.rectangle("fill",x+7,y+7,w,h)
	end
	local pos = Cobra.Posicao
	love.graphics.rectangle("fill",pos.X+7,pos.Y+7,w,h)
	if Pos_Comida then
		local pos = Pos_Comida
		love.graphics.setColor(0.5,1,0.5)
		love.graphics.rectangle("fill",pos.X+7,pos.Y+7,w,h)
	end
end



Pos = {
	 a = Vetor:Novo(-25*Cobra.vel,0),
	 d = Vetor:Novo(25*Cobra.vel,0),
	 s = Vetor:Novo(0,25*Cobra.vel),
	 w = Vetor:Novo(0,-25*Cobra.vel),
}
local Reversos =  {
	a = "d",
	d = "a",
	w = "s",
	s = "w",

}
Cobra.Inicializar = function(Cobra)
	Cobra.Dir = Pos.d
	Cobra.Key = "d"

	Cobra.Historico[1] = Cobra.Posicao
	Cobra.Historico[2] = Cobra.Historico[1] + Cobra.Dir
	Cobra.Posicao = Cobra.Historico[2] 

	Cobra.Corpo = {
		Cobra.Historico[1],Cobra.Historico[2]
	}
	Cobra.Score = 0
end
Cobra:Inicializar()

game.draw:Conectar(Desenhar)
game.keypressed:Conectar(function(key)

	if key == "f11" then
		love.window.setFullscreen(not love.window.getFullscreen())
		return
	end
	if key == "lshift" then
		Cobra.Delay = 0.075
		game.AguardarKey("lshift")
		Cobra.Delay = 0.1
		return
	end
	local vel = Pos[key]
	if vel then
		local reverso = Reversos[Cobra.Key] == key
		
		if reverso and #Cobra.Corpo > 0 then
			return
		end
		Cobra.Key = key
		Cobra.Dir = vel
	end
	
end)

local Mover_Thread = Thread:Novo(function()
	while true do
		Aguardar(Cobra.Delay)
		Cobra:Mover(Cobra.Posicao + Cobra.Dir)
	end
end)
math.randomseed(love.timer.getTime())
NovaComida()
Mover_Thread:Resumir()
local Font = love.graphics.newFont("fontes/bgothm.ttf",24)
local Score = love.graphics.newText(Font)
local FPS = love.graphics.newText(Font)

local Desenhar_Borda = function()
	local w,h = love.graphics.getWidth(),love.graphics.getHeight()
	Score:set("Score: ".. Cobra.Score)
	FPS:set("FPS: " .. love.timer.getFPS( ))
	love.graphics.rectangle("line",5,5,w-5,h-5)
	love.graphics.draw(Score,10,8)
	love.graphics.draw(FPS,10,8+Font:getHeight())
end

game.draw:Conectar(Desenhar_Borda)



