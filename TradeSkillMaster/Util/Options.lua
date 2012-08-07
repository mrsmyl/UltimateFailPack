-- This file contains all the code for the stuff that shows under the "Status" icon in the main TSM window.

local TSM = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

local lib = TSMAPI
local CYAN = "|cff99ffff"

local function LoadHelpPage(parent)
	local page = {
		{
			type = "ScrollFrame",
			layout = "flow",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["TSM Help Resources"],
					children = {
						{
							type = "Label",
							text = CYAN .. L["Need help with TSM? Check out the following resources!"] .. "\n\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = L["Official TradeSkillMaster Forum:"] .. " |cffffd200http://stormspire.net/official-tradeskillmaster-development-forum/|r\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = L["TradeSkillMaster IRC Channel:"] .. " |cffffd200http://tradeskillmaster.com/index.php/chat|r\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = L["TradeSkillMaster Website:"] .. " |cffffd200http://tradeskillmaster.com|r\n",
							fullWidth = true,
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = "TradeSkillMaster Module Info",
					children = {
						{
							type = "Label",
							text = L["TradeSkillMaster currently has 10 modules (not including the core addon) each of which can be used completely independantly of the others and have unique features."] .. "\n\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Accounting" .. "|r - " .. L["Keeps track of all your sales and purchases from the auction house allowing you to easily track your income and expendatures and make sure you're turning a profit."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "AuctionDB" .. "|r - " .. L["Performs scans of the auction house and calculates the market value of items as well as the minimum buyout. This information can be shown in items' tooltips as well as used by other modules."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Auctioning" .. "|r - " .. L["Posts and cancels your auctions to / from the auction house accorder to pre-set rules. Also, this module can show you markets which are ripe for being reset for a profit."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Crafting" .. "|r - " .. L["Allows you to build a queue of crafts that will produce a profitable, see what materials you need to obtain, and actually craft the items."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Destroying" .. "|r - " .. L["Mills, prospects, and disenchants items at super speed!"] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "ItemTracker" .. "|r - " .. L["Tracks and manages your inventory across multiple characters including your bags, bank, and guild bank."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Mailing" .. "|r - " .. L["Allows you to quickly and easily empty your mailbox as well as automatically send items to other characters with the single click of a button."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Shopping" .. "|r - " .. L["Provides interfaces for efficiently searching for items on the auction house. When an item is found, it can easily be bought, canceled (if it's yours), or even posted from your bags."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "Warehousing" .. "|r - " .. L["Manages your inventory by allowing you to easily move stuff between your bags, bank, and guild bank."] .. "\n",
							fullWidth = true,
						},
						{
							type = "Label",
							text = CYAN .. "WoWuction" .. "|r - " .. L["Allows you to use data from http://wowuction.com in other TSM modules and view its various price points in your item tooltips."] .. "\n",
							fullWidth = true,
						},
					},
				},
			},
		},
	}

	lib:BuildPage(parent, page)
end

local function LoadStatusPage(parent)
	local page = {
		{
			type = "ScrollFrame",
			layout = "flow",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Installed Modules"],
					children = {},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Credits"],
					children = {
						{
							type = "Label",
							text = L["TradeSkillMaster Team:"],
							relativeWidth = 1,
							fontObject = GameFontHighlightLarge,
						},
						{
							type = "Label",
							text = "|cffffbb00"..L["Lead Developer and Project Manager:"].."|r Sapu94",
							relativeWidth = 1,
						},
						{
							type = "Label",
							text = "|cffffbb00"..L["Active Developers:"].."|r Geemoney, Drethic, Fancyclaps",
							relativeWidth = 1,
						},
						{
							type = "Label",
							text = "|cffffbb00"..L["Testers (Special Thanks):"].."|r Acry, Vith, Quietstrm07, Cryan",
							relativeWidth = 1,
						},
						{
							type = "Label",
							text = "|cffffbb00"..L["Past Contributors:"].."|r Cente, Mischanix, Xubera, cduhn, cjo20",
							relativeWidth = 1,
						},
						-- {
							-- type = "Label",
							-- text = "|cffffbb00"..L["Translators:"].."|r ".."Pataya"..CYAN.."(frFR)".."|r"..", rachelka"..CYAN.."(ruRU)".."|r"..", Duco"..CYAN.."(deDE)".."|r"..", Wolf15"..CYAN.."(esMX)".."|r"..", MauleR"..CYAN.."(ruRU)".."|r"..", Kennyal"..CYAN.."(deDE)".."|r"..", Flyhard"..CYAN.."(deDE)".."|r"..", trevyn"..CYAN.."(deDE)".."|r"..", foxdodo"..CYAN.."(zhCN)".."|r"..", wyf115"..CYAN.."(zhTW)".."|r"..", and many others!",
							-- relativeWidth = 1,
						-- },
					},
				},
			},
		},
	}
	
	for i, module in ipairs(TSM.registeredModules) do
		local moduleWidgets = {
			type = "SimpleGroup",
			relativeWidth = 0.49,
			layout = "list",
			children = {
				{
					type = "Label",
					text = "|cffffbb00"..L["Module:"].."|r"..module.name,
					fullWidth = true,
					fontObject = GameFontNormalLarge,
				},
				{
					type = "Label",
					text = "|cffffbb00"..L["Version:"].."|r"..module.version,
					fullWidth = true,
				},
				{
					type = "Label",
					text = "|cffffbb00"..L["Author(s):"].."|r"..module.authors,
					fullWidth = true,
				},
				{
					type = "Label",
					text = "|cffffbb00"..L["Description:"].."|r"..module.desc,
					fullWidth = true,
				},
			},
		}
		
		if i > 2 then
			tinsert(moduleWidgets.children, 1, {type = "Spacer"})
		end
		tinsert(page[1].children[1].children, moduleWidgets)
	end
	
	if #TSM.registeredModules == 1 then
		local warningText = {
			type = "Label",
			text = "\n|cffff0000"..L["No modules are currently loaded.  Enable or download some for full functionality!"].."\n\n|r",
			fullWidth = true,
			fontObject = GameFontNormalLarge,
		}
		tinsert(page[1].children[1].children, warningText)
		
		local warningText2 = {
			type = "Label",
			text = "\n|cffff0000"..format(L["Visit %s for information about the different TradeSkillMaster modules as well as download links."], "http://www.curse.com/addons/wow/tradeskill-master").."|r",
			fullWidth = true,
			fontObject = GameFontNormalLarge,
		}
		tinsert(page[1].children[1].children, warningText2)
	end
	
	lib:BuildPage(parent, page)
end

local function LoadOptionsPage(parent)
	local page = {
		{
			type = "ScrollFrame",
			layout = "flow",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Settings"],
					children = {
						{
							type = "CheckBox",
							label = L["Hide Minimap Icon"],
							quickCBInfo = {TSM.db.profile.minimapIcon, "hide"},
							relativeWidth = 0.5,
							callback = function(_,_,value)
									if value then
										TSM.LDBIcon:Hide("TradeSkillMaster")
									else
										TSM.LDBIcon:Show("TradeSkillMaster")
									end
								end,
						},
						{
							type = "Button",
							text = L["New Tip"],
							relativeWidth = 0.5,
							callback = lib.ForceNewTip,
							tooltip = L["Changes the tip showing at the bottom of the main TSM window."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Auction House Tab Settings"],
					children = {
						{
							type = "CheckBox",
							label = L["Make TSM Default Auction House Tab"],
							quickCBInfo = {TSM.db.profile, "isDefaultTab"},
							relativeWidth = 0.5,
						},
						{
							type = "CheckBox",
							label = L["Show Bids in Auction Results Table (Requires Reload)"],
							quickCBInfo = {TSM.db.profile, "showBids"},
							relativeWidth = 0.5,
							tooltip = L["If checked, all tables listing auctions will display the bid as well as the buyout of the auctions. This will not take effect immediately and may require a reload."],
						},
						{
							type = "CheckBox",
							label = L["Make Auction Frame Movable"],
							quickCBInfo = {TSM.db.profile, "auctionFrameMovable"},
							relativeWidth = 0.5,
							callback = function(_,_,value) AuctionFrame:SetMovable(value) end,
						},
						{
							type = "Slider",
							label = L["Auction Frame Scale"],
							value = TSM.db.profile.auctionFrameScale,
							isPercent = true,
							relativeWidth = 0.5,
							min = 0.1,
							max = 2,
							step = 0.05,
							callback = function(_,_,value)
									TSM.db.profile.auctionFrameScale = value
									if AuctionFrame then
										AuctionFrame:SetScale(value)
									end
								end,
							tooltip = L["Changes the size of the auction frame. The size of the detached TSM auction frame will always be the same as the main auction frame."],
						},
						{
							type = "CheckBox",
							label = L["Detach TSM Tab by Default"],
							quickCBInfo = {TSM.db.profile, "detachByDefault"},
							relativeWidth = 0.5,
						},
						{
							type = "CheckBox",
							label = L["Open All Bags with Auction House"],
							quickCBInfo = {TSM.db.profile, "openAllBags"},
							relativeWidth = 0.5,
							tooltip = L["If checked, your bags will be automatically opened when you open the auction house."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Auction House Tab Button Colors"],
					children = {
						{
							type = "Label",
							text = L["Use the options below to change the color of the various buttons used in the TSM auction house tab."],
							fullWidth = 1,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "ColorPicker",
							label = L["Feature Button Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.feature[1],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.feature[1].a
									TSM.db.profile.auctionButtonColors.feature[1] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Feature Highlight Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.feature[2],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.feature[2].a
									TSM.db.profile.auctionButtonColors.feature[2] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Feature Text Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.feature[3],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.feature[3].a
									TSM.db.profile.auctionButtonColors.feature[3] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "ColorPicker",
							label = L["Control Button Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.control[1],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.control[1].a
									TSM.db.profile.auctionButtonColors.control[1] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Control Highlight Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.control[2],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.control[2].a
									TSM.db.profile.auctionButtonColors.control[2] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Control Text Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.control[3],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.control[3].a
									TSM.db.profile.auctionButtonColors.control[3] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "ColorPicker",
							label = L["Action Button Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.action[1],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.action[1].a
									TSM.db.profile.auctionButtonColors.action[1] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Action Highlight Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.action[2],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.action[2].a
									TSM.db.profile.auctionButtonColors.action[2] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Action Text Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.action[3],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.action[3].a
									TSM.db.profile.auctionButtonColors.action[3] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "ColorPicker",
							label = L["Action2 Button Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.action2[1],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.action2[1].a
									TSM.db.profile.auctionButtonColors.action2[1] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Action2 Highlight Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.action2[2],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.action2[2].a
									TSM.db.profile.auctionButtonColors.action2[2] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Action2 Text Color"],
							relativeWidth = 0.33,
							value = TSM.db.profile.auctionButtonColors.action2[3],
							callback = function(_,_,r,g,b)
									local alpha = TSM.db.profile.auctionButtonColors.action2[3].a
									TSM.db.profile.auctionButtonColors.action2[3] = {r=r, g=g, b=b, a=alpha}
									TSM:UpdateAuctionButtonColors()
								end,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "Button",
							text = L["Restore Default Colors"],
							relativeWidth = 1,
							callback = function() TSM:RestoreDefaultColors() parent:SelectTab(3) end,
							tooltip = L["Restores all the color settings below to their default values."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Main TSM Frame Colors"],
					children = {
						{
							type = "Label",
							text = L["Use the options below to change the color of the various TSM frames including this frame as well as the Craft Management Window."],
							fullWidth = 1,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "ColorPicker",
							label = L["Backdrop Color"],
							relativeWidth = 0.5,
							hasAlpha = true,
							value = TSM.db.profile.frameBackdropColor,
							callback = function(_,_,r,g,b,a)
									TSM.db.profile.frameBackdropColor = {r=r, g=g, b=b, a=a}
									TSM:UpdateFrameColors()
								end,
						},
						{
							type = "ColorPicker",
							label = L["Border Color"],
							relativeWidth = 0.49,
							hasAlpha = true,
							value = TSM.db.profile.frameBorderColor,
							callback = function(_,_,r,g,b,a)
									TSM.db.profile.frameBorderColor = {r=r, g=g, b=b, a=a}
									TSM:UpdateFrameColors()
								end,
						},
					},
				},
			},
		},
	}
	
	lib:BuildPage(parent, page)
end


function TSM:LoadOptions(parent)
	lib:SetCurrentHelpInfo()
	lib:SetFrameSize(TSM.FRAME_WIDTH, TSM.FRAME_HEIGHT)
	
	local tg = AceGUI:Create("TSMTabGroup")
	tg:SetLayout("Fill")
	tg:SetFullWidth(true)
	tg:SetFullHeight(true)
	tg:SetTabs({{value=1, text=L["TSM Info / Help"]}, {value=2, text=L["Status / Credits"]}, {value=3, text=L["Options"]}})
	tg:SetCallback("OnGroupSelected", function(self,_,value)
		tg:ReleaseChildren()
		
		if value == 1 then
			LoadHelpPage(self)
		elseif value == 2 then
			LoadStatusPage(self)
		elseif value == 3 then
			LoadOptionsPage(self)
		end
	end)
	parent:AddChild(tg)
	tg:SelectTab(1)
end