Thread = {Threads = {}}
local Metatable = {__index = Thread}

local function Aguardar(Tempo)
	print("Aguardando",Tempo)
	local thread = Thread:AcharPorCoroutina(coroutine.running())
	thread.Inicio = love.timer.getTime()
	thread.Final = love.timer.getTime() + Tempo
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
	fenv.Aguardar = Aguardar
	setfenv(func,fenv)
	local c = coroutine.create(func)
	thread.Coroutina = c
	setmetatable(thread,Metatable)
	table.insert(self.Threads,thread)
	return thread
end

function Thread:Resumir()
	local thread = self
	coroutine.resume(thread.Coroutina)
end

function Thread.Tick()
	local tempo = love.timer.getTime()
	for _,thread in pairs(Thread.Threads) do
		local co = thread.Coroutina
		if thread.Final then
			
			local dif = thread.Final 
			if  tempo >= thread.Final then
				
				
				print("TEMPO ABS:",tempo , thread.Inicio,thread.Final)
				thread.Final = nil
				thread:Resumir()
			end
		end
	end
end

