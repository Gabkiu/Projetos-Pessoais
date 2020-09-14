require("lib.load")
require("player")

local Player = Player:Novo()
local Keys = {
	"a","s","w","d"
}

local Tela = Tela:Novo()

local t1 = Frame:Novo()
t1.Colide = true
t1.Posicao = Vetor:Novo(250,250)
t1.Tamanho = Vetor:Novo(52,200)
Tela:Adicionar(t1)

function encontrar(tab)
	local i = 0
	for _,k in pairs(tab) do
		if type(k) == "table" then
			i = i + encontrar(k)
		end
		i = i + 1
	end
	return i
end
game.update:Conectar(function()
	local melhor = 0
	for _,Key in pairs(Keys) do
		if love.keyboard.isDown(Key) then
			Player:Mover(Key)
		end
	end
	local Objetos = PegarTodosObjetos()

	for _,v in pairs(Objetos) do

		v:Mover()
	end
end)

game.keypressed:Conectar(function(key)
	if key == "space" then
		Player:Atacar()
		--Player.Corpo.Posicao = Vetor:Novo(0,0)
	end
end)
