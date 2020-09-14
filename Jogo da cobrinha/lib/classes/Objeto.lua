Objeto = {}
local Metatable = {__index = Objeto}

function Objeto:Novo()
	local Objeto = {
		Tamanho = Vetor:Novo(30,30),
		Posicao = Vetor:Novo(0,0),

		Cor = Cor:Novo(255,255,255),
		BordaCor = Cor:Novo(40,40,40),

		BordaPixels = 1,

		Children = {},
		Visivel = true,
		Transparencia = 0,

		Arrastavel = false,

		MouseEntrou = Evento:Novo(),
		MouseSaiu = Evento:Novo(),
		MouseClick = Evento:Novo(),
		MouseSoltou = Evento:Novo(),
		DoubleClick = Evento:Novo(),

		Velocidade = Vetor:Novo(),
		Forcas = {},
		Colide = false,
		GrupoColisoes = 1,
	}
	setmetatable(Objeto,Metatable)
	return Objeto
end

function Objeto:AplicarForca(Forca)
	table.insert(self.Forcas,Forca)
end
function Objeto:CalcularVelocidade()
	local velocidade = Vetor:Novo(0,0)
	local velocidades = {}
	for i,v in pairs(self.Forcas) do
		local vel =  v
		
		velocidade = velocidade + vel
		table.insert(velocidades,vel)
	end
	return velocidade
end
function Objeto:Mover()
	local Objeto = self
	local Objetos = PegarTodosObjetos()
	local Velocidade = self:CalcularVelocidade()
	local Posicao = Objeto:ABS_POS()
	if Velocidade.X == 0 and Velocidade.Y == 0 then
		return
	end
	local Direcoes = {
		X = nil,Y = nil
	}
	if Velocidade.X > 0 then 
		Direcoes.X = "Direita"
	elseif Velocidade.X < 0 then
		Direcoes.X = "Esquerda"
	end
	if Velocidade.Y > 0 then
		Direcoes.Y = "Baixo"
	elseif Velocidade.Y < 0 then
		Direcoes.Y = "Cima"
	end
	if Direcoes.X == nil and Direcoes.Y == nil then  return end

	local passos_x = 0
	local passos_y = 0

	local mul_x = 1
	local mul_y = 1

	if Velocidade.X < 0 then mul_x = -1 end
	if Velocidade.Y < 0 then mul_y = -1 end

	local ww = love.graphics.getWidth()
	local wh = love.graphics.getHeight()

	local pos_final =Posicao + Velocidade
	local diferenca = pos_final - Posicao

	local d_y = diferenca.Y
	local d_x = diferenca.X


	local y_step = math.abs(d_y)/math.abs(diferenca.X) * mul_y
	local x_step = 1 * mul_x
	local fac = math.abs(diferenca.X)
	if d_x == 0 then
		y_step = 1 * mul_y
		x_step = 0
		fac = math.abs(d_y)
	end
	local t = Tela:Novo()
	local pos_atual = Posicao
	local add = Vetor:Novo(x_step,y_step)
	local his = {}
	local pos_final = Posicao + Velocidade

	local col_final = ChecarColisoes(Objeto,pos_final)
	
	local function checar(Pos)
		local Colisoes = ChecarColisoes(Objeto,Pos)
		if Colisoes.Dentro then
			pos_atual = pos_atual - add 
			add.X = 0 add.Y = 0 
			return  
		end
		if Colisoes[Direcoes.X] or Colisoes.Dentro then
			add.X = 0
		end
		if Colisoes[Direcoes.Y] or Colisoes.Dentro then
			add.Y = 0
		end
	end
	for i=1,fac do
		checar(pos_atual)
		pos_atual = pos_atual + add
	end
	

	
	Objeto.Posicao = pos_atual

	Objeto.Forcas = {}
	if Mover_X or Mover_Y then
		local r = Continuar()
		
		Objeto.Posicao = r
		
		return r
	end

end

function Objeto:Adicionar(Child)
	table.insert(self.Children,Child)
	Child.Dono = self
end

function Objeto:ABS_POS(pos)
	local pos = pos or self.Posicao
	local dono = self.Dono
	if not dono or not dono.Tamanho then return pos end
	return dono:ABS_POS() + pos
end

function Objeto:Destruir(s)
	local self = self or s
	local function clean(v)
		if type(v) == "table" and v ~= self then
			if v.Destruir then
				v:Destruir()
			else
				for _,e in pairs(v) do
					clean(e)
				end
			end
		end
		if type(v) == "table" then
			limpar_data(getfenv(1),v)
			limpar_data(getfenv(0),v)
		end
	end
	if self.Dono then
		local i = table.find(self.Dono.Children,self)
		table.remove(self.Dono.Children,i)
	end

	clean(self)
	LIMPAR()
end

return Objeto