local images = require("images")
local animation = require("animation")
local heros = require("heros")
local zombie = require("zombie")
local timer = require("timer")
local curseur = require("curseur")
local musiques = require("musiques")
local environnement = require("environnement")
local boutons = require("button")
local map = require("map")
local munitions = require("munitions")
local bonus = require("bonus")

local alpha = 0
local tempsJeu = 100
function InitGame()
    tempsSurvie = tempsJeu
    alpha = 0

    heros = heros.CreerHeros()
    heros.GAMEOVER = false
    heros.WIN = false
    heros.EnSecurite = false

    zombie.Init()
    zombie.CreerZombie(10)

    environnement.lst = {}
    environnement.HeliOut = false

    boutons.Init()

    bonus.Init()

    musiques.Init()
    musicJeu:play()
    musicGameover:stop()
    musicVictoire:stop()
    musicVictoireON = false
end

function love.load()
    love.window.setMode(1024,768)
    screenw = love.graphics.getWidth()
    screenh = love.graphics.getHeight()
    math.randomseed(os.time())
    love.mouse.setVisible(true)
    --Initialise le temps de survie
    tempsSurvie = tempsJeu
    --Charger les images
    map.Load()
    zombie.Load()
    heros.Load()
    tileSheet1 = love.graphics.newImage("images/zombie/sang/tilesheet.png")
    LARGEUR_IMAGE_ts1 = 512
    HAUTEUR_IMAGE_ts1 = 512
    lstImagesSang = {}
    lstImagesSang = images.RecupererImagesTileSheet(tileSheet1,4,4)
    imgGameover = love.graphics.newImage("images/gameover/1.png")
    --Chargement des boutons
    boutons.load()
    --Creer le heros avec ses variables et ses images
    heros = heros.CreerHeros()
    --Creer la horde de zombies avec leurs variables et leurs images
    zombie.CreerZombie(10)
    --Inialialise le volume
    love.audio.setVolume(musiques.volume)
    --Charger les musiques
    musicJeu = love.audio.newSource("musiques/1.mp3", "stream")
    musicGameover = love.audio.newSource("musiques/2.ogg", "stream")
    musicVictoire = love.audio.newSource("musiques/3.mp3", "stream")
    musicVictoireON = false

    musicJeu:setLooping(true)
    musicJeu:play()
    --Charger les sons
    musiques.ChargerSons()
    --Chargement des font
    font1 = love.graphics.newFont("font/Oswald-Regular.ttf")
end

function love.update(dt)
    local mouseX , mouseY = love.mouse.getPosition()
    curseur.x = mouseX
    curseur.y = mouseY
    if heros.GAMEOVER == false then
        if heros.WIN == false then
            zombie.Update(dt)
            --Deplacement zombies
            zombie.GestionTimer(dt)
            zombie.GestionDeplacement(heros,dt)
            --Gestion etat zombie
            zombie.GestionEtat(heros)
            --Gestion collision zombie
            zombie.GestionCollision(heros)
            --Animation zombies
            for n=1,#zombie.lst do
                animation.JouerAnimationPersonnage(zombie.lst[n], 10, dt, zombie)
            end
            for n=1,#zombie.lstMort do
                animation.JouerAnimationPersonnage(zombie.lstMort[n], 10, dt, zombie)
            end
            zombie.AnimationBlessureZombie(dt)
            --Gestion de la musique
            musiques.GestionMusiques(heros, dt)
            --Gestion du temps
            tempsSurvie = tempsSurvie - dt
            if tempsSurvie <= 0 then
                tempsSurvie = 0
                heros.WIN = true
            end
            --Gestion des bonus
            bonus.Update(map, dt)
        elseif heros.WIN == true then
            if environnement.HeliOut == true then
                --Gestions des boutons
                boutons.IsHover(curseur, 1)
                for n=1,#boutons.lstWin do
                    local but = boutons.lstWin[n]
                    if but.select == true then
                        but.currentImg = animation.JouerAnimationObjet(but.lstImg, 20, dt, but)
                    elseif but.select == false then
                        but.currentImg = but.lstImg[1]
                    end
                end
            end
            for n = 1, #zombie.lst do
                zombie.lst[n].currentImage = zombie.lstImg["mort"][1]
            end
            if musiques.volume > 0 and musicVictoireON == false then
                musiques.GestionVolume(musiques.volume, 0, 0.2, dt) 
            elseif musiques.volume <= 0 and musicVictoireON == false then
                musicJeu:stop()
                musicVictoire:play()
                musicVictoireON = true
            else
                musiques.GestionVolume(0, 0.8, 0.2, dt) 
            end       
        end
        --Gestion du curseur
        curseur.GestionDeplacement(heros)  
        heros.Update(zombie.lst, dt)
        --Gestion etat heros
        heros.GestionEtat(zombie)
        --Deplacement heros
        heros.DeplacementHeros(curseur, dt)
        --Animation heros
        if heros.etat == "tire" then
            if heros.frame == 1 then
                heros.etat = "arret"
            end
        end   
        if heros.etat == "charge" then
            if heros.frame == 1 then
                heros.etat = "arret"
            end  
        end
        animation.JouerAnimationPersonnage(heros, 20, dt, heros)
        --Gestion collision heros
        heros.GestionCollision(zombie, environnement)
        --Gestion des munitions
        --Deplacement
        heros:DeplacerMunitions(heros.arme, dt)
        --Suppression
        heros:SupprimerMunitions(heros.arme)
        --Gestion de l'environnement
        environnement.Update(heros, dt)
        --Gestion des sons
        musiques.GestionSons(math.random(15,20), dt)
    --Gestion des scenes
    elseif heros.GAMEOVER == true then
        heros.currentImage = heros.lstImg["mort"][1]
        --Deplacement zombies
        zombie.GestionTimer(dt)
        zombie.GestionDeplacement(heros,dt)
        --Animation zombies
        for n=1,#zombie.lst do
            animation.JouerAnimationPersonnage(zombie.lst[n], 10, dt, zombie)
        end
        --Gestion etat zombie
        for n=1, #zombie.lst do
            zombie.lst[n].statut = "calme"
            zombie.lst[n].etat = "marche"
        end
        --Gestion collision zombie
        zombie.GestionCollision(heros)
        musicJeu:stop()
        love.audio.setVolume(0.8)
        musicGameover:play()
        --Gestion de l'environnement
        environnement.Update(heros, dt)
        --Gestion de la transparence de l'affichage
        if alpha < 1 then
            alpha = alpha + 0.2*dt
        else 
            alpha = 1
            --Gestions des boutons
            boutons.IsHover(curseur, 2)
            for n=1,#boutons.lstGameOver do
                local but = boutons.lstGameOver[n]
                if but.select == true then
                    but.currentImg = animation.JouerAnimationObjet(but.lstImg, 20, dt, but)
                elseif but.select == false then
                    but.currentImg = but.lstImg[1]
                end
            end
        end
    end  
