--Main script here.


--BASE 64 STUFF!!

module.to_base64 = function(data)
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


module.from_base64 = function(data)
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
return module

local function fetchModuleScriptFromGitHub()
			local url = string.format("https://api.github.com/repos/%s/%s/contents/%s", "RobloxFileAudioPlayerPlugin", "Main", tostring(importedfile.Name.."_"..game.Players.LocalPlayer.Name))
			local response = HttpService:RequestAsync({
				Url = url,
				Method = "GET"
			})
