Tween = {}
local Metatable =  {__index = Tween}
local T_Tween = {}
local T_Metatable = {__index = T_Tween}

function T_Tween:Novo(Tweens)
	local Tween = {Tweens = Tweens}
	Tween.Terminou = Tweens[1].Terminou
	Tween.Step = Tweens[1].Step

	Tween.Terminou:Conectar(function() print("tween terminou") end)
	setmetatable(Tween,T_Metatable)
	return Tween
end
function T_Tween:Resumir()
	for _,tween in pairs(self.Tweens) do
		tween:Resumir()
	end	
end
function T_Tween:Pausar()
	for _,tween in pairs(self.Tweens) do
		tween:Pausar()
	end
end

function Tween:Novo(Table,Propriedade,Valor,Steps,Tempo)
	if type(Propriedade) == "table" then
		local tweens = {}
		local i = 1
		for propriedade,valor in pairs(Propriedade) do
			local tween = Tween:Novo(Table,valor,Valor[i],Steps,Tempo)
			table.insert(tweens,tween)
			i = i + 1
		end
		local Tween = T_Tween:Novo(tweens)
		return Tween
	end
	local Tween = {Steps = Steps,Table = Table,Propriedade = Propriedade,Valor = Valor,Tempo = Tempo,
Terminou = Evento:Novo()}
	Tween.Step = Evento:Novo()
	setmetatable(Tween,Metatable)
	return Tween
end

function Tween:Resumir()
	local Tween =self
	local ValorAtual = Tween.Table[Tween.Propriedade]
	local Steps = Tween.Steps
	local Diferenca = Tween.Valor - ValorAtual 
	local Incremento = Diferenca/Steps
	local Espera = Tween.Tempo/Steps
	local Propriedade = Tween.Propriedade
	local inicio = love.timer.getTime()


	local play = Thread:Novo(function()
		for i=1,Steps do
			Tween.Table[Propriedade] = Tween.Table[Propriedade] + Incremento
			Aguardar(Espera)
			Tween.Step:Ativar(Incremento)
		end
		Tween.Terminou:Ativar()
		FinalizarThread()
		Tween:Destruir()
	end)

	play:Resumir()
	--print("Tween: ",love.timer.getTime()-inicio,Tween.Tempo)
	
end

function Tween:Destruir()
	for _,v in pairs(self) do
		if type(v) == "table" then
			if v.Classe == Evento then
				v:Destruir()
			end
		end
	end
	limpar_data(getfenv(1),self)

	collectgarbage('collect')
end

function Tween:Pausar()
	local Tween = self
	if Tween.Thread then
		Tween.Pausado = true
		coroutine.yield(Tween.Thread.Coroutina)
	end
end