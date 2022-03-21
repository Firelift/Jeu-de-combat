local heros = {}

    local images = require("images")
    local munitions = require("munitions")
    local curseur = require("curseur")
    local distanceMinCollisionZombies = 30
    local distanceMinCollisionMap = 20
    local Collision = false
    local musiques = require("musiques")
    local map = require("map")

    local oldPosHerosX
    local oldPosHerosY
    local frequenceTirUzi = 0.2
    local compteurTirUzi = frequenceTirUzi
    heros.GAMEOVER = false
    heros.WIN = false
    heros.EnSecurite = false
    heros.distanceMinHeli = 75
    heros.distanceCouteau = 50
    heros.lstImg = {}
    heros.limiteTerrain = 25
    heros.lstmunitionsPistolet = {}
    heros.lstmunitionsUzi = {}
    -- Création des armes
    heros.lstArmes = {}
    heros.lstArmes[1] = {}
    heros.lstArmes[1].name = "pistolet"
    heros.lstArmes[1].utilisation = 10
    heros.lstArmes[1].img = love.graphics.newImage("images/armes/pistolet.png")
    heros.lstArmes[2] = {}
    heros.lstArmes[2].name = "couteau"
    heros.lstArmes[2].degats = 1
    heros.lstArmes[2].img = love.graphics.newImage("images/armes/couteau.png")
    
    --Chargement des images du heros
    function heros.Load()
        heros.lstImg["arret"] = images.ChargerImages(20, "heros", "arret")
        heros.lstImg["marche"] = images.ChargerImages(20, "heros", "marche")
        heros.lstImg["tire"] = images.ChargerImages(3, "heros", "tire")
        heros.lstImg["charge"] = images.ChargerImages(15, "heros", "charge")
        heros.lstImg["arret2"] = images.ChargerImages(20, "heros", "arret2")
        heros.lstImg["marche2"] = images.ChargerImages(20, "heros", "marche2")
        heros.lstImg["attaque2"] = images.ChargerImages(15, "heros", "attaque2")
        heros.lstImg["mort"] = images.ChargerImages(1, "heros", "mort")
    end
    --Creation du heros
    function heros.CreerHeros()
        heros.x = screenw/2
        heros.y = screenh/2
        heros.vie = 100
        heros.vitesse = 200
        heros.frame = 1
        heros.currentImage = heros.lstImg["arret"][1]
        heros.indexArme = 1
        heros.arme = "pistolet"
        heros.MunitionsPistolet = heros.lstArmes[1].utilisation
        heros.chargeurPistolet = 1
        heros.MunitionsUzi = 0
        heros.chargeurUzi = 0
        heros.etat = "arret"
        heros.statut = "horsdanger"
        heros.posMapX = 1
        heros.posMapY = 1
        return heros
    end
    --Gestion du déplacement du heros
    function heros.DeplacementHeros(curseur, dt)
        mouseX, mouseY = love.mouse.getPosition()
        if heros.etat ~= "tire" and love.keyboard.isDown("z") then
            if math.floor(heros.x) ~= mouseX and math.floor(heros.y) ~= mouseY and Collision == false then
                heros.vitesse = 200
                heros.x = heros.x + heros.vitesse*dt*math.cos(curseur.direction)
                heros.y = heros.y + heros.vitesse*dt*math.sin(curseur.direction)
            end
        end 
        -- Gestion des limites du terrain
        if heros.x < heros.limiteTerrain then
            heros.x = heros.limiteTerrain
        end
        if heros.x > screenw - heros.limiteTerrain then
            heros.x = screenw - heros.limiteTerrain  
        end
        if heros.y < heros.limiteTerrain then
            heros.y = heros.limiteTerrain
        end
        if heros.y > screenh - heros.limiteTerrain then
            heros.y = screenh - heros.limiteTerrain
        end
    end
    --Calcul distance entre le heros et les zombies
    function heros.DistanceHerosZombies(pZomb)
        local distance = math.sqrt((heros.x - pZomb.x)*(heros.x - pZomb.x) + 
        (heros.y - pZomb.y)*(heros.y - pZomb.y))
        return distance
    end
    --Gestion des collisions du heros
    function heros.GestionCollision(pZombie, pEnv)
        if heros.WIN == false then
            --Gestion des collision avec les zombies
            for n = 1, #pZombie.lst do
                local zomb = pZombie.lst[n]
                if zomb.etat ~= "mort" then
                    local distance = heros.DistanceHerosZombies(zomb)
                    local angle = math.atan2(heros.y - zomb.y, heros.x - zomb.x)
                    if distance < distanceMinCollisionZombies then
                        Collision = true
                        heros.x = zomb.x + 1.1*distanceMinCollisionZombies*math.cos(angle)
                        heros.y = zomb.y + 1.1*distanceMinCollisionZombies*math.sin(angle)
                    else
                        Collision = false
                    end
                end
            end
        elseif heros.WIN == true then
            --Gestion de la collision avec l'helico
            for n=1,#pEnv.lst do
                local e = pEnv.lst[n]
                if e.type == "helicoptere" then
                    local distance = math.sqrt((heros.x - e.x)*(heros.x - e.x) + 
                    (heros.y - e.y)*(heros.y - e.y))
                    if distance < heros.distanceMinHeli then
                        heros.EnSecurite = true
                        e.decollage = true
                    end
                end
            end
        end  
        --Gestion de la collision du hero avec la map
        local x1 = heros.x + distanceMinCollisionMap*math.cos(curseur.direction)
        local y1 = heros.y + distanceMinCollisionMap*math.sin(curseur.direction)
        local x2 = heros.x + distanceMinCollisionMap*math.cos(curseur.direction - math.rad(40))
        local y2 = heros.y + distanceMinCollisionMap*math.sin(curseur.direction - math.rad(40))
        local x3 = heros.x + distanceMinCollisionMap*math.cos(curseur.direction + math.rad(40))
        local y3 = heros.y + distanceMinCollisionMap*math.sin(curseur.direction + math.rad(40))
        local Cx1, Lx1 = map.RecupererPosition(x1,y1)
        local Cx2, Lx2 = map.RecupererPosition(x2,y2)
        local Cx3, Lx3 = map.RecupererPosition(x3,y3)
        local index1 = map.Grid[Lx1][Cx1]
        local index2 = map.Grid[Lx2][Cx2]
        local index3 = map.Grid[Lx3][Cx3]
        if map.IsSolidPersonnage(index1) or map.IsSolidPersonnage(index2) or map.IsSolidPersonnage(index3) then
            heros.x = oldPosHerosX
            heros.y = oldPosHerosY  
        else
            oldPosHerosX = heros.x
            oldPosHerosY = heros.y
        end
        -- Gestion de la collision des munitions avec la map
        if heros.arme == "pistolet" then
            for n=#heros.lstmunitionsPistolet, 1, -1 do
                local mun = heros.lstmunitionsPistolet[n]
                local colonneMun, ligneMun = map.RecupererPosition(mun.x, mun.y)
                local index = map.Grid[ligneMun][colonneMun]
                if map.IsSolidMunition(index) then
                    table.remove(heros.lstmunitionsPistolet, n)
                end
            end
        elseif heros.arme == "uzi" then
            for n=#heros.lstmunitionsUzi, 1, -1 do
                local mun = heros.lstmunitionsUzi[n]
                local colonneMun, ligneMun = map.RecupererPosition(mun.x, mun.y)
                local index = map.Grid[ligneMun][colonneMun]
                if map.IsSolidMunition(index) then
                    table.remove(heros.lstmunitionsUzi, n)
                end
            end
        end
    end
    --Gestion etat/statut heros
    function heros.GestionEtat(pZombie)
        if heros.arme == "pistolet" then
            if love.keyboard.isDown("r") and heros.MunitionsPistolet == 0 and heros.chargeurPistolet > 0 then
                heros.chargeurPistolet = heros.chargeurPistolet - 1
                heros.MunitionsPistolet = heros.lstArmes[heros.indexArme].utilisation
                heros.etat = "charge"
                heros.frame = 1.01
            elseif love.keyboard.isDown("z") and heros.frame == 1 then
                heros.etat = "marche"
            elseif heros.frame == 1 then
                heros.etat = "arret"
            end
        elseif heros.arme == "couteau" then
            if love.keyboard.isDown("z") and heros.frame == 1 then
                heros.etat = "marche2"
            elseif heros.frame == 1 then
                heros.etat = "arret2"
            end
        elseif heros.arme == "uzi" then
            if love.keyboard.isDown("r") and heros.MunitionsUzi == 0 and heros.chargeurUzi > 0 then
                heros.chargeurUzi = heros.chargeurUzi - 1
                heros.MunitionsUzi = heros.lstArmes[heros.indexArme].utilisation
                heros.etat = "charge"
                heros.frame = 1.01
            elseif love.keyboard.isDown("z") and heros.frame == 1 then
                heros.etat = "marche"
            elseif heros.frame == 1 then
                heros.etat = "arret"
            end
        end
        local compteur = 0
        for n = 1, #pZombie.lst do
            local zomb = pZombie.lst[n]
            local distance = heros.DistanceHerosZombies(zomb)
            if distance <= pZombie.distanceDetection then
                heros.statut = "endanger"
                compteur = compteur + 1
            end
        end
        if compteur == 0 then
            heros.statut = "horsdanger"
        end
    end
    --Gestion des armes (pistolet et couteau)
    function heros.mousepressed(x, y, button)
        if heros.etat ~= "tire" and heros.etat ~= "attaque2" then
            if heros.arme == "pistolet" then
                if button == 1 and heros.MunitionsPistolet > 0 then
                    if heros.WIN == false then
                        love.audio.stop(musiques.lstSons[4])
                        love.audio.play(musiques.lstSons[4])
                    end
                    heros.CreerMunition(heros.arme)
                    heros.frame = 1.01
                    heros.MunitionsPistolet = heros.MunitionsPistolet - 1
                    heros.etat = "tire"
                end
            elseif heros.arme == "couteau" then
                if button == 1 then
                    heros.frame = 1.01
                    heros.etat = "attaque2"
                end
            end
        end
    end
    --Gestion du changement d'arme
    function heros.keypressed(key)
        if key == "a" then
            if heros.indexArme < #heros.lstArmes then
                heros.indexArme = heros.indexArme +  1
                heros.arme = heros.lstArmes[heros.indexArme].name
            else
                heros.indexArme = 1
                heros.arme = heros.lstArmes[heros.indexArme].name
            end
            if heros.arme == "pistolet" then
                heros.etat = "arret"
            elseif heros.arme == "couteau" then
                heros.etat = "arret2"
            elseif heros.arme == "uzi" then
                heros.etat = "arret"
            end
        end
    end
    --Mise à jour du heros
    function heros.Update(lstZombies, dt)
        if heros.GAMEOVER == false then
            for n = 1,#lstZombies do
                local zomb = lstZombies[n]
                if zomb.etat == "attaque" and zomb.frame == 1 then
                    if zomb.attaque == false then
                        zomb.attaque = true
                    elseif heros.vie > 0 then
                        heros.vie = heros.vie - zomb.degats
                    end
                end
            end
            if heros.vie <= 0 then
                heros.GAMEOVER = true
            end
        end
        --Gestion de l'uzi
        if love.mouse.isDown(1) and heros.arme == "uzi" and heros.MunitionsUzi > 0 then
            if compteurTirUzi == frequenceTirUzi then
                heros.CreerMunition(heros.arme)
                heros.frame = 1.01
                heros.MunitionsUzi = heros.MunitionsUzi - 1
                heros.etat = "tire"
                if heros.WIN == false then
                    love.audio.stop(musiques.lstSons[4])
                    love.audio.play(musiques.lstSons[4])
                end
                compteurTirUzi = compteurTirUzi - dt
            elseif compteurTirUzi > 0 then
                compteurTirUzi = compteurTirUzi - dt
            elseif compteurTirUzi <= 0 then
                compteurTirUzi = frequenceTirUzi
            end
        else
            compteurTirUzi = frequenceTirUzi
        end
    end
    --Affichage du heros et de ses caractéristiques
    function heros.Draw()
         -- affichage du heros
        if heros.EnSecurite == false then
            if heros.etat == "attaque2" then
                love.graphics.draw(heros.currentImage, heros.x, heros.y, curseur.direction , 0.3, 0.3, 
                heros.currentImage:getWidth()/2 -22, heros.currentImage:getHeight()/2 - 35)
            else
                love.graphics.draw(heros.currentImage, heros.x, heros.y, curseur.direction , 0.3, 0.3, 
                heros.currentImage:getWidth()/2, heros.currentImage:getHeight()/2)
            end
        end
    end
    --Gestion des Munitions
    function heros.CreerMunition(pArme)
        if heros.EnSecurite == false then
            local mun = munitions.CreerMunition(pArme)
            mun.orientation = curseur.direction 
            mun.x = heros.x + 45*math.cos(mun.orientation + math.rad(22))
            mun.y = heros.y + 45*math.sin(mun.orientation + math.rad(22))
            if pArme == "pistolet" then
                table.insert(heros.lstmunitionsPistolet,  mun)
            elseif pArme == "uzi" then
                table.insert(heros.lstmunitionsUzi, mun)
            end
        end
    end
    --Suppression des munitions
    function heros:SupprimerMunitions(pArme)
        if heros.EnSecurite == false then
            if pArme == "pistolet" then
                for n = #heros.lstmunitionsPistolet, 1,-1 do
                    local munition = heros.lstmunitionsPistolet[n]
                    if munition.x < 0  or munition.x > screenw  or munition.y < 0 or munition.y > screenh  then
                        table.remove(heros.lstmunitionsPistolet, n)
                    end
                end
            elseif pArme == "uzi" then
                for n = #heros.lstmunitionsUzi, 1,-1 do
                    local munition = heros.lstmunitionsUzi[n]
                    if munition.x < 0  or munition.x > screenw  or munition.y < 0 or munition.y > screenh  then
                        table.remove(heros.lstmunitionsUzi, n)
                    end
                end
            end
        end
    end
    function heros:DeplacerMunitions(pArme, dt)
        if heros.EnSecurite == false then
            if pArme == "pistolet" then
                for n = 1,#heros.lstmunitionsPistolet do
                    local munition = heros.lstmunitionsPistolet[n]
                    munition.x = munition.x + munition.vitesse*dt*math.cos(munition.orientation)
                    munition.y = munition.y + munition.vitesse*dt*math.sin(munition.orientation)
                end
            elseif pArme == "uzi" then
                for n = 1,#heros.lstmunitionsUzi do
                    local munition = heros.lstmunitionsUzi[n]
                    munition.x = munition.x + munition.vitesse*dt*math.cos(munition.orientation)
                    munition.y = munition.y + munition.vitesse*dt*math.sin(munition.orientation)
                end
            end
           
        end
    end

return heros