Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/k9', 'Opens K9 Menu')
    TriggerEvent('chat:addSuggestion', '/k9sit', 'K9 Animation')
    TriggerEvent('chat:addSuggestion', '/k9lay', 'K9 Animation')
    TriggerEvent('chat:addSuggestion', '/k9search', 'K9 Animation')
end)

_MenuPool = NativeUI.CreatePool()
MainMenu = NativeUI.CreateMenu()

local animations = {
    ['Normal'] = {
        sit = {
            dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
            anim = "idle_b"
        },
        laydown = {
            dict = "creatures@rottweiler@amb@sleep_in_kennel@",
            anim = "sleep_in_kennel"
        },
        searchhit = {
            dict = "creatures@rottweiler@indication@",
            anim = "indicate_high"
        }
    }
}

function Menu()
    _MenuPool:Remove()
    _MenuPool = NativeUI.CreatePool()
    MainMenu = NativeUI.CreateMenu(MenuTitle, 'RAMPAGE K9 Menu', 1320)
    _MenuPool:Add(MainMenu)
    MainMenu:SetMenuWidthOffset(80)
    collectgarbage()
    MainMenu:SetMenuWidthOffset(80)
    _MenuPool:ControlDisablingEnabled(false)
    _MenuPool:MouseControlsEnabled(false)
    local Animations = _MenuPool:AddSubMenu(MainMenu, 'Animations', 'Play animations', true)
    Animations:SetMenuWidthOffset(80)
    local Peds = _MenuPool:AddSubMenu(MainMenu, 'Peds', 'Spawn ped', true)
    Peds:SetMenuWidthOffset(80)
    local Sit = NativeUI.CreateItem('Sit', 'Sit on the ground.')
    local Search = NativeUI.CreateItem('Search', 'Search around')
    local Lay = NativeUI.CreateItem('Lay', 'Laydown on the ground.')
    local Cancel = NativeUI.CreateItem('~r~Cancel Emote', 'Stop the emote')
    local K9 = NativeUI.CreateItem('Police K9', 'Become Police K9 Ped')
    Animations:AddItem(Sit)
    Animations:AddItem(Lay)
    Animations:AddItem(Search)
    Animations:AddItem(Cancel)
    Peds:AddItem(K9)
    Sit.Activated = function(ParentMenu, SelectedItem)
        PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
    end
    Lay.Activated = function(ParentMenu, SelectedItem)
        PlayAnimation(animations['Normal'].laydown.dict, animations['Normal'].laydown.anim)
    end
    Search.Activated = function(ParentMenu, SelectedItem)
        PlayAnimation(animations['Normal'].searchhit.dict, animations['Normal'].searchhit.anim)
    end
    Cancel.Activated = function(ParentMenu, SelectedItem)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end
    K9.Activated = function(ParentMenu, SelectedItem)
        local ped = 'a_c_shepherd'
        local hash = GetHashKey(ped)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), hash)
    end
end

RegisterCommand('k9', function(source, args, rawCommand)
    Menu()
    MainMenu:Visible(true)
end)

RegisterCommand('k9sit', function(source, args, rawCommand)
    PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
end)

RegisterCommand('k9lay', function(source, args, rawCommand)
    PlayAnimation(animations['Normal'].laydown.dict, animations['Normal'].laydown.anim)
end)

RegisterCommand('k9search', function(source, args, rawCommand)
    PlayAnimation(animations['Normal'].searchhit.dict, animations['Normal'].searchhit.anim)
end)

function PlayAnimation(dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(spawned_ped, dict, anim, 8.0, -8.0, -1, 2, 0.0, 0, 0, 0)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _MenuPool:ProcessMenus()
        _MenuPool:ControlDisablingEnabled(false)
        _MenuPool:MouseControlsEnabled(false)
    end
end)
