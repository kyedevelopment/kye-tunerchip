ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem(Config.Item, function(src)
    TriggerClientEvent("kye:openChip", src)    
end)