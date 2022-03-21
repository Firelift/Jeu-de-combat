local musiques = {}
    local env = require("environnement")

    musiques.compteurSonWind = 10
    musiques.compteurSonRaven = env.compteur
    musiques.volume = 0.2
    musiques.lstSons = {}
    local init = false

    function musiques.Init()
        musiques.compteurSonWind = 10
        musiques.compteurSonRaven = env.compteur
        musiques.volume = 0.2
    end
    function musiques.GestionVolume(VolumeInitial, VolumeFinal, pVitesse, dt)
        --Augmente/diminue le volume progressivement
        if init == false then
            musiques.volume = VolumeInitial
            init = true
        end
        if VolumeInitial < VolumeFinal and musiques.volume < VolumeFinal then
            musiques.volume = musiques.volume + pVitesse*dt
        end
        if VolumeInitial > VolumeFinal and musiques.volume > VolumeFinal then
            musiques.volume = musiques.volume - pVitesse*dt
        end
        if musiques.volume == VolumeFinal then
            init = false
        end
        love.audio.setVolume(musiques.volume)
    end

    function musiques.GestionMusiques(pHeros,dt)
        if pHeros.statut == "horsdanger" then
            musiques.GestionVolume(0.8, 0.3, 0.5, dt)
        elseif pHeros.statut == "endanger" then
            musiques.GestionVolume(0.3, 0.8, 0.5, dt)
        end
    end

    function musiques.ChargerSons()
        local SndWind1 = love.audio.newSource("sons/wind1.ogg", "static")
        local SndWind2 = love.audio.newSource("sons/wind2.ogg", "static")
        local SndRaven = love.audio.newSource("sons/raven.wav", "static")
        local SndTir = love.audio.newSource("sons/tir.ogg", "static")
        musiques.lstSons[1] = SndWind1
        musiques.lstSons[2] = SndWind2
        musiques.lstSons[3] = SndRaven
        musiques.lstSons[4] = SndTir
    end

    function musiques.GestionSons(pValeurC1, dt)
        if musiques.compteurSonWind <= 0 then
            local Snd = math.random(1,2)
            love.audio.play(musiques.lstSons[Snd])
            musiques.compteurSonWind = pValeurC1
        end
        if musiques.compteurSonRaven <=0 then
            love.audio.play(musiques.lstSons[3])
            musiques.compteurSonRaven = env.compteur
        end

        musiques.compteurSonRaven = musiques.compteurSonRaven - dt
        musiques.compteurSonWind = musiques.compteurSonWind - dt
    end

return musiques