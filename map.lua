local map = {}

    local images = require("images")

    function map.Taille()
        local nLigne = #map.Grid
        local nColonne
        for l = 1 , nLigne do
            if l > 1 then
                if #map.Grid[l-1] == #map.Grid[l] then
                    nColonne = #map.Grid[l]
                else
                    print("La grille de la map est à redefinir!")
                    map.isValid = false
                end
            else
                nColonne = #map.Grid[l]
            end
        end
        return nLigne, nColonne
    end
    map.Grid = {
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 11, 11, 11, 11, 11},
        {11, 11, 12, 11, 11, 11, 11, 11, 11, 11, 11, 11, 62, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 62, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 20, 20, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 11, 11, 11, 11, 11, 11, 11, 11, 10, 20, 20, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11},
        {11, 11, 14, 11, 11, 11, 11, 15, 11, 11, 62, 11, 11, 11, 11, 11, 11, 11, 11, 10, 20, 20, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 62, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 20, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 20, 20, 20, 20, 10, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 15, 11, 11, 11, 11, 11, 11, 11, 10, 11, 11, 11, 11, 11, 11, 11, 11, 10, 61, 10, 10, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 14, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 15, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 10, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 62, 11, 11, 11, 11},
        {11, 11, 11, 10, 10, 20, 20, 20, 20, 10, 62, 11, 11, 14, 62, 11, 11, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 10, 20, 20, 20, 20, 20, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 62, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 10, 10, 10, 20, 20, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 14, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 10, 11, 11, 11, 11, 11, 11, 14, 11, 11, 12, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 14, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 62, 11, 11, 12, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
        {11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11}
    }
    map.isValid = true
    map.nLigne, map.nColonne = map.Taille()

    

    local lstQuadsMap = {}
    local TILE_LARGEUR 
    local TILE_HAUTEUR

    function map.Load()
       map.Tilesheet = {} 
       map.Tilesheet.img = love.graphics.newImage("images/map/tilesheet.png")
       map.Tilesheet.nImgX = 9
       map.Tilesheet.nImgY = 19
       lstQuadsMap = images.RecupererImagesTileSheet(map.Tilesheet.img, 9 ,19)
       TILE_LARGEUR = map.Tilesheet.img:getWidth()/map.Tilesheet.nImgX
       TILE_HAUTEUR = map.Tilesheet.img:getHeight()/map.Tilesheet.nImgY
    end

    function map.Draw()
        if map.isValid == true then
            for l = 1, map.nLigne do
                for c = 1, map.nColonne do
                    local index = map.Grid[l][c]
                    love.graphics.draw(map.Tilesheet.img, lstQuadsMap[index], (c-1)*TILE_LARGEUR, (l-1)*TILE_HAUTEUR)
                end
            end
        end 
    end
    --Recuperer la colonne et la ligne d'un point sur la map
    function map.RecupererPosition(x,y)
        local colonne = math.floor((x/TILE_LARGEUR) + 1)
        local ligne = math.floor((y/TILE_HAUTEUR) + 1)
        return colonne, ligne
    end
    --Definir les obstacles sur la map pour le heros et les zombies
    function map.IsSolidPersonnage(index)
        if index == 20 or index == 61 or index == 62 then
            return true
        end
        return false
    end
    --Definir les obstacles sur la map pour les munitions
    function map.IsSolidMunition(index)
        if index == 61 or index == 62 then
            return true
        end
        return false
    end
return map