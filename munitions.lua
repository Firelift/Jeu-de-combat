local munitions = {}

    function munitions.CreerMunition(pArme)
        local munition = {}
        if pArme == "pistolet" then
            munition.image = love.graphics.newImage("images/munitions/ballePistolet.png")
        elseif pArme == "uzi" then
            munition.image = love.graphics.newImage("images/munitions/balleUzi.png")
        end
        munition.x = nil
        munition.y = nil
        munition.degats = 2
        munition.vitesse = 700
        munition.orientation = nil
        return munition
    end

    function munitions.Draw(heros)
        if heros.arme == "pistolet" then
            for n = 1,#heros.lstmunitionsPistolet do
                local munition = heros.lstmunitionsPistolet[n]
                love.graphics.draw(munition.image, munition.x, munition.y, munition.orientation + math.rad(90), 1, 1, 
                munition.image:getWidth()/2, 0)
            end
        elseif heros.arme == "uzi" then
            for n = 1,#heros.lstmunitionsUzi do
                local munition = heros.lstmunitionsUzi[n]
                love.graphics.draw(munition.image, munition.x, munition.y, munition.orientation + math.rad(90), 1, 1, 
                munition.image:getWidth()/2, 0)
            end
        end
    end
return munitions