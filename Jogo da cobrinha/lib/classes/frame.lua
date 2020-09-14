Frame = {Classe = Frame}
local Metatable = {}


function Frame:Novo()
	local frame = Objeto:Novo()
	local Old_Meta = getmetatable(frame)
	local Metatable = {
		__index = function(t,k)
			local v = Frame[k] or Old_Meta.__index[k]
			return v
		end
	}
	setmetatable(frame,Metatable)
	return frame
end

function Frame:Desenhar()
	local pos = self:ABS_POS()
	local tam = self.Tamanho
	local BPixels = self.BordaPixels

	game.setColor(self.Cor)
	love.graphics.rectangle("fill",pos.X,pos.Y,tam.X,tam.Y)
	if BPixels > 0 then
		game.setColor(self.BordaCor)
		love.graphics.setLineWidth(BPixels)
		love.graphics.rectangle("line",pos.X+BPixels/2,pos.Y+BPixels/2,tam.X-BPixels,tam.Y-BPixels)
	end
	for _,Child in pairs(self.Children) do
		Child:Desenhar()
	end
	
end

return Frame