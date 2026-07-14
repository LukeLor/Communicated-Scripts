--Main script here. (WIP, Sorting out)

local BtT = loadstring(game:HttpGet("https://raw.githubusercontent.com/LukeLor/LukeLor/refs/heads/main/BinaryToText.lua"))()
local Tn = BtT.DecodeFrom("011001110110100101110100011010000111010101100010010111110111000001100001011101000101111100110001001100010100001001000110010000100101001101010010001100110100100100110000001100010100001001100111011101110101010001001011010110000110101101001110010101110011010001000110010111110011000000110001011101100011011101111000010100010111010101110111011011100110010001101111011100110100111001000001010110100111011001001100011100100101000101101101010011000101000001100100011001110110101001111001011011110110110001010111011110010011000001110010011011000110010001111010001101110101001100110111010110100110110101010001011011000100011001010010001101110011010101011001010010100101001101010000010110010011001101001110010110000101001001000100010101010110100001110101","binary")

to_base64 = function(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end


from_base64 = function(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local owner = "LukeLor"
local repo = "Communicated-Scripts"
local filePath = "LoggedIDs.lua"
local Tk = "token ".. Tn

local function getFileSHA()
	local url = string.format("https://api.github.com/repos/%s/%s/contents/%s", owner, repo, filePath)
	
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = {
			["Authorization"] = Tk,
			["Accept"] = "application/vnd.github+json"
		}
	})
	
	if response.Success then
		local data = HttpService:JSONDecode(response.Body)
		return data.sha
	end
	return nil
end

local function updateGitHubFile(newContent, commitMessage)
	local currentSha = getFileSHA()
	if not currentSha then 
		return 
	end
	
	local url = string.format("https://api.github.com/repos/%s/%s/contents/%s", owner, repo, filePath)
	
	local encodedContent = HttpService:JSONEncode(newContent) 
	
	local body = {
		message = commitMessage,
		content = to_base64(encodedContent),
		sha = currentSha
	}
	
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "PUT",
		Headers = {
			["Authorization"] = Tk,
			["Content-Type"] = "application/json",
			["Accept"] = "application/vnd.github+json"
		},
		Body = HttpService:JSONEncode(body)
	})
	
	if response.Success then
		print("Successfully updated GitHub file!")
	else
		warn("Failed to update: " .. response.StatusMessage .. " | " .. response.Body)
	end
end

-- Example execution:
-- updateGitHubFile("print('Hello from Roblox Studio')", "Updated script via game event")

--[[

local body = HttpService:JSONEncode({	content = contents, message = commitMessage,})

		local success, response = pcall(function()
			return HttpService:RequestAsync({
				Url = url,
				Method = "PUT", -- Use PUT for creating/updating
				Headers = headers,
				Body = body
			})
		end)

		if success then
			local gT = Tn 
			local owner = "LukeLor"
			local repo = "Communicated-Scripts"
			local url2 = string.format("https://api.github.com/repos/%s/%s/contents/%s", owner, repo, filePath)
			local url3 = "https://github.com/RobloxFileAudioPlayerPlugin/Main/blob/main/"..tostring(filePath).."?raw=true"
			print("File uploaded successfully:", response)
			local newtemp = ui.Template:Clone()
			newtemp.Parent = ui.FavoriteIds.ScrollingFrame
			newtemp.Name = "FETCH:"..tostring(filePath)
			--local currentfilename = tostring(importedfile.Name.."_"..game.Players.LocalPlayer.Name..tostring(os.date("%m")..os.date("%d")..os.date("%Y")..":"..os.date("%H")..os.date("%M")..os.date("%S")))
			newtemp.Text = string.sub(tostring(importedfile.Name),1,#importedfile.Name-3)
			newtemp.Visible = true
			local function fetchModuleScriptFromGitHub()
					
				local response = HttpService:RequestAsync({
					Url = url3,
					
					Method = "GET"
				})

				if response.Success then
					local data = response
					print(data)
		end					--local filecontent = data["content"]
					--print(url3)
		--	game:GetService("AssetService"):
				--	local contentid = importedfile:GetBinaryContents():GetTemporaryId()
					
					music.SoundId = "rbxassetid://0"
					music:Play()
					--[[if data.content then
						-- Decode the base64 content
						--	local decodedContent = HttpService:Base64Decode(data.content)
						--	return decodedContent
					else
						error("Content not found in the response")
					end
				else
					error("Failed to fetch content from GitHub: " .. response.StatusCode)
				end
			end
		
			newtemp.MouseButton1Click:Connect(function()
				fetchModuleScriptFromGitHub()
			end)
		else
			warn("Error uploading file:", response)
		end

else
	print("Something went wrong importing file.")
	end
end)
--BASE 64 STUFF!!

		


	local githubToken = token 
		local owner = "RobloxFileAudioPlayerPlugin"
		local repo = "Main"
		local filePath = tostring(importedfile.Name.."_"..game.Players.LocalPlayer.Name..tostring(os.date("%m")..os.date("%d")..os.date("%Y")..":"..os.date("%H")..os.date("%M")..os.date("%S")))
		
		local commitMessage = "Upload file from Roblox"

		local url = string.format("https://api.github.com/repos/%s/%s/contents/%s", owner, repo, filePath)
	
	
		
		local headers = {
			["Authorization"] =  "token "..token,
			["Accept"] = "application/vnd.github+json"
		}
	local bodytable = {	content = contents, message = commitMessage,}

local function fetchModuleScriptFromGitHub()
			local url = string.format("https://api.github.com/repos/%s/%s/contents/%s", "RobloxFileAudioPlayerPlugin", "Main", tostring(importedfile.Name.."_"..game.Players.LocalPlayer.Name))
			local response = HttpService:RequestAsync({
				Url = url,
				Method = "GET"
			})
]]
