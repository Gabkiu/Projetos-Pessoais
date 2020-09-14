function math.map(x, in_min, in_max, out_min, out_max)
	return out_min + (x - in_min)*(out_max - out_min)/(in_max - in_min)
end
function math.round(exact, quantum)
	local quant,frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end
function table.find(table,value)
	for indice,raw_value in pairs(table) do
		if raw_value == value then return indice end
	end
end

function LIMPAR()
	collectgarbage()
	collectgarbage()
end

function limpar_data(env,var)
	local env = getfenv(1)
	local i
	for k,v in pairs(env) do
		if v == var then
			i = k
		end
	end
	if i then
		env[i] = nil
	end
end

function PegarDescendentes(Objeto)
	local Descendentes = {}
	local function procurar(grupo)
		for _,child in pairs(grupo) do
			table.insert(Descendentes,child)
			procurar(child.Children)
		end
	end
	procurar(Objeto.Children)
	return Descendentes
end
function PegarTodosObjetos()
	local Objetos = {}
	for _,Tela in pairs(game.Telas) do
		local Descendentes = PegarDescendentes(Tela)
		if #Descendentes > 0 then
			for _,v in pairs(Descendentes) do
				table.insert(Objetos,v)
			end
		end
	end
	return Objetos
end

function ChecarColisoes(Objeto,Posicao)
	local Colisoes = {}
	local Todos_Objetos = PegarTodosObjetos()

	local Posicao = Posicao or Objeto:ABS_POS()
	local Tamanho = Objeto.Tamanho

	for _,Alvo in pairs(Todos_Objetos) do
		local FORA = Posicao == Alvo.Posicao + Alvo.Tamanho or
		(Posicao.Y+Tamanho.Y == Alvo.Posicao.Y and Posicao.X == Alvo.Posicao.X + Alvo.Tamanho.X) or
		(Posicao == Alvo.Posicao - Tamanho) or
		(Posicao.Y == Alvo.Posicao.Y + Alvo.Tamanho.Y and Posicao.X == Alvo.Posicao.X - Tamanho.X)
		if not FORA then
			local A_Esquerda = Posicao.X + Tamanho.X < Alvo.Posicao.X
			local A_Direita = Posicao.X > Alvo.Posicao.X + Alvo.Tamanho.X

			local A_Cima = Posicao.Y + Tamanho.Y < Alvo.Posicao.Y
			local A_Baixo = Posicao.Y > Alvo.Posicao.Y + Alvo.Tamanho.Y

			local X_Alinhado = not A_Cima and not A_Baixo
			local Y_Alinhado = not A_Esquerda and not A_Direita

			Colisoes.Direita = X_Alinhado and Posicao.X + Tamanho.X == Alvo.Posicao.X
			Colisoes.Esquerda = X_Alinhado and Posicao.X == Alvo.Posicao.X + Alvo.Tamanho.X

			Colisoes.Cima = Y_Alinhado and Posicao.Y == Alvo.Posicao.Y + Alvo.Tamanho.Y
			Colisoes.Baixo = Y_Alinhado and Posicao.Y + Tamanho.Y == Alvo.Posicao.Y
		end
	end
	return Colisoes

end
