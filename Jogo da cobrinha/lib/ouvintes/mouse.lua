local Clicando = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
}
local function Clicou(x,y,botao,_,presses)
	local ms_pos = Vetor:Novo(x,y)

	local Objetos = {}
	for _,Tela in pairs(game.Telas) do
		local Descendentes = PegarDescendentes(Tela)
		if #Descendentes > 0 then
			for _,v in pairs(Descendentes) do
				table.insert(Objetos,v)
			end
		end
	end

	for _,Objeto in pairs(Objetos) do
		local Pos = Objeto.Posicao:ABS()
		local Final = Pos + Objeto.Tamanho:ABS()
		
		if ms_pos > Pos and ms_pos < Final then
			Objeto.MouseClick:Ativar(ms_pos,botao)
			Clicando[botao] = Objeto
			if presses > 2 then
				Objeto.DoubleClick:Ativar(ms_pos,botao)
			end
			break
		end
	end
end
function SoltouClick(x,y,botao,_,presses)
	local clicando = Clicando[botao]
	if clicando then
		clicando.MouseSoltou:Ativar(ms_pos,botao)
	end
end

game.mousepressed:Conectar(Clicou)
game.mousereleased:Conectar(SoltouClick)