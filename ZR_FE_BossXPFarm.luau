--[[
    Zombie Rush Vulnerability Report
    Discovered by 4RR6R

    This script demonstrates a server-side validation flaw in the WeaponEvent damage calculation system
    This allows manipulation of damage attribution logic, potentially enabling unintended XP gain without properly reducing boss health

    Status: Functional

    Created for security research and responsible disclosure purposes only
]]

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local originalNamecall; originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self : Instance, ... : any) : any
	local arguments = table.pack(...)
	local namecallmethod = getnamecallmethod()
	if not checkcaller() then
		if self.Name == "WeaponEvent" and namecallmethod == "FireServer" then
			for index in arguments[1].HumanoidTables do
			    if arguments[1].HumanoidTables[index].THumanoid.Parent and arguments[1].HumanoidTables[index].THumanoid.Parent:GetAttribute("Boss") then
                     -- Injects a controlled head hit value
			        arguments[1].HumanoidTables[index].HeadHits = 1
                    -- Injects a negative body hit value
                    -- Used to observe how the server processes
                    -- mixed-sign damage inputs
			        arguments[1].HumanoidTables[index].BodyHits = -1.5
			    end
			end
		end
	end
	setnamecallmethod(namecallmethod)
	return originalNamecall(self, table.unpack(arguments, 1, arguments.n))
end))
