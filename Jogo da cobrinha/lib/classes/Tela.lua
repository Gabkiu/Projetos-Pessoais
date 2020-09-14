	Tela = {}
local Metatable = {__index = Tela}

function Tela:Novo()
	local Tela = {
		Children = {},
	}
	table.insert(game.Telas,Tela)
	setmetatable(Tela, Metatable)
	return Tela
end

function Tela:Desenhar()
	for _,Objeto in pairs(self.Children) do
		Objeto:Desenhar()
	end
end

function Tela:Adicionar(Objeto)
	table.insert(self.Children,Objeto)
	Objeto.Dono = self
end