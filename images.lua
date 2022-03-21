local images = {}
--charge les images présentes dans le dossier spécifié
    function images.ChargerImages(pN, pCharacter, pNomDossier)
        local lst = {}
        if pNomDossier ~= nil then
            for n = 1, pN do
                local image = love.graphics.newImage("images/"..tostring(pCharacter).."/"..tostring(pNomDossier).."/"..tostring(n)..".png")
                table.insert(lst, n, image)
            end
        elseif pNomDossier == nil then
            for n = 1, pN do
                local image = love.graphics.newImage("images/"..tostring(pCharacter).."/"..tostring(n)..".png")
                table.insert(lst, n, image)
            end
        end
        return lst
    end
    --recupere les quads d'une tilesheet
    function images.RecupererImagesTileSheet(pTileSheet, nImagesX, nImagesY)
        local lst = {}
        local TILE_LARGEUR = pTileSheet:getWidth()/nImagesX
        local TILE_HAUTEUR = pTileSheet:getHeight()/nImagesY
        for l=1, nImagesY do
            for c=1, nImagesX do
                local quad = love.graphics.newQuad((c - 1)*TILE_LARGEUR, (l - 1)*TILE_HAUTEUR, 
                TILE_LARGEUR, TILE_HAUTEUR, pTileSheet:getWidth(), pTileSheet:getHeight())
                table.insert(lst, quad)
            end
        end
        return lst
    end

return images