local environnement = {}
    local images = require("images")
    local anim = require("animation")
   
    --Liste qui contient les elements de l'environnement
    environnement.lst = {}
    --Chargement des images
    local lstImgCorbeau = images.ChargerImages(25, "corbeau")
    local img = lstImgCorbeau[1]
    --Compteur d'apparition du corbeau
    environnement.compteur = math.random(25,40)
    environnement.HeliOut = false
    local limitePosition = 70
    local nMaxHelicoptere = 1
    local nHelicoptere = 0

    function environnement.CreerCorbeau()
        local corbeau = {}
        corbeau.type = "corbeau"
        corbeau.x = 0
        corbeau.y = 0
        corbeau.direction = 0
        corbeau.scaleX = 1
        corbeau.scaleY = 1
        corbeau.vitesse = 150
        corbeau.currentImage = lstImgCorbeau[1]
        corbeau.frame = 1
        corbeau.zone = 0
        corbeau.compteur = 10
        environnement.InitialiserCorbeau(corbeau)
        table.insert(environnement.lst, corbeau)
        if corbeau.zone == 1 then
            corbeau.distanceMini = 150
        else
            corbeau.distanceMini = 50
        end
    end

    function environnement.CreerHelicoptere()
        local heli = {}
        heli.type = "helicoptere"
        heli.x = screenw - 100
        heli.y = -200
        heli.vitesse = 60
        heli.currentImage = love.graphics.newImage("images/helicoptere/1.png")
        heli.frame = 1
        heli.decollage = false
        nHelicoptere = nHelicoptere + 1
        table.insert(environnement.lst, heli)
    end

    function environnement.InitialiserCorbeau(corbeau)
        local zone= math.random(1,4)
        if zone == 1 then
            local y = math.floor(math.random(limitePosition, screenh - limitePosition))
            corbeau.x = - 100
            corbeau.y = y
            corbeau.direction = math.rad(0)
            corbeau.scaleX = 0.08
            corbeau.scaleY = 0.08
            corbeau.zone = zone
        elseif zone == 2 then
            local y = math.floor(math.random(limitePosition, screenh - limitePosition))
            corbeau.x = screenw + 100
            corbeau.y = y
            corbeau.direction = math.rad(0)
            corbeau.scaleX = -0.08
            corbeau.scaleY = 0.08
            corbeau.zone = zone
        elseif zone == 3 then
            local x = math.floor(math.random(limitePosition, screenw - limitePosition))
            corbeau.x = x
            corbeau.y = - 100
            corbeau.direction = math.rad(90)
            corbeau.scaleX = 0.08
            corbeau.scaleY = 0.08
            corbeau.zone = zone
        elseif zone== 4 then
            local x = math.floor(math.random(limitePosition, screenw - limitePosition))
            corbeau.x = x
            corbeau.y = screenh + 100
            corbeau.direction = math.rad(-90)
            corbeau.scaleX = 0.08
            corbeau.scaleY = 0.08
            corbeau.zone = zone
        end
    end

    function environnement.Update(heros, dt)
        environnement.compteur = environnement.compteur - dt
        if environnement.compteur <= 0 then
            environnement.CreerCorbeau()
            environnement.compteur = math.random(25,40)
        end
        for n=#environnement.lst, 1, -1  do
            local e = environnement.lst[n]
            if e.type == "corbeau" then
                if heros.GAMEOVER == false then
                    if e.zone == 1 then
                        e.x = e.x + e.vitesse*dt
                    elseif e.zone == 2 then
                        e.x = e.x - e.vitesse*dt
                    elseif e.zone == 3 then
                        e.y = e.y + e.vitesse*dt
                    elseif e.zone == 4 then
                        e.y = e.y - e.vitesse*dt
                    end
                elseif heros.GAMEOVER == true then
                    local direction = math.atan2(heros.y - e.y, heros.x - e.x)
                    local distance = math.sqrt((e.x - heros.x)*(e.x - heros.x) + (e.y - heros.y)*(e.y - heros.y))
                    e.direction = direction
                    if distance > e.distanceMini then
                        e.x = e.x + e.vitesse*dt*math.cos(direction)
                        e.y = e.y + e.vitesse*dt*math.sin(direction)
                    else
                        e.vitesse = 0
                    end
                end
                    -- Animation des corbeaux
                    e.currentImage = anim.JouerAnimationObjet(lstImgCorbeau, 20, dt, e)
            end
            if heros.WIN == true then
                -- Deplacement de l'helicoptere
                if nHelicoptere < nMaxHelicoptere then
                    environnement.CreerHelicoptere()
                end
                if e.type == "helicoptere" and e.decollage == false then
                    if e.y <= 200 then
                        e.y = e.y + e.vitesse*dt
                    else
                        e.y = 200
                    end
                elseif e.decollage == true then
                    if e.y > -300 then
                        e.y = e.y - e.vitesse*dt
                    else
                        table.remove(environnement.lst, n)
                        environnement.HeliOut = true
                    end
                end
            end
            if e.x < -500 or e.x > screenw + 500 or e.y < -500 or e.y > screenh + 500 then
                table.remove(environnement.lst, n)
            end
        end 
    end

    function environnement.Draw(heros)
        for n=1, #environnement.lst do
            local e = environnement.lst[n]
            if e.type == "corbeau" then
                if heros.GAMEOVER == false or heros.WIN == true then
                    love.graphics.draw(e.currentImage, e.x, e.y, e.direction, e.scaleX, e.scaleY)
                elseif heros.GAMEOVER == true then
                    if e.zone == 2 then
                        love.graphics.draw(e.currentImage, e.x + 50, e.y -50, e.direction, 0.08, -0.08)
                    else
                        love.graphics.draw(e.currentImage, e.x +50, e.y -50, e.direction, e.scaleX, e.scaleY)
                    end
                end
            end
        end
        if heros.WIN == true then
            for n=1, #environnement.lst do
                local e = environnement.lst[n]
                if e.type == "helicoptere" then
                    love.graphics.draw(e.currentImage, e.x, e.y, math.rad(180), 0.2, 0.2, 
                    e.currentImage:getWidth()/2, e.currentImage:getHeight()/2)
                end
            end
        end
    end

return environnement