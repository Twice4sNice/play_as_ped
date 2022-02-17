ESX = nil;
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj)
			ESX = obj;
		end);
		Citizen.Wait(0);
	end;
end);

local cat_whitelisted_identifier = {
	"steam:110000132f6b5a1"	
};

local dog_whitelisted_identifier = {
	"steam:110000113e9ded0",
	"steam:110000104a02bd6"
};

TriggerEvent('chat:addSuggestion', '/playasped', 'Play your favorite lifeform' )
TriggerEvent('chat:addSuggestion', '/dogemote', 'Dog Emotions' )


--region Emotes

local emotePlaying = false;
local currentped = "human";
local lastanimation = nil;

RegisterCommand("dogemote", function()
	if isDog() and emotePlaying == false then
		OpenEmoteMenu()
	end
end)

local dogModels = {	"a_c_pug", "a_c_poodle", "a_c_husky", "a_c_westy", "a_c_retriever", "a_c_rottweiler", "a_c_shepherd" }

local animations = {
	{ dictionary = "creatures@rottweiler@amb@sleep_in_kennel@",   			animation = "sleep_in_kennel",			raceneeded = false, stopdictionary = "creatures@rottweiler@amb@sleep_in_kennel@",		stopanimation = "exit_kennel", 	label = "Lay Down", 		race = {"rottweiler","shepherd"}},
	{ dictionary = "@amb@world_dog_barking@idle_a", 						animation = "idle_a",					raceneeded = true,  stopdictionary = "@amb@world_dog_barking@exit",						stopanimation = "exit", 		label = "Bark", 			race = {"pug","rottweiler", "retriever"}},
	{ dictionary = "@amb@world_dog_sitting@base", 							animation = "base",						raceneeded = true,  stopdictionary = "@amb@world_dog_sitting@exit",						stopanimation = "exit", 		label = "Sit", 				race = {"pug", "rottweiler", "retriever"}},
	{ dictionary = "@amb@world_dog_sitting@idle_a", 						animation = "idle_a",					raceneeded = true,  stopdictionary = "@amb@world_dog_sitting@exit",						stopanimation = "exit", 		label = "Itch",				race = {"pug", "rottweiler", "retriever"}},
	{ dictionary = "missfra0_chop_find", 									animation = "chop_bark_at_ballas",		raceneeded = false, stopdictionary = "creatures@rottweiler@amb@world_dog_barking@exit", stopanimation = "exit", 		label = "Bark", 			race = {"shepherd"}},
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@base", 		animation = "base",						raceneeded = false, stopdictionary = "creatures@rottweiler@amb@world_dog_sitting@exit", stopanimation = "exit", 		label = "Sit", 				race = {"shepherd"}},
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@idle_a", 	animation = "idle_a",					raceneeded = false, stopdictionary = "creatures@rottweiler@amb@world_dog_sitting@exit", stopanimation = "exit", 		label = "Itch",				race = {"shepherd"}},
	{ dictionary = "@indication@", 											animation = "indicate_high",			raceneeded = true,  stopdictionary = "@amb@world_dog_barking@exit",						stopanimation = "exit", 		label = "Draw Attention", 	race = {"rottweiler"}},
	{ dictionary = "@melee@", 												animation = "dog_takedown_from_back",	raceneeded = true,  stopdictionary = "@amb@world_dog_barking@exit",						stopanimation = "exit", 		label = "Attack", 			race = {"rottweiler"}},
	{ dictionary = "@melee@streamed_taunts@", 								animation = "taunt_01",					raceneeded = true,  stopdictionary = "@amb@world_dog_barking@exit",						stopanimation = "exit", 		label = "Taunt", 			race = {"rottweiler"}}	
}

function playAnimation(dictionary, animation)
	if emotePlaying then
		cancelEmote()
	end

	RequestAnimDict(dictionary)
	while not HasAnimDictLoaded(dictionary) do
		Wait(1)
	end
	TaskPlayAnim(GetPlayerPed(-1), dictionary, animation, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	emotePlaying = true
end

function cancelEmote()
	local dict 

	if lastanimation.raceneeded then
		dict = "creatures@" ..  currentped .. lastanimation.stopdictionary
	else
		dict = lastanimation.stopdictionary
	end
	
	RequestAnimDict(dict)
	
	while not HasAnimDictLoaded(dict) do
		Wait(1)
	end
	
	TaskPlayAnim(GetPlayerPed(-1), dict, lastanimation.stopanimation, 10.0, 10.0, 1000, 2, 0, 0, 0, 0)
	
	emotePlaying = false
	lastanimation = nil;		
end



function OpenEmoteMenu()
	ESX.UI.Menu.CloseAll();
	
	local realanimations = {}
	
	for i = 1, #animations, 1 do
		local races =  animations[i].race;
		local found = false;
		

		for y = 1, #races, 1 do
			
			if races[y] == currentped then
				found = true;
				break;	
			else 
				found = false;
			end			
		end

		if found == true then
			Citizen.Wait(0)
			table.insert(realanimations,animations[i])
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "dogemote", {
		title = "Choose an emote",
		align = "left",
		elements = realanimations
	}, function(data, menu)
	
		local dict
		if data.current.raceneeded then
			dict = "creatures@".. currentped .. data.current.dictionary
		else
			dict = data.current.dictionary
		end

		lastanimation = data.current
		
		playAnimation(dict, data.current.animation)
		menu.close()
	end, function(data, menu)
		menu.close();
	end);

