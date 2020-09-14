Vetor = {}
local Metatable = {}

function Vetor:Novo(X,Y)
	local Vetor = {X = X or 0,Y = Y or 0}
	setmetatable(Vetor,Metatable)
	return Vetor
end
function Vetor:ABS_Distancia(Vetor)
	return (self - Vetor).Magnitude
end
function Vetor:Distancia(Vetor)
	return self - Vetor
end
function Vetor:Escalar(Vetor)
	return self:Novo(self.X * Vetor.X,self.Y * Vetor.Y)
end
function Vetor:ABS()
	local x,y = love.graphics.getWidth(),love.graphics.getHeight()
	return self:Novo(self.X * x,self.Y * y)
end

function Vetor:Modulo()
	return self:Novo(math.abs(self.X),math.abs(self.Y))
end
function Vetor:Inverso()
	return self * -1
end

function Metatable:__index(Key)
	if Key == "Magnitude" then 
		return math.sqrt(self.X^2+self.Y^2)
	end
	return rawget(Vetor,Key)
end

function Metatable:__add(Vetor)
	return self:Novo(self.X + Vetor.X,self.Y + Vetor.Y)
end

function Metatable:__sub(Vetor)
	return self:Novo(self.X - Vetor.X,self.Y - Vetor.Y)
end

function Metatable:__tostring()
	return "X: " .. self.X .. " Y: " .. self.Y
end
function Metatable:__lt(Vetor)
	return Vetor.X > self.X and Vetor.Y > self.Y
end
function Metatable:__eq(Vetor)

	return self.X == Vetor.X and self.Y == Vetor.Y
end

function Metatable:__mul(Fator)
	if type(Fator) == "number" then
		return Vetor:Novo(self.X * Fator,self.Y * Fator)
	end
	return Vetor:Novo(self.X * Fator.X,self.Y * Fator.Y)
end
function Metatable:__div(Fator)
	if type(Fator) == "number" then
		return Vetor:Novo(self.X / Fator,self.Y / Fator)
	end
	return Vetor:Novo(self.X / Fator.X,self.Y / Fator.Y)
end

return Vetor