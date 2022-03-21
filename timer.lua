local timer = {}

timer.valeur = 0
timer.duree = 0
timer.START = false
timer.DECREMENTATION = false
timer.INCREMENTATION = true

    function timer.CreateTimer()
        return timer
    end

    function timer:DecrementerTimer(dt)
        if timer.START == false and timer.DECREMENTATION == true then
            local duree = math.random(6,8)
            timer.valeur = duree
            timer.START = true
        elseif timer.DECREMENTATION == true then
            if timer.valeur > 0 then
                timer.valeur = timer.valeur - dt
            else
                timer.DECREMENTATION = false
                timer.INCREMENTATION = true
                timer.START = false
            end
        end
    end

    function timer:IncrementerTimer(dt)
        if timer.START == false and timer.INCREMENTATION == true then
            local duree = math.random(3,4)
            timer.duree = duree
            timer.valeur = 0
            timer.START = true
        elseif timer.INCREMENTATION == true then
            if timer.valeur < timer.duree then
                timer.valeur = timer.valeur + dt
            else
                timer.DECREMENTATION = true
                timer.INCREMENTATION = false
                timer.START = false
            end
        end
    end
return timer