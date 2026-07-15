local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local RENDER_URL = "https://communicated-scripts-main.onrender.com" 
local ROOM_ID = math.random(1, 999999999)

local lastDataString = ""
local activeHostName = nil
local activeHostId = 0

local function sendRequest(options)
    if not request then
        warn("Req unsupported...")
        return false, nil
    end
    
    local success, response = pcall(function()
        return request({
            Url = options.Url,
            Method = options.Method or "GET",
            Headers = options.Headers or { ["Content-Type"] = "application/json" },
            Body = options.Body
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        return true, response.Body
    end
    return false, nil
end

local function claimHostRole(customPayload)
	local payload = customPayload or {}
	payload.HostName = LocalPlayer.Name
	payload.HostId = LocalPlayer.UserId 
	payload.Timestamp = os.time()
	
	local jsonString = HttpService:JSONEncode(payload)
    
    local success = sendRequest({
        Url = RENDER_URL .. "/update?room=" .. ROOM_ID,
        Method = "POST",
        Body = jsonString
    })
    
    if not success then
        warn("Failed to send POST.")
    end
end

task.spawn(function()
    task.wait(math.random(1, 5)) 
	
	while true do
        
			local success, rawJson = sendRequest({
            Url = RENDER_URL .. "/get-sync?room=" .. ROOM_ID,
            Method = "GET"
        })
		
		if success and rawJson then
            if rawJson ~= lastDataString then
				lastDataString = rawJson
				
				local decodeSuccess, tableData = pcall(function()
					return HttpService:JSONDecode(rawJson)
				end)
				
				if decodeSuccess and tableData then
					
						if tableData.initialized == false then
						print("[ELECTION]: Room is empty. Claiming host position...")
						claimHostRole()
						
					elseif tableData.HostId then
						local serverHostId = tonumber(tableData.HostId) or 0
						local serverHostName = tableData.HostName or "Unknown"
						
						activeHostId = serverHostId
						activeHostName = serverHostName
						
						if LocalPlayer.UserId > serverHostId then
							print("[ELECTION]: My UserID (" .. LocalPlayer.UserId .. ") is higher than Host (" .. serverHostId .. "). Overwriting...")
							tableData.HostName = LocalPlayer.Name
							tableData.HostId = LocalPlayer.UserId
							tableData.Timestamp = os.time()
							
							claimHostRole(tableData)
						else
							if serverHostId == LocalPlayer.UserId then
								print("You are the Host (ID:" .. LocalPlayer.UserId .. ")")
							else
								print("Current Host is " .. serverHostName .. ", (ID: " .. serverHostId .. ")")
							end
								print("Currently in Room: "..tostring(ROOM_ID)..".")
						end
					end
				end
			end
		end
		
		task.wait(4)
		end
end)
