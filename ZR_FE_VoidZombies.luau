--[[
    Zombie Rush Vulnerability Proof of Concept
    Discovered by 4RR6R

    This script demonstrates a server-side validation issue related to melee hit direction handling that can cause zombie entities to be invalidated (voided) when struck with a sword.

    This issue should be fixed in a future update.

    Status: Functional

    Created for security research and responsible disclosure purposes only
]]

local originalNamecall; originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self : Instance, ... : any) : any
	local arguments = table.pack(...)
	local traceback = debug.traceback()
	local namecallmethod = getnamecallmethod()
	if not checkcaller() then
		if self.Name == "RemoteFunction" and namecallmethod == "InvokeServer" and string.find(traceback, "MeleeController", 1, true) then
			arguments[1].Direction = Vector3.zero / 0 -- Vulnerability is here -> nan
		end
	end
    setnamecallmethod(namecallmethod)
	return originalNamecall(self, ...)
end))
