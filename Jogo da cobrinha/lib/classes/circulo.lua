Frame = {}
local Metatable = {__index = Frame}

function Frame:Novo()
	local Frame = Objeto:Novo()
	setmetatable(Frame,Metatable)
	return Frame
end

function Frame:Desenhar()
	local pos = self.Posicao
	local tam = self.Tamanho
	local BPixels = self.BordaPixels
	love.graphics.rectangle("fill",pos.X,pos.Y,tam.X,tam.Y)
	if BPixels > 0 then
		love.graphics.rectangle("line",pos.X-BPixels/2,pos.Y-BPixels/2)
	end
	for _,Child in pairs(self.Children) do
		Child:Desenhar()
	end
end

return Frame