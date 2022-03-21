local curseur = {}


    local mouseX, mouseY = love.mouse.getPosition()
    curseur.direction = 0
    curseur.x = mouseX
    curseur.y = mouseY
    curseur.distanceMax = 200
    curseur.image = love.graphics.newImage("images/souris/cible.png")

    --Gestion du curseur
    function curseur.GestionDeplacement(heros)
        mouseX, mouseY = love.mouse.getPosition()
        curseur.direction = math.atan2(mouseY - heros.y, mouseX - heros.x)
        if curseur.CalculDistancePersoCurseur(heros) > curseur.distanceMax then
            curseur.x = heros.x + curseur.distanceMax*math.cos(curseur.direction)
            curseur.y = heros.y + curseur.distanceMax*math.sin(curseur.direction)
        else
            curseur.x = mouseX
            curseur.y = mouseY
        end
    end

    --Calcul la distance entre le perso et la souris
    function curseur.CalculDistancePersoCurseur(heros)
        local Distance = nil
        Distance = math.floor(math.sqrt(((mouseX - heros.x)*(mouseX - heros.x)) + ((mouseY - heros.y)*(mouseY - heros.y))))
        return Distance
    end

return curseur