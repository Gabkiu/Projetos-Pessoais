Evento = {}
Evento.Classe = Evento
local Metatable = {}

function Evento:Novo()
	local Evento = {}
	Evento.Conexoes = {}
	Evento.Aguardos = {}
	setmetatable(Evento,Metatable)
	return Evento
end

function Evento:Conectar(funcao)

	local conexao = Conexao:Novo(self,funcao)
	table.insert(self.Conexoes,conexao)
	return conexao
end
function Evento:Remover(conexao)
	local Indice = table.find(self.Conexoes,conexao)
	table.remove(self.Conexoes,Indice)
end
function Evento:Ativar(...)
	
	local remover = {}
	for i,aguardo in pairs(self.Aguardos) do
		table.insert(remover,i)
		aguardo:Resumir(...)
		aguardo:Finalizar()
	end
	for _,conexao in pairs(self.Conexoes) do
		local t = Thread:Novo(conexao.Funcao)
		t:Resumir(...)
		t.Removivel = Evento.Removivel
	end
	
	
	for _,i in pairs(remover) do
		table.remove(self.Aguardos,i)
	end
end
function Evento:Aguardar()
	local coroutina = coroutine.running()
	local thread = Thread:AcharPorCoroutina(coroutina)
	table.insert(self.Aguardos,thread)
	
	coroutine.yield()
end
function Evento:Destruir()
	Objeto.Destruir(self)
end

Metatable.__index = function(t,k)
	return rawget(Conexao,k)  or rawget(Evento,k)
end

return Evento