end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
            if (IsControlPressed(0, 22)) then
				
				if emotePlaying and lastanimation ~= nil then
					cancelEmote()
				end	

		    end
		end
	end
)

--endregion

RegisterCommand("playasped", function()

	ESX.TriggerServerCallback("play_as_ped:getData", function(data)
		local elements = nil;
		if data.group == "superadmin" then
			elements = {
				 {label = "Human", ped = "human"},
				 {label = "Cat", ped = "a_c_cat_01"},
				 {label = "Pug",ped = "a_c_pug"},
				 {label = "Poodle",ped = "a_c_poodle"},
				 {label = 'Husky', ped = "a_c_husky"},
			     {label = "Westy",ped = "a_c_westy"},
				 {label = "Retriever",ped = "a_c_retriever"},
				 {label = "Shepherd",ped = "a_c_shepherd"},
				 {label = "Rottweiler",ped = "a_c_rottweiler"},
				 {label = "Pigeon",ped = "a_c_pigeon"},
				 {label = "Bird",ped = "a_c_chickenhawk"},
				 {label = "Seagul",ped = "a_c_seagull"},
				 {label = "Deer",ped = "a_c_deer"},
				
				 {label = "Coyote",ped = "a_c_coyote"},
				 {label = "Rabbit",ped = "a_c_rabbit_01"},
				 
				 {label = "Panther",ped = "a_c_panther"},
				 {label = "Jesus v. N.",ped = "u_m_m_jesus_01"},
				 {label = "Juggernaut",ped = "u_m_y_juggernaut_01"},
				 {label = "Pogo",ped = "u_m_y_pogo_01"},
				 {label = "Prisoner",ped = "u_m_y_prisoner_01"}
			};
		else
			for i = 1, #dog_whitelisted_identifier do
				if dog_whitelisted_identifier[i] == data.identifier then
					elements = {
						{label = "Human",ped = "human"},
						{label = "Pug",ped = "a_c_pug"},
						{label = "Husky",ped = "a_c_husky"},
						{label = "Poodle",ped = "a_c_poodle"},
						{label = "Westy",ped = "a_c_westy"},
						{label = "Retriever",ped = "a_c_retriever"},
						{label = "Shepherd",ped = "a_c_shepherd"},
						{label = "Rottweiler",ped = "a_c_rottweiler"}
					};
				end;
			end;
			for i = 1, #cat_whitelisted_identifier do
				if cat_whitelisted_identifier[i] == data.identifier then
					elements = {
						{label = "Human", ped = "human" },
						{label = "Cat", ped = "a_c_cat_01"}
					};
				end;
			end;
		end;

		local currentHealth = GetEntityHealth(PlayerPedId())

		ESX.UI.Menu.CloseAll();
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ped_menu", {
			title = "Choose a lifeform",
			align = "left",
			elements = elements
		}, function(data, menu)
			if data.current.ped == "human" then
				lastanimation = nil;
				lastdictionary = nil;
				ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
					local isMale = skin.sex == 0;
					local model = nil;
					if isMale then
						model = "mp_m_freemode_01";
					else
						model = "mp_f_freemode_01";
					end;
					RequestModel(model);
					while not HasModelLoaded(model) do
						Citizen.Wait(0);
					end;
					SetPlayerModel(PlayerPedId(), model);
					TriggerEvent("skinchanger:loadDefaultModel", isMale, function()
						TriggerEvent("skinchanger:loadSkin", skin);
						TriggerEvent("esx:restoreLoadout");
					end);
				end);

				SetEntityHealth(PlayerPedId(), currentHealth)
			else
				RequestModel(data.current.ped);

				while not HasModelLoaded(data.current.ped) do
					Citizen.Wait(0);
				end;

				SetPlayerModel(PlayerId(), GetHashKey(data.current.ped))
				SetPedDefaultComponentVariation(PlayerPedId())
				SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
				
			end;
			currentped = data.current.label:lower();
			menu.close()
		end, function(data, menu)
			menu.close();
		end);
	end);
end);


AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end	
	lastanimation = nil;
	ESX.UI.Menu.CloseAll();	
  end)

  --region Helper

  function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function isDog()
	local playerModel = GetEntityModel(GetPlayerPed(-1))
	for i=1, #dogModels, 1 do
		if GetHashKey(dogModels[i]) == playerModel then
			return true
		end
	end
	return false
end

  --endregion