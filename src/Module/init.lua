-- Created by "Stenimated" / Stefan Higraff

local HttpService = game:GetService("HttpService")

--//

local API_DUMP_URL = 'https://anaminus.github.io/rbx/json/api/latest.json'
local RETRY_DELAY = 1

local DEBUG = true

local ClassInstance = {}

--//

local function Main()
	local success, resp

	if DEBUG then
		warn("Getting api")
	end

	repeat

		success, resp = pcall(HttpService.GetAsync, HttpService, API_DUMP_URL)

		if success then
			resp = HttpService:JSONDecode(resp)
			break
		end


		warn("Failed to get API dump: " .. resp)
		task.wait(RETRY_DELAY)
	until success

	for _, v in ipairs(resp) do
		local type:string, Class:string, Name:string = v.type, v.Class, v.Name

		if type == "Property" then
			if ClassInstance[Class] then
				table.insert(ClassInstance[Class], Name)
				continue
			end
			ClassInstance[Class] = {}
			table.insert(ClassInstance[Class], Name)
		end
	end


	if DEBUG then
		warn("Fetched Properties")
	end
end
Main()

--//

local module = {}

function module.GetProperties(Instance:Instance)
	if not ClassInstance[Instance.ClassName] then
		warn(string.format("%s did not have any properties", Instance.ClassName))
		return {} 
	end
	return ClassInstance[Instance.ClassName]
end


return module