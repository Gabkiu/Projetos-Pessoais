Player = {}
local Metatable = {__index = Player}

Player.Eixos = {
	a= "X",
	d = "X",
	w = "Y",
	s = "Y"
}

Player.Direcoes = {
	X = {
		a = -1,
		d = 1,
	},
	Y = {
		s = 1,
		w = -1,
	}
}

function Player:Novo()
	local Player = {
		Vida = 10,
		Stamina = 10,

		Corpo = Frame:Novo(),
		Velocidade = 3,
		Barra_Ataque = Frame:Novo(),
		BA_Preenchimento = Frame:Novo(),
		Movel = true
	}
	Player.Direcao_Velocidade = Vetor:Novo(0,-Player.Velocidade)
	setmetatable(Player,Metatable)
	local Tela = Tela:Novo()
	local Barra_Ataque = Player.Barra_Ataque
	local BA_Preenchimento = Player.BA_Preenchimento

	Player.Tela = Tela

	Barra_Ataque:Adicionar(BA_Preenchimento)
	Barra_Ataque.Tamanho = Vetor:Novo(150,15)
	Barra_Ataque.Posicao = Vetor:Novo(20,20)
	Barra_Ataque.BordaPixels = 0 
	Barra_Ataque.Cor = Cor:Novo(38,38,38)

	BA_Preenchimento.Tamanho = Vetor:Novo(150,15)
	BA_Preenchimento.Posicao = Vetor:Novo(0,0)
	BA_Preenchimento.BordaPixels = 0

	Barra_Ataque.BordaCor = Cor:Novo(100,100,10)

	Player.Corpo.Colide = true
	Player.Corpo.Posicao = Vetor:Novo(500,500)



	Tela:Adicionar(Barra_Ataque)
	Tela:Adicionar(Player.Corpo)

	return Player
end

function Player:Mover(tecla)
	local Player = self
	if not Player.Movel then return end
	local Eixo = Player.Eixos[tecla]
	if not Eixo then return end
	local Velocidade = Player.Direcoes[Eixo][tecla]
	if not Velocidade then return end
	if Player.Corpo.Velocidade[Eixo] >= Player.Velocidade then return end


	Velocidade = Velocidade * Player.Velocidade
	
	local Vel = Vetor:Novo(0,0)
	Vel[Eixo] = Velocidade
	Player.Direcao_Velocidade = Vel
	
	Player.Corpo:AplicarForca(Vel)
end

function Player:Atacar()
	local Player = self
	if Player.Stamina == 10 and not Player.Atacando then
		Player.Stamina = 0
		Player.Movel = false
		local Tween = Tween:Novo(Player.BA_Preenchimento.Tamanho,"X",0,20,0.05)
		local Pos_Final = Player.Corpo.Posicao + Player.Direcao_Velocidade*100
		
		local T2 = Tween:Novo(Player.Corpo.Posicao,{"X","Y"},{Pos_Final.X,Pos_Final.Y},20,0.2,0)
		local T = Thread:Novo(function()
			Aguardar(0)
			T2:Resumir()
		end)
		local frames = {}
		T2.Step:Conectar(function(Incremento)
			local f = Frame:Novo()
			f.Tamanho = Player.Corpo.Tamanho
			f.Posicao = Player.Corpo.Posicao
			Player.Tela:Adicionar(f)
			table.insert(frames,f)
		end)
		T2.Terminou:Conectar(function()
			print("TWEEN TERMINOU")
			for _,f in pairs(frames) do
				f:Destruir()
			end
		end)
		T:Resumir()
		
		Player.Movel = true
		
	end
end