local animation = {}
    animation.frame = {}
    animation.frame[1] = 1
    animation.frame[2] = 1

    function animation.JouerAnimationPersonnage(pPersonnage, pVitesse, dt, module) 
        local vitesseAnimation = pVitesse
        pPersonnage.frame = pPersonnage.frame  +  vitesseAnimation*dt
        if math.floor(pPersonnage.frame) >= #module.lstImg[pPersonnage.etat] + 1 then
            pPersonnage.frame = 1
        end
        pPersonnage.currentImage = module.lstImg[pPersonnage.etat][math.floor(pPersonnage.frame)]
    end

    function animation.JouerAnimationObjet(lst, pVitesse, dt, pObjet)
        local vitesseAnimation = pVitesse
        pObjet.frame = pObjet.frame + vitesseAnimation*dt
        if math.floor(pObjet.frame) >= #lst + 1 then
            pObjet.frame = 1
        end
        local currentImage = lst[math.floor(pObjet.frame)]
        return currentImage
    end

    function animation.JouerAnimation(lst, pVitesse, dt, indexFrame)
        local vitesseAnimation = pVitesse
        animation.frame[indexFrame] = animation.frame[indexFrame] + vitesseAnimation*dt
        if math.floor(animation.frame[indexFrame]) >= #lst + 1 then
            animation.frame[indexFrame] = 1
        end
        local currentImage = lst[math.floor(animation.frame[indexFrame])]
        return currentImage
    end

return animation