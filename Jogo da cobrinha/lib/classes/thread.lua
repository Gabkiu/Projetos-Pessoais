Thread = {Threads = {}}
local Metatable = {__index = Thread}

local function Aguardar(Tempo)
	local thread = Thread:AcharPorCoroutina(coroutine.running())
	thread.Final = love.timer.getTime() + Tempo
	thread.Tempo = Tempo
	coroutine.yield()

end

function Thread:AcharPorCoroutina(coroutina)
	for _,thread in pairs(self.Threads) do
		if thread.Coroutina == coroutina then
			return thread
		end
	end
end

function Thread:Novo(func)
	local thread = {}
	local fenv = getfenv(func)
	setmetatable(thread,Metatable)

	fenv.Aguardar = Aguardar
	fenv.FinalizarThread = function()
		thread:Finalizar()
	end
	setfenv(func,fenv)
	local c = coroutine.create(func)
	thread.Coroutina = c
	
	table.insert(self.Threads,thread)
	return thread
end

function Thread:Resumir(...)
	local thread = self
	thread.Final = nil
	thread.Comecou = true
	local sucesso,erro = coroutine.resume(thread.Coroutina,...)
	if not sucesso then error(erro) end
	thread.END = true
end

function Thread.Tick(dt)
	print(#Thread.Threads)
	local tempo = love.timer.getTime()
	local para_remover = {}
	for indice,thread in pairs(Thread.Threads) do
		local co = thread.Coroutina
		if thread.Final then
			if  tempo >= thread.Final then
				--print("TEMPO ABS:",thread.Tempo,":",tempo - thread.Inicio)
				thread:Resumir()
			end
		end
		if thread.END  then
			
			table.insert(para_remover,indice)
		end
	end
	for _,indice in pairs(para_remover) do
		table.remove(Thread.Threads,indice)
	end
	LIMPAR()
end

function Thread:Finalizar()
	local Thread = self
	Thread.END = true
end

