local button = {}
    local images = require("images")
    button.lst = {}
    button.lstWin = {}
    button.lstGameOver = {}
    function button.load()
        button.CreerButton("play", 1, 30, screenw/2 - 350, screenh - 125)
        button.CreerButton("quit", 1, 30, screenw/2 + 70, screenh - 125)
        button.CreerButton("play", 2, 30, screenw/2 - 150, 450)
        button.CreerButton("quit", 2, 30, screenw/2 - 150, 550)
    end
    function button.Init()
        for n=1,#button.lst do
            button.lst[n].select = false
        end
    end
    function button.CreerButton(name, indexLst, nImages, x, y)
        local but = {}
        but.name = name
        but.lstImg = images.ChargerImages(nImages, "button", name)
        but.currentImg = but.lstImg[1]
        but.x = x
        but.y = y
        but.select = false
        but.frame = 1
        if indexLst == 1 then
            table.insert(button.lstWin, but)
        elseif indexLst == 2 then
            table.insert(button.lstGameOver, but)
        end
        table.insert(button.lst, but)
    end

    function button.IsHover(curseur, indexLst)
        local lst = {}
        if indexLst == 1 then
            lst = button.lstWin
        elseif indexLst == 2 then
            lst = button.lstGameOver
        end
        for n = 1,#lst do
            local but = lst[n]
            if curseur.x >= but.x and curseur.x <= but.x + but.currentImg:getWidth() 
            and curseur.y >= but.y and curseur.y <= but.y + but.currentImg:getHeight() then
                but.select = true
            else
                but.select = false
            end
        end
    end

return button