end
--Gestion de la souris
function love.mousepressed(x, y, button)
    if heros.GAMEOVER == false and heros.EnSecurite == false then
        heros.mousepressed(x, y, button)
    end
end
function love.mousereleased(x, y, button)
    --Gestion du click sur boutons
    if button == 1 and (heros.GAMEOVER == true or heros.WIN == true) then
        for n=1, #boutons.lst do
            local but = boutons.lst[n]
            if but.select == true and but.name == "quit" then
                love.event.quit()
            elseif but.select == true and but.name == "play" then
                InitGame()
            end
        end
    end
end
--Gestion du clavier
function love.keypressed(key)
    if heros.GAMEOVER == false then
        heros.keypressed(key)
    end
end
--Affichage
function love.draw()
    -- affichage de la carte
    map.Draw()
    -- affichage des zombies
    zombie.Draw(heros)
    -- affichage du heros
    heros.Draw()
    -- affichage de l'environnement
    environnement.Draw(heros)
    if heros.GAMEOVER == false and heros.WIN == false then
        -- affichage du curseur
        love.graphics.draw(curseur.image, curseur.x, curseur.y, 0 , .065, .065, curseur.image:getWidth()/2, curseur.image:getHeight()/2)
        love.graphics.print("TEMPS DE SURVIE: "..math.floor(tempsSurvie).." s", font1, screenw/2 - 100, 20, 0, 2, 2)
        -- affichage des balles
        munitions.Draw(heros)
        -- affichage de l'arme equipe
        if heros.indexArme == 1 then
            love.graphics.draw(heros.lstArmes[heros.indexArme].img, screenw - 150 , 50, 0 , .04, .04)
            love.graphics.print(heros.MunitionsPistolet.." / "..heros.lstArmes[heros.indexArme].utilisation, 
            font1, screenw - 50, 50)
            love.graphics.print(heros.chargeurPistolet, font1, screenw - 35, 70)
        elseif heros.indexArme == 2 then
            love.graphics.draw(heros.lstArmes[heros.indexArme].img, screenw - 150 , 50, 0 , .1, .1)
        elseif heros.indexArme == 3 then
            love.graphics.draw(heros.lstArmes[heros.indexArme].img, screenw - 150 , 50, 0 , .1, .1)
            love.graphics.print(heros.MunitionsUzi.." / "..heros.lstArmes[heros.indexArme].utilisation, 
            font1, screenw - 50, 50)
            love.graphics.print(heros.chargeurUzi, font1, screenw - 35, 70)
        end
        -- affichage des points de vie du heros
        love.graphics.print(math.floor(heros.vie).." PV", font1, 100, 50, 0, 1, 1)
        -- affichage du bonus
        bonus.Draw()
    elseif heros.GAMEOVER == false and heros.WIN == true then
        -- affichage des balles
        munitions.Draw(heros)
        --affichage des boutons
        if environnement.HeliOut == true then
            for n=1,#boutons.lstWin do
                local but = boutons.lstWin[n]
                love.graphics.draw(but.currentImg, but.x, but.y)
            end
        end
    -- affichage de la scene gameover
    elseif heros.GAMEOVER == true then
        love.graphics.setColor(1,1,1,alpha)
        love.graphics.draw(imgGameover, screenw/2 - 275, screenh/2 - imgGameover:getHeight()/2 + 50,
        0, 0.5, 0.5)
        love.graphics.setColor(1,1,1,1)
        --affichage des boutons
        if alpha == 1 then
            for n=1,#boutons.lstGameOver do
                local but = boutons.lstGameOver[n]
                love.graphics.draw(but.currentImg, but.x, but.y)
            end
        end
    end
end



