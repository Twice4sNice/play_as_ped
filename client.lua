ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local whitelisted_identifier = { -- Should work with any license
    "steam:XXXXXXXXXXXXX",
}

RegisterCommand('playasped', function()
    ESX.TriggerServerCallback('play_as_ped:getData', function(data)
        if data.group ~= "user" then -- Only mod, admin, superadmin
            local elements = {
                {label = 'Human',            value = 1,  ped = "human"},
                {label = 'Cat',              value = 2,  ped = "a_c_cat_01"},
                {label = 'Pug',              value = 3,  ped = "a_c_pug"},
                {label = 'Poodle',           value = 4,  ped = "a_c_poodle"},
                {label = 'Westy',            value = 5,  ped = "a_c_westy"},
                {label = 'Bird',             value = 8,  ped = "a_c_chickenhawk"},
                {label = 'Seagul',           value = 21, ped = "a_c_seagull"},
                {label = 'Deer',             value = 21, ped = "a_c_deer"},
                {label = 'Pigeon',           value = 12, ped = "a_c_pigeon"},
                {label = 'Coyote',           value = 14, ped = "a_c_coyote"},
                {label = 'Rabbit',           value = 15, ped = "a_c_rabbit_01"},
				{label = 'Retriever',        value = 16, ped = "a_c_retriever"},
				{label = 'Shepherd',         value = 17, ped = "a_c_shepherd"},
				{label = 'Rottweiler',       value = 18, ped = "a_c_rottweiler"},
				{label = 'Panther',          value = 19, ped = "a_c_panther"},
				{label = 'Husky',          	 value = 20, ped = "a_c_husky"},                
                {label = 'Jesus v. N.',          	 value = 21, ped = "u_m_m_jesus_01"},
                {label = 'Juggernaut',          	 value = 22, ped = "u_m_y_juggernaut_01"}, 
                {label = 'Pogo',          	 value = 23, ped = "u_m_y_pogo_01"},
                {label = 'Prisoner',          	 value = 24, ped = "u_m_y_prisoner_01"},
                
                
                             
                --{label = 'Cow',              value = 9,  ped = "a_c_cow"},
                --{label = 'Pig',              value = 10, ped = "a_c_pig"},
                --{label = 'Hen',              value = 13, ped = "a_c_hen"},
            }
            
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ped_menu',
            {
                title    = 'Choose a Animal',
                align    = 'left',
                elements = elements
            }, function(data, menu)
                for i=1, #elements do
				    if data.current.value == i then
				        if data.current.ped == "human" then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                local isMale = skin.sex == 0
        
                                if isMale then 
                                    RequestModel("mp_m_freemode_01")
        
                                    while not HasModelLoaded("mp_m_freemode_01") do
                                        Citizen.Wait(0)
                                    end
                
                                    SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))
                                else
                                    RequestModel("mp_f_freemode_01")
        
                                    while not HasModelLoaded("mp_f_freemode_01") do
                                        Citizen.Wait(0)
                                    end
                
                                    SetPlayerModel(PlayerId(), GetHashKey("mp_f_freemode_01"))
                                end
        
                                TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                    TriggerEvent('esx:restoreLoadout')
                                end)
                            end)    
						else
                            RequestModel(data.current.ped)
        
                            while not HasModelLoaded(data.current.ped) do
                                Citizen.Wait(3)
                            end

                            SetPlayerModel(PlayerId(), GetHashKey(data.current.ped))
                            
                        end
                    
					else 
							RequestModel(data.current.ped)
        
                            while not HasModelLoaded(data.current.ped) do
                                Citizen.Wait(3)
                            end

                            SetPlayerModel(PlayerId(), GetHashKey(data.current.ped))
							SetPedDefaultComponentVariation(PlayerPedId())
					end
                    menu.close()	
                end
            end, function(data, menu)
                menu.close()
            end)
        else
            for i=1, #whitelisted_identifier do
                if whitelisted_identifier[i] == data.identifier then
                    local elements = {
                        {label = 'Human',            value = 1,  ped = "human"},
						{label = 'Pug',              value = 3,  ped = "a_c_pug"},
						{label = 'Poodle',           value = 4,  ped = "a_c_poodle"},
						{label = 'Westy',            value = 5,  ped = "a_c_westy"},
						{label = 'Retriever',        value = 16, ped = "a_c_retriever"},
						{label = 'Shepherd',         value = 17, ped = "a_c_shepherd"},
						{label = 'Rottweiler',       value = 18, ped = "a_c_rottweiler"},
						{label = 'Panther',          value = 19, ped = "a_c_panther"},
						{label = 'Husky',          	 value = 20, ped = "a_c_husky"}                        
                        --{label = 'Cat',              value = 2,  ped = "a_c_cat_01"},
                        --{label = 'Bird',             value = 8,  ped = "a_c_chickenhawk"},
						--{label = 'Cow',              value = 9,  ped = "a_c_cow"},
						--{label = 'Pig',              value = 10, ped = "a_c_pig"},
						--{label = 'Pigeon',           value = 12, ped = "a_c_pigeon"},
						--{label = 'Hen',              value = 13, ped = "a_c_hen"},
						--{label = 'Coyote',           value = 14, ped = "a_c_coyote"},
						--{label = 'Rabbit',           value = 15, ped = "a_c_rabbit_01"},						
                    }
                    
                    ESX.UI.Menu.CloseAll()
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ped_menu',
                    {
                        title    = 'Choose an Animal',
                        align    = 'left',
                        elements = elements
                    }, function(data, menu)
                        for i=1, #elements do
                            if data.current.value == i then
                                if data.current.ped == "human" then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                        local isMale = skin.sex == 0
                
                                        if isMale then 
                                            RequestModel("mp_m_freemode_01")
                
                                            while not HasModelLoaded("mp_m_freemode_01") do
                                                Citizen.Wait(0)
                                            end
                        
                                            SetPlayerModel(PlayerPedId(), "mp_m_freemode_01")
                                        else
                                            RequestModel("mp_f_freemode_01")
                
                                            while not HasModelLoaded("mp_f_freemode_01") do
                                                Citizen.Wait(0)
                                            end
                        
                                            SetPlayerModel(PlayerPedId(), "mp_f_freemode_01")
                                        end
                
                                        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                            TriggerEvent('skinchanger:loadSkin', skin)
                                            TriggerEvent('esx:restoreLoadout')
                                        end)
                                    end)      
                                else
                                    RequestModel(data.current.ped)
                
                                    while not HasModelLoaded(data.current.ped) do
                                        Citizen.Wait(0)
                                    end
                
                                    SetPlayerModel(PlayerPedId(), data.current.ped)
                                end
                            end
                        end
                    end, function(data, menu)
                        menu.close()
                    end)
                end
            end
        end
    end)
end)
