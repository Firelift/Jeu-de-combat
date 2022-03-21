local zombie = {}
    local images = require("images")
    local timer = require("timer")
    local animation = require("animation")
    local curseur = require("curseur")
    local map = require("map")

    --liste des zombies vivants
    zombie.lst = {}
    zombie.lstImg = {}
    --liste des zombies qui attaquent le heros
    zombie.lstAttaque = {}
    --liste des zombies morts
    zombie.lstMort = {}
    zombie.distanceDetection = 200

    local zone
    local vitesseDepart = 75
    local limitePosition = 30
    local limitePositionCreation = 100
    local distanceMiniZombies = 60
    local distanceAttaque = 50
    local distanceDegatCouteau = 35
    local distanceMinCollisionMap = 20
    local distanceImpactBalles = 30
    local positionsYDepartZone1 = {}
    local positionsYDepartZone2 = {}
    local positionsXDepartZone3 = {}
    local positionsXDepartZone4 = {}
    local nZombiesCree = 0
    local nZombiesmaxZone12 = 7
    local nZombiesmaxZone34 = 7
    local boucle = 0
    local iterationBoucle = 0
    -- Gestion de l'apparition des zombies
    local tempsApparitionZombies = 10
    local timerZ = tempsApparitionZombies
   

    function zombie.Init()
        zombie.lst = {}
        zombie.lstAttaque = {}
        zombie.lstMort = {}
        positionsYDepartZone1 = {}
        positionsYDepartZone2 = {}
        positionsXDepartZone3 = {}
        positionsXDepartZone4 = {}
        timerZ = tempsApparitionZombies
    end
    -- Chargement des images des zombies
    function zombie.Load()
        zombie.lstImg["arret"] = images.ChargerImages(16, "zombie", "arret")
        zombie.lstImg["marche"] = images.ChargerImages(17, "zombie", "marche")
        zombie.lstImg["attaque"] = images.ChargerImages(9, "zombie", "attaque")
        zombie.lstImg["mort"] = images.ChargerImages(1, "zombie", "mort")
    end
    -- Création de N zombies
    function zombie.CreerZombie(pN)  
        nZombiesCree = pN  
        for n = 1, pN do
            local zomb = {}
            table.insert(zombie.lst, zomb)
            zomb.x = 0
            zomb.y = 0
            zomb.oldPosZombX = zomb.x
            zomb.oldPosZombY = zomb.y
            zomb.vie = 2
            zomb.degats = 25
            zomb.zone = 0
            zombie.InitialiserPosition(#zombie.lst)  
            zomb.etat = "marche"
            zomb.statut = "creation"
            zomb.frame = math.random(1,#zombie.lstImg["arret"])
            zomb.currentImage = zombie.lstImg["arret"][1]
            zomb.direction = zombie.InitialiserDirectionZombie()
            zomb.setDirection = 0
            zomb.vitesse = vitesseDepart
            zomb.vitesseMax = 125
            zomb.enCollision = false
            zomb.blesser = false
            zomb.currentImageBlessure = nil
            zomb.attaque = false
            zomb.distanceAttaque = false
        end
    end
    -- Initialise la position des zombies
    function zombie.InitialiserPosition(pIndexZombie)
        if nZombiesCree <= 2*nZombiesmaxZone12 + 2*nZombiesmaxZone34 then
            while #positionsYDepartZone1 + #positionsYDepartZone2 + #positionsXDepartZone3 + #positionsXDepartZone4 < pIndexZombie do
                zone = math.random(1,4)
                local positionTrouver = false    
                local positionZombieY = math.floor(math.random(limitePosition + distanceMiniZombies, screenh - limitePosition - distanceMiniZombies))  
                local positionZombieX = math.floor(math.random(limitePosition + distanceMiniZombies, screenw - limitePosition - distanceMiniZombies))  
                local y = positionZombieY
                local x = positionZombieX          
                if zone == 1 and #positionsYDepartZone1 >= 1 and #positionsYDepartZone1 < nZombiesmaxZone12 then 
                    local intervalle = 1
                    while positionTrouver == false do
                        local n = 0
                        if y < limitePosition + distanceMiniZombies then
                            y = limitePosition + distanceMiniZombies
                            intervalle = 1
                        elseif y > screenh - limitePosition - distanceMiniZombies then
                            y = screenh - limitePosition - distanceMiniZombies
                            intervalle = -1
                        end
                        y = y + intervalle
                        for i=1,#positionsYDepartZone1  do
                            local pos = positionsYDepartZone1[i]
                            local distancePos = math.abs(pos - y)
                            if distancePos > distanceMiniZombies then
                                n = n + 1
                            end
                            if n == #positionsYDepartZone1 then
                                zombie.lst[pIndexZombie].x = - distanceMiniZombies
                                zombie.lst[pIndexZombie].y = y
                                zombie.lst[pIndexZombie].zone = 1
                                table.insert(positionsYDepartZone1, y)
                                positionTrouver = true
                            end
                        end
                    end  
                elseif zone == 1 and  #positionsYDepartZone1 == 0 then
                    zombie.lst[pIndexZombie].x = - distanceMiniZombies
                    zombie.lst[pIndexZombie].y = positionZombieY
                    zombie.lst[pIndexZombie].zone = 1
                    table.insert(positionsYDepartZone1, y)
                elseif zone == 1 and #positionsYDepartZone1 == nZombiesmaxZone12 then
                    zone = 2
                end
                if zone == 2 and #positionsYDepartZone2 >= 1 and #positionsYDepartZone2 < nZombiesmaxZone12 then
                    local intervalle = 1
                    while positionTrouver == false do
                        local n = 0
                        if y < limitePosition + distanceMiniZombies then
                            y = limitePosition + distanceMiniZombies
                            intervalle = 1
                        elseif y > screenh - limitePosition - distanceMiniZombies then
                            y = screenh - limitePosition - distanceMiniZombies
                            intervalle = -1
                        end
                        y = y + intervalle
                        for i=1,#positionsYDepartZone2  do
                            local pos = positionsYDepartZone2[i]
                            local distancePos = math.abs(pos - y)
                            if distancePos > distanceMiniZombies then
                                n = n + 1
                            end
                            if n == #positionsYDepartZone2 then
                                zombie.lst[pIndexZombie].x = screenw + distanceMiniZombies
                                zombie.lst[pIndexZombie].y = y
                                zombie.lst[pIndexZombie].zone = 2
                                table.insert(positionsYDepartZone2, y)
                                positionTrouver = true
                            end
                        end
                    end  
                elseif  zone == 2 and  #positionsYDepartZone2 == 0 then
                    zombie.lst[pIndexZombie].x = screenw + distanceMiniZombies
                    zombie.lst[pIndexZombie].y = positionZombieY
                    zombie.lst[pIndexZombie].zone = 2
                    table.insert(positionsYDepartZone2, y)
                elseif zone == 2 and #positionsYDepartZone2 == nZombiesmaxZone12 then
                    zone = 3
                end
                if zone == 3 and #positionsXDepartZone3 >= 1 and #positionsXDepartZone3 < nZombiesmaxZone34 then
                    local intervalle = 1
                    while positionTrouver == false do
                        local n = 0
                        if x < limitePosition + distanceMiniZombies then
                            x = limitePosition + distanceMiniZombies 
                            intervalle = 1
                        elseif x > screenw - limitePosition - distanceMiniZombies then
                            x = screenw - limitePosition - distanceMiniZombies
                            intervalle = -1
                        end
                        x = x + intervalle
                        for i=1,#positionsXDepartZone3  do
                            local pos = positionsXDepartZone3[i]
                            local distancePos = math.abs(pos - x)
                            if distancePos > distanceMiniZombies then
                                n = n + 1
                            end
                            if n == #positionsXDepartZone3 then
                                zombie.lst[pIndexZombie].x = x
                                zombie.lst[pIndexZombie].y = - distanceMiniZombies
                                zombie.lst[pIndexZombie].zone = 3
                                table.insert(positionsXDepartZone3, x)
                                positionTrouver = true
                            end
                        end
                    end  
                elseif  zone == 3 and  #positionsXDepartZone3 == 0 then
                    zombie.lst[pIndexZombie].x = positionZombieX
                    zombie.lst[pIndexZombie].y = - distanceMiniZombies
                    zombie.lst[pIndexZombie].zone = 3
                    table.insert(positionsXDepartZone3, x)
                elseif zone == 3 and #positionsXDepartZone3 == nZombiesmaxZone34 then
                    zone = 4
                end
                if zone == 4 and #positionsXDepartZone4 >= 1 and #positionsXDepartZone4 < nZombiesmaxZone34 then
                    local intervalle = 1
                    while positionTrouver == false do
                        local n = 0
                        if x < limitePosition + distanceMiniZombies then
                            x = limitePosition + distanceMiniZombies 
                            intervalle = 1
                        elseif x > screenw - limitePosition - distanceMiniZombies then
                            x = screenw - limitePosition - distanceMiniZombies
                            intervalle = -1
                        end
                        x = x + intervalle
                        for i=1,#positionsXDepartZone4  do
                            local pos = positionsXDepartZone4[i]
                            local distancePos = math.abs(pos - x)
                            if distancePos > distanceMiniZombies then
                                n = n + 1
                            end
                            if n == #positionsXDepartZone4 then
                                zombie.lst[pIndexZombie].x = x
                                zombie.lst[pIndexZombie].y = screenh + distanceMiniZombies
                                zombie.lst[pIndexZombie].zone = 4
                                table.insert(positionsXDepartZone4, x)
                                positionTrouver = true
                            end
                        end
                    end  
                elseif  zone == 4 and  #positionsXDepartZone4 == 0 then
                    zombie.lst[pIndexZombie].x = positionZombieX
                    zombie.lst[pIndexZombie].y = screenh + distanceMiniZombies
                    zombie.lst[pIndexZombie].zone = 4
                    table.insert(positionsXDepartZone3, x)
                elseif zone == 4 and #positionsXDepartZone4 == nZombiesmaxZone34 then
                    zone = 1
                end
            end
        end
    end
    -- Initialise leur direction
    function zombie.InitialiserDirectionZombie()
        local direction
        if zone == 1 then
            direction = 0
        elseif zone == 2 then
            direction = math.pi
        elseif zone == 3 then
            direction = math.pi/2
        elseif zone == 4 then
            direction = (3*math.pi)/2
        end
        return direction
    end
    -- Gere l'apparition des hordes de zombies
    function zombie.Update(dt)
        timerZ = timerZ - dt
        if timerZ <= 0 and #zombie.lst <= 30 then
            positionsYDepartZone1 = {}
            positionsYDepartZone2 = {}
            positionsXDepartZone3 = {}
            positionsXDepartZone4 = {}
            zombie.CreerZombie(math.random(5,7))
            timerZ = tempsApparitionZombies
        end
    end
    -- Gestion des deplacements des zombies
    function zombie.GestionDeplacement(heros, dt)
        for n = #zombie.lst, 1, -1  do
            iterationBoucle = iterationBoucle + 1
            if iterationBoucle > #zombie.lst and boucle == 0 then
                boucle = boucle + 1
            end
            local zomb = zombie.lst[n]
            if zomb.etat ~= "mort" then
                if zomb.statut == "calme" then
                    local angleMin = 0
                    local angleMax = 380
                    if timer.DECREMENTATION == false then
                        zomb.vitesse = 0
                        zomb.etat = "arret"
                        zomb.setDirection = math.rad(math.random(angleMin,angleMax))
                        boucle = 0
                        iterationBoucle = 0
                        zomb.enCollision = false
                    end   
                    if timer.DECREMENTATION == true then
                        zomb.vitesse = vitesseDepart
                        zomb.etat = "marche" 
                        if zomb.enCollision == true then
                            zomb.etat = "arret"
                            zomb.vitesse = 0
                        end
                        if boucle == 0 then
                            zomb.direction = zomb.setDirection 
                        end  
                    end
                    if zomb.x < limitePosition then
                        zomb.x = limitePosition
                        zomb.direction = zomb.direction + math.rad(180)
                        zomb.enCollision = true
                    elseif zomb.x > screenw - limitePosition  then
                        zomb.x = screenw - limitePosition
                        zomb.direction = zomb.direction + math.rad(180)
                        zomb.enCollision = true
                    elseif zomb.y < limitePosition then
                        zomb.y = limitePosition
                        zomb.direction = zomb.direction + math.rad(180)
                        zomb.enCollision = true
                    elseif zomb.y > screenh - limitePosition then
                        zomb.y = screenh - limitePosition 
                        zomb.direction = zomb.direction + math.rad(180)   
                        zomb.enCollision = true
                    end
                elseif zomb.statut == "alerte" then
                    zomb.etat = "marche"
                    zomb.direction = math.atan2(heros.y - zomb.y, heros.x - zomb.x)
                    zomb.vitesse = zomb.vitesseMax
                    local distance = math.sqrt((zomb.x - heros.x)*(zomb.x - heros.x) + (zomb.y - heros.y)*(zomb.y - heros.y))
                    if distance < distanceAttaque + 50 then
                        if zomb.distanceAttaque == false then
                            zomb.distanceAttaque = true 
                            table.insert(zombie.lstAttaque, zomb)
                        end
                        if distance < distanceAttaque then
                            zomb.vitesse = 0
                            zomb.etat = "attaque"
                        end
                    else
                        zomb.attaque = false
                        if zomb.distanceAttaque == true then 
                            zomb.distanceAttaque = false    
                            table.remove(zombie.lstAttaque)
                        end
                    end
                end   
            end    
            zomb.x = zomb.x + zomb.vitesse*dt*math.cos(zomb.direction)
            zomb.y = zomb.y + zomb.vitesse*dt*math.sin(zomb.direction)   
        end
    end
    -- Gestion de l'état des zombies
    function zombie.GestionEtat(heros)
        for n = #zombie.lst, 1, -1  do
            local zomb = zombie.lst[n]
            if zomb.etat ~= "mort" then
                local distance = math.sqrt((zomb.x - heros.x)*(zomb.x - heros.x) + (zomb.y - heros.y)*(zomb.y - heros.y))
                if zomb.statut == "creation" then
                    if (zomb.x > limitePositionCreation and zomb.x < screenw - limitePositionCreation 
                    and zomb.y > limitePositionCreation and zomb.y < screenh - limitePositionCreation) or zomb.enCollision == true then
                        zomb.statut = "calme"             
                    end     
                else
                    if distance > zombie.distanceDetection then
                    zomb.statut = "calme"
                    else
                    zomb.statut = "alerte"
                    end
                end
            end
            --Mort du zombie
            if zomb.vie <= 0 then
                zomb.etat = "mort"
                table.insert(zombie.lstMort, zomb)
                table.remove(zombie.lst, n)
            end
        end
    end
     -- Gestion des collisions des zombies
    function zombie.GestionCollision(pHeros)
        for n = #zombie.lst, 1, -1 do
            local currentZomb = zombie.lst[n]
            if currentZomb.etat ~= "mort" then
                --Gestion Collision entre zombies (fonction qui crée un plantage, je la laisse
                --en commentaire pour en discuter pendant la soutenance)
               --[[ if currentZomb.statut == "calme" then
                    for i = #zombie.lst, 1, -1  do
                        if i ~= n then
                            local zomb = zombie.lst[i]
                            local distance = math.sqrt((currentZomb.x - zomb.x)*(currentZomb.x - zomb.x) + (currentZomb.y - zomb.y)*(currentZomb.y - zomb.y))
                            if distance < distanceMiniZombies then
                                currentZomb.x = currentZomb.oldPosZombX
                                currentZomb.y = currentZomb.oldPosZombY
                                currentZomb.enCollision = true
                            else
                                currentZomb.oldPosZombX = currentZomb.x
                                currentZomb.oldPosZombY = currentZomb.y
                            end
                        end
                    end
                end]]
                --Gestion des collisions avec les balles
                if pHeros.arme == "pistolet" then
                    for i = #pHeros.lstmunitionsPistolet , 1, -1 do
                        local distance = math.sqrt((currentZomb.x - pHeros.lstmunitionsPistolet[i].x)*(currentZomb.x - pHeros.lstmunitionsPistolet[i].x) + 
                        (currentZomb.y - pHeros.lstmunitionsPistolet[i].y)*(currentZomb.y - pHeros.lstmunitionsPistolet[i].y))
                        if distance < distanceImpactBalles then
                            currentZomb.vie = currentZomb.vie - pHeros.lstmunitionsPistolet[i].degats
                            table.remove(pHeros.lstmunitionsPistolet, i)
                            currentZomb.blesser = true
                        end
                    end   
                elseif pHeros.arme == "uzi" then
                    for i = #pHeros.lstmunitionsUzi , 1, -1 do
                        local distance = math.sqrt((currentZomb.x - pHeros.lstmunitionsUzi[i].x)*(currentZomb.x - pHeros.lstmunitionsUzi[i].x) + 
                        (currentZomb.y - pHeros.lstmunitionsUzi[i].y)*(currentZomb.y - pHeros.lstmunitionsUzi[i].y))
                        if distance < distanceImpactBalles then
                            currentZomb.vie = currentZomb.vie - pHeros.lstmunitionsUzi[i].degats
                            table.remove(pHeros.lstmunitionsUzi, i)
                            currentZomb.blesser = true
                        end
                    end   
                end
                --Gestion des collisions avec la map
                 if currentZomb.x > limitePosition and currentZomb.x < screenw - limitePosition
                 and currentZomb.y > limitePosition and currentZomb.y < screenh - limitePosition then
                     local x1 = currentZomb.x + distanceMinCollisionMap*math.cos(currentZomb.direction)
                     local y1 = currentZomb.y + distanceMinCollisionMap*math.sin(currentZomb.direction)
                     local x2 = currentZomb.x + distanceMinCollisionMap*math.cos(currentZomb.direction - math.rad(40))
                     local y2 = currentZomb.y + distanceMinCollisionMap*math.sin(currentZomb.direction - math.rad(40))
                     local x3 = currentZomb.x + distanceMinCollisionMap*math.cos(currentZomb.direction + math.rad(40))
                     local y3 = currentZomb.y + distanceMinCollisionMap*math.sin(currentZomb.direction + math.rad(40))
                     local Cx1, Lx1 = map.RecupererPosition(x1,y1)
                     local Cx2, Lx2 = map.RecupererPosition(x2,y2)
                     local Cx3, Lx3 = map.RecupererPosition(x3,y3)
                     local index1 = map.Grid[Lx1][Cx1]
                     local index2 = map.Grid[Lx2][Cx2]
                     local index3 = map.Grid[Lx3][Cx3]
                     if map.IsSolidPersonnage(index1) or map.IsSolidPersonnage(index2) or map.IsSolidPersonnage(index3) then
                         currentZomb.x = currentZomb.oldPosHerosX
                         currentZomb.y = currentZomb.oldPosHerosY 
                         currentZomb.enCollision = true
                     else
                         currentZomb.oldPosHerosX = currentZomb.x
                         currentZomb.oldPosHerosY = currentZomb.y
                     end
                 end
            end
        end
        --Gestion des degats au couteau
        local posCouteauX = pHeros.x + pHeros.distanceCouteau*math.cos(curseur.direction)
        local posCouteauY = pHeros.y + pHeros.distanceCouteau*math.sin(curseur.direction)
        local nZomb = math.random(1, #zombie.lstAttaque)
        local zomb = zombie.lstAttaque[nZomb]
        if pHeros.etat == "attaque2" and pHeros.frame == 1 and #zombie.lstAttaque > 0 then
            local distance = math.sqrt((zomb.x - posCouteauX)*(zomb.x - posCouteauX) + 
            (zomb.y - posCouteauY)*(zomb.y - posCouteauY))
            if distance < distanceDegatCouteau then
                zomb.vie = zomb.vie - pHeros.lstArmes[pHeros.indexArme].degats
                zomb.blesser = true
            end
        end
        for n=#zombie.lstAttaque, 1, -1 do
            local zomb = zombie.lstAttaque[n]
            if zomb.vie <= 0 then
                table.remove(zombie.lstAttaque, n)
            end
        end
    end
    -- Gestion des timer des zombies
    function zombie.GestionTimer(dt)
        timer:DecrementerTimer(dt)
        timer:IncrementerTimer(dt)
    end

    function zombie.AnimationBlessureZombie(dt)
        for n = 1, #zombie.lst do
            local zomb = zombie.lst[n]
            if zomb.blesser == true then
                zomb.currentImageBlessure = animation.JouerAnimation(lstImagesSang, 20, dt, 1)   
                if animation.frame[1] == 1 then
                    zomb.blesser = false
                end
            end
        end
    end

    function zombie.Draw(heros)
        for n = 1,#zombie.lst do
            local currentZombie = zombie.lst[n]
            love.graphics.draw(currentZombie.currentImage, currentZombie.x, currentZombie.y, currentZombie.direction, 0.3, 0.3, 
            currentZombie.currentImage:getWidth()/2, currentZombie.currentImage:getHeight()/2)
            -- affichage des blessures
            if currentZombie.blesser == true and heros.GAMEOVER == false and heros.WIN == false then
                love.graphics.draw(tileSheet1, currentZombie.currentImageBlessure, currentZombie.x, currentZombie.y,
                    0, 0.2, 0.2, LARGEUR_IMAGE_ts1/2, HAUTEUR_IMAGE_ts1/2)
            end
        end
        for n = 1,#zombie.lstMort do
            local currentZombie = zombie.lstMort[n]
            love.graphics.draw(currentZombie.currentImage, currentZombie.x, currentZombie.y, currentZombie.direction, 0.3, 0.3, 
            currentZombie.currentImage:getWidth()/2, currentZombie.currentImage:getHeight()/2)
        end
    end

return zombie