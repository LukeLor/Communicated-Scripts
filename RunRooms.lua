local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local RENDER_URL = "https://communicated-scripts-main.onrender.com/"
local ROOM_ID = math.random(1,999999999)

local lastDataString = ""
local activeHostName = nil
local activeHostId = 0

local function claimHostRole(customPayload)
	local payload = customPayload or {}
	payload.HostName = LocalPlayer.Name
	payload.HostId = LocalPlayer.UserId 
	payload.Timestamp = os.time()
	
	local jsonString = HttpService:JSONEncode(payload)
	pcall(function()
		game:HttpPost(RENDER_URL .. "/update?room=" .. ROOM_ID, jsonString, "application/json")
	end)
end

task.spawn(function()

    task.wait(math.random(1, 5)) 
	
	while true do
		local success, rawJson = pcall(function()
			return game:HttpGet(RENDER_URL .. "/get-sync?room=" .. ROOM_ID)
		end)
		
		if success and rawJson then
			
        if rawJson ~= lastDataString then
				lastDataString = rawJson
				
				local decodeSuccess, tableData = pcall(function()
					return HttpService:JSONDecode(rawJson)
				end)
				
				if decodeSuccess and tableData then
					-- CASE A: Room is completely empty or server just restarted
					if tableData.initialized == false then
						print("[ELECTION]: Room is empty. Claiming host position...")
						claimHostRole()
						
					-- CASE B: A host is already registered on the server
					elseif tableData.HostId then
						local serverHostId = tonumber(tableData.HostId) or 0
						local serverHostName = tableData.HostName or "Unknown"
						
						activeHostId = serverHostId
						activeHostName = serverHostName
						
						-- ELECTION TRIGGER: If your ID is higher than the server host's ID, depose them
						if LocalPlayer.UserId > serverHostId then
							print("[ELECTION]: My UserID (" .. LocalPlayer.UserId .. ") is higher than Host (" .. serverHostId .. "). Overwriting...")
							-- Retain existing custom payload data if needed, just overwrite the host identities
							tableData.HostName = LocalPlayer.Name
							tableData.HostId = LocalPlayer.UserId
							tableData.Timestamp = os.time()
							
							claimHostRole(tableData)
						else
							-- You are either the host, or your ID is lower (so you safely listen)
							if serverHostId == LocalPlayer.UserId then
								print("[STATUS]: You are the elected Host (Highest ID: " .. LocalPlayer.UserId .. ")")
							else
								print("[STATUS]: Current Host is " .. serverHostName .. " (ID: " .. serverHostId .. ")")
							end
						end
					end
				end
			end
		end
		
		task.wait(4) -- Polling rate optimized to prevent overwhelming Render with 50 clients
	end
end)
