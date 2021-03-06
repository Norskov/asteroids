local class = require 'middleclass'

local AIController = class('AIController')

function AIController:initialize(p)
	self.p = p
	self.astroids = p.gs.objmgr.astroids
   self.players = p.gs.objmgr.players 
end

function AIController:getType()
   return 'Controller'
end

function AIController:update() 
   self.shooting = self:isShooting()
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
end

function AIController:isShooting()
   return true
end

function AIController:getMoveDir()
   local apos = self:getMostDangerousPos()
   local dir = {}
   if apos.dist < 200 then
      dir.x = (apos.x - self.p.trans.x) * -1
      dir.y = (apos.y - self.p.trans.y) * -1
   else
      dir.x = (apos.x - self.p.trans.x)
      dir.y = (apos.y - self.p.trans.y)
   end
   
   --move
   if dir.x ~= 0 or dir.y ~= 0 then
      local unit = math.sqrt((dir.x^2)+(dir.y^2))
      dir.x = dir.x/unit
      dir.y = dir.y/unit
   end
   return dir  
end

function AIController:getShootDir()
   local apos = self:getMostDangerousPos()
   local dir = {}
   dir.x = apos.x - self.p.trans.x
   dir.y = apos.y - self.p.trans.y
   --move
   return dir  
end

function AIController:getMostDangerousPos()
   local w,h = love.graphics.getDimensions()
   local pos = {}
   pos.x = 0
   pos.y = 0
   pos.dis = 0
   
   local cb = 3000
   
   for i = 1, #self.astroids,1 do
      local ox = pos.x
      local oy = pos.y
      local x1 = self.astroids[i].trans.x - w
      local x2 = self.astroids[i].trans.x
      local x3 = self.astroids[i].trans.x + w
      local y1 = self.astroids[i].trans.y - h
      local y2 = self.astroids[i].trans.y
      local y3 = self.astroids[i].trans.y + h
      if math.abs(self.p.trans.x - x2) < math.abs(self.p.trans.x - x3) then
         if math.abs(self.p.trans.x - x1) < math.abs(self.p.trans.x - x2) then
            pos.x = x1
         else
            pos.x = x2
         end
      else
         pos.x = x3
      end
      
      if math.abs(self.p.trans.y - y2) < math.abs(self.p.trans.y - y3) then
         if math.abs(self.p.trans.y - y1) < math.abs(self.p.trans.y - y2) then
            pos.y = y1
         else
            pos.y = y2
         end
      else
         pos.y = y3
      end
      
      local dist = math.sqrt(math.pow(self.p.trans.x - pos.x,2)+math.pow(self.p.trans.y - pos.y,2))
      
      if cb > dist then
         cb = dist
         pos.dist = dist
      else
         pos.x = ox
         pos.y = oy
      end
   end
   
   return pos
end

return AIController
