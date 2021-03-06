local bonus = {}

    local heros = require("heros")

    bonus.x = 0
    bonus.y = 0
    bonus.image = nil
    bonus.creation = false
    bonus.type = nil

    local limitePositionBonus = 30
    local tempsApparitionBonus = 20
    local timerBonus = tempsApparitionBonus
    local distanceActivationBonus = 20
    local bonus3 = false
    local bonus2 = false
    
    function bonus.Init() 
        timerBonus = tempsApparitionBonus
        bonus.creation = false
        table.remove(heros.lstArmes, 3)
    end

    --Positionne le bonus sur une tile non solide et retourne la position en x et en y
    function bonus:Position(map)
        local index
        repeat 
            self.x = math.random(limitePositionBonus, screenw - limitePositionBonus)
            self.y = math.random(limitePositionBonus, screenh - limitePositionBonus)
            local Cx1, Lx1 = map.RecupererPosition(bonus.x,bonus.y)
            index = map.Grid[Lx1][Cx1]
        until map.IsSolidPersonnage(index) == false
    end
    --Creation du bonus
    function bonus:CreerBonus(indexBonus, map)
        self:Position(map)
        self.type = indexBonus
        if self.type == 1 then
            self.image = love.graphics.newImage("images/bonus/bonus1.png") 
        elseif bonus.type == 2 then
            self.image = love.graphics.newImage("images/bonus/bonus2.png") 
        elseif bonus.type == 3 then
            self.image = love.graphics.newImage("images/bonus/bonus3.png") 
        end
    end

    function bonus:AppliquerBonus()
        if self.type == 1 then
            heros.vie = heros.vie + 25
            if heros.vie > 100 then
                heros.vie = 100
            end
        elseif self.type == 2 then
            heros.chargeurPistolet = heros.chargeurPistolet + 1
            if heros.chargeurPistolet > 5 then
                heros.chargeurPistolet = 5
            end
            if bonus2 == false then
                heros.arme = "pistolet"
                heros.indexArme = 1
                bonus2 = true
            end
        elseif self.type == 3 then
            heros.lstArmes[3]= {}
            heros.lstArmes[3].name = "uzi"
            heros.lstArmes[3].utilisation = 20
            heros.lstArmes[3].img = love.graphics.newImage("images/armes/uzi.png")
            heros.chargeurUzi = heros.chargeurUzi + 1
            if heros.chargeurUzi > 3 then
                heros.chargeurUzi = 3
            end
            if bonus3 == false then
                heros.arme = "uzi"
                heros.indexArme = 3
                bonus3 = true
            end
        end
    end

    function bonus.Update(map, dt)
        if timerBonus > 0 then
            timerBonus = timerBonus - dt
        elseif bonus.creation == false then
            timerBonus = 0
            bonus.creation = true
            bonus:CreerBonus(math.random(1,3), map)
        end
        --Gestion de la collision ente le heros et le bonus
        if bonus.creation == true then
            local distance = math.sqrt((heros.x - bonus.x)*(heros.x - bonus.x) + 
            (heros.y - bonus.y)*(heros.y - bonus.y))
            if distance < distanceActivationBonus then
                bonus.creation = false
                timerBonus = tempsApparitionBonus
                bonus:AppliquerBonus()
            end
        end
    end

    function bonus.Draw()
        if bonus.creation == true then
            love.graphics.draw(bonus.image, bonus.x, bonus.y, 0, 1, 1, bonus.image:getWidth()/2, bonus.image:getHeight()/2)
        end
    end

return bonus