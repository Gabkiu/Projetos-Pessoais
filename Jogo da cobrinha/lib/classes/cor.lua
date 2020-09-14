Cor = {}
local Metatable = {__index = Cor}

function Cor:Novo(R,G,B)
	local Cor = {R = R, G = G,B = B}
	setmetatable(Cor,Metatable)
	return Cor
end

function Cor:Unpack()
	return self.R/255,self.G/255,self.B/255
end

function Metatable:__add(Cor)
	return self:Novo(self.R + Cor.R,self.G + Cor.G, self.B + Cor.B)
end

function Metatable:__sub(Cor)
	return self:Novo(self.R - Cor.R,self.G - Cor.G, self.B - Cor.B)
end
