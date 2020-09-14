Conexao = {}
local metatable = {__index = Conexao}

function Conexao:Novo(evento,funcao)
	local Conexao = {evento  = evento}
	Conexao.Funcao = funcao
	setmetatable(Conexao,metatable)
	return Conexao
end

function Conexao:Desconectar()
	self.evento:Remover(self)
end

return Conexao
