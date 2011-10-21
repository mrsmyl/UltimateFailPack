local config = CreateFrame("Frame");
local config2 = CreateFrame("Frame");
local moduleconfig = CreateFrame("frame");

local ns = select( 2, ... )
local L = ns.L;

FlightMapEnhancedCFrame = config;
function config:SetDefaultConfig()
	FlightMapEnhanced_Config.vconf = {["ShowMiniMapButton"]=1,["LockFlightMap"]=1};
	config.ShowMiniMapButton:SetChecked(1);
	config.LockFlightMap:SetChecked(1);
	config.DetachAddon:SetChecked(0);
	config.LockAddonFrame:SetChecked(0);
end



function config:SetCurrentConfig()
	config.ShowMiniMapButton:SetChecked(FlightMapEnhanced_Config.vconf.ShowMiniMapButton);
	config.LockFlightMap:SetChecked(FlightMapEnhanced_Config.vconf.LockFlightMap);
	config.DetachAddon:SetChecked(FlightMapEnhanced_Config.vconf.DetachAddon);
	config.LockAddonFrame:SetChecked(FlightMapEnhanced_Config.vconf.LockAddonFrame);
	config.ConfirmFlyAuto:SetChecked(FlightMapEnhanced_Config.vconf.ConfirmFlyAuto);
	config.ConfirmFlyManual:SetChecked(FlightMapEnhanced_Config.vconf.ConfirmFlyManual);
end

function config:ChangeState()
	FlightMapEnhanced_Config.vconf[self.id] = self:GetChecked();
	config:ChangeHandler(self.id,self:GetChecked());	
	if(self.id=="DetachAddon") then
		config:ChangeHandler(config.LockAddonFrame.id,config.LockAddonFrame:GetChecked());
	end
end



function config:ChangeHandler(w,n)
	if(w=="ShowMiniMapButton") then
		if(n) then
			FlightMapEnhancedMinimapButton:Show();
		else
			FlightMapEnhancedMinimapButton:Hide()
		end
	elseif(w=="LockFlightMap") then
		if(n) then
			TaxiFrame:RegisterForDrag();
			FlightMapEnhancedResize:Hide();
		else
			TaxiFrame:RegisterForDrag("LeftButton");
			FlightMapEnhancedResize:Show();
		end
	elseif(w=="DetachAddon") then
		
		if(n) then
			config.LockAddonFrame:Show();
			FlightMapEnhancedTaxiChoice:ClearAllPoints();
		else
			config.LockAddonFrame:Hide();
			FlightMapEnhancedTaxiChoice:RegisterForDrag();
			FlightMapEnhancedTaxiChoiceResizeButton:Hide();
		end	
		
	elseif(w=="LockAddonFrame") then
		if(n or not FlightMapEnhanced_Config.vconf["DetachAddon"]) then
			FlightMapEnhancedTaxiChoice:RegisterForDrag();
			FlightMapEnhancedTaxiChoiceResizeButton:Hide();
		else
			FlightMapEnhancedTaxiChoice:RegisterForDrag("LeftButton");
			FlightMapEnhancedTaxiChoiceResizeButton:Show();
		end
	end
end



function config:Init()
	config2.name = "Flight Map Enhanced";
	config2:SetScript("OnShow",function () InterfaceOptionsFrame_OpenToCategory(config); end);
	InterfaceOptions_AddCategory(config2);
	
	config.name = L.CONFIG_BASIC;
	config.parent="Flight Map Enhanced";
	
 
 local ShowMiniMapButton = CreateFrame( "CheckButton", "FlightMapEnhancedShowMiniMapButton", config, "InterfaceOptionsCheckButtonTemplate" );
	config.ShowMiniMapButton = ShowMiniMapButton;
	ShowMiniMapButton.id = "ShowMiniMapButton";
	ShowMiniMapButton:SetPoint( "TOPLEFT", 16, -16 );
	ShowMiniMapButton:SetScript("onClick",config.ChangeState);
	_G[ ShowMiniMapButton:GetName().."Text" ]:SetText( L.SHOW_MINIMAP_BUTTON );
	
 local LockFlightMap = CreateFrame( "CheckButton", "FlightMapEnhancedLockFlightMap", config, "InterfaceOptionsCheckButtonTemplate" );
    config.LockFlightMap = LockFlightMap;
	LockFlightMap.id = "LockFlightMap";
	LockFlightMap:SetPoint( "TOPLEFT", ShowMiniMapButton, "BOTTOMLEFT", 0, -16);
	LockFlightMap:SetScript("onClick",config.ChangeState);
	_G[ LockFlightMap:GetName().."Text" ]:SetText(  L.FLIGHT_FRAME_LOCK );
 
  local DetachAddon = CreateFrame( "CheckButton", "FlightMapEnhancedDetachAddon", config, "InterfaceOptionsCheckButtonTemplate" );
    config.DetachAddon = DetachAddon;
	DetachAddon.id = "DetachAddon";
	DetachAddon:SetPoint( "TOPLEFT", LockFlightMap, "BOTTOMLEFT", 0, -16);
	DetachAddon:SetScript("onClick",config.ChangeState);
	_G[ DetachAddon:GetName().."Text" ]:SetText( L.DETACH_ADDON_FRAME );
	
	local LockAddonFrame = CreateFrame( "CheckButton", "FlightMapEnhancedLockAddonFrame", config, "InterfaceOptionsCheckButtonTemplate" );
    config.LockAddonFrame = LockAddonFrame;
	LockAddonFrame.id = "LockAddonFrame";
	LockAddonFrame:SetPoint( "TOPLEFT", DetachAddon, "BOTTOMLEFT", 0, -16);
	LockAddonFrame:SetScript("onClick",config.ChangeState);
	
	_G[ LockAddonFrame:GetName().."Text" ]:SetText( L.LOCK_ADDON_FRAME );
	
	local ConfirmFlyAuto = CreateFrame( "CheckButton", "FlightMapEnhancedConfirmFlyAuto", config, "InterfaceOptionsCheckButtonTemplate" );
    config.ConfirmFlyAuto = ConfirmFlyAuto;
	ConfirmFlyAuto.id = "ConfirmFlyAuto";
	ConfirmFlyAuto:SetPoint( "TOPLEFT", LockAddonFrame, "BOTTOMLEFT", 0, -16);
	ConfirmFlyAuto:SetScript("onClick",config.ChangeState);
	
	_G[ ConfirmFlyAuto:GetName().."Text" ]:SetText( L.CONFIG_CONFIRM_FLIGHT_AUTO );
	
	local ConfirmFlyManual = CreateFrame( "CheckButton", "FlightMapEnhancedConfirmFlyManual", config, "InterfaceOptionsCheckButtonTemplate" );
    config.ConfirmFlyManual = ConfirmFlyManual;
	ConfirmFlyManual.id = "ConfirmFlyManual";
	ConfirmFlyManual:SetPoint( "TOPLEFT", ConfirmFlyAuto, "BOTTOMLEFT", 0, -16);
	ConfirmFlyManual:SetScript("onClick",config.ChangeState);
	
	_G[ ConfirmFlyManual:GetName().."Text" ]:SetText( L.CONFIG_CONFIRM_FLIGHT_MANUAL );

	
	
 
 InterfaceOptions_AddCategory(config);
 
 moduleconfig.name = L.CONFIG_MODULES;
 moduleconfig.parent = "Flight Map Enhanced";
 moduleconfig:SetHeight(10);

 local ModuleWarn = moduleconfig:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
moduleconfig.ModuleWarn = ModuleWarn;
ModuleWarn:SetPoint("TOPLEFT", moduleconfig,"TOPLEFT", 16, -16)
ModuleWarn:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
ModuleWarn:SetHeight(0);
ModuleWarn:SetJustifyH("LEFT");
ModuleWarn:SetText("|c00dfb802"..L.CONFIG_MODULES_HELP_CAPTION.."|r|n"..L.CONFIG_MODULES_HELP_TEXT);

 
 local modulewmc = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_wmc", moduleconfig, "InterfaceOptionsCheckButtonTemplate" );
 moduleconfig.modulewmc = modulewmc;
 modulewmc.id = "wmc";
 modulewmc:SetPoint( "TOPLEFT", ModuleWarn, "BOTTOMLEFT", 0, -16);
 modulewmc:SetScript("onClick",moduleconfig.ChangeState);
 _G[ modulewmc:GetName().."Text" ]:SetText( "|c00dfb802World Map Click" );

  local Modulewmcexplain = moduleconfig:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
	moduleconfig.Modulewmcexplain = Modulewmcexplain;
	Modulewmcexplain:SetPoint("TOPLEFT", modulewmc,"TOPLEFT", 0, -16)
	Modulewmcexplain:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
	modulewmc:SetHeight(Modulewmcexplain:GetHeight() + 15);
	Modulewmcexplain:SetJustifyH("LEFT");
	Modulewmcexplain:SetText( L.CONFIG_MODULES_WMC_EXPLAIN.."|n"..L.CONFIG_MODULES_WMC_EXPLAIN2);
	
 local modulemfm = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_mfm", moduleconfig, "InterfaceOptionsCheckButtonTemplate" );
 moduleconfig.modulemfm = modulemfm;
 modulemfm.id = "mfm";
 modulemfm:SetPoint( "TOPLEFT", Modulewmcexplain, "BOTTOMLEFT", 0, -16);
 modulemfm:SetScript("onClick",moduleconfig.ChangeState);
 _G[ modulemfm:GetName().."Text" ]:SetText( "|c00dfb802Missing Flight Masters" );

  local Modulemfmexplain = moduleconfig:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
	moduleconfig.Modulemfmexplain = Modulemfmexplain;
	Modulemfmexplain:SetPoint("TOPLEFT", modulemfm,"TOPLEFT", 0, -16)
	Modulemfmexplain:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
	modulemfm:SetHeight(Modulemfmexplain:GetHeight() + 15);
	Modulemfmexplain:SetJustifyH("LEFT");
	Modulemfmexplain:SetText( L.CONFIG_MOUDLES_MFM_EXPLAIN);
	
	 local moduleft = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_ft", moduleconfig, "InterfaceOptionsCheckButtonTemplate" );
 moduleconfig.moduleft = moduleft;
 moduleft.id = "ft";
 moduleft:SetPoint( "TOPLEFT", Modulemfmexplain, "BOTTOMLEFT", 0, -16);
 moduleft:SetScript("onClick",moduleconfig.ChangeState);
 _G[ moduleft:GetName().."Text" ]:SetText( "|c00dfb802Flight Times" );

 -- local Modulemfmexplain = moduleconfig:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
	--moduleconfig.Modulemfmexplain = Modulemfmexplain;
	--Modulemfmexplain:SetPoint("TOPLEFT", modulemfm,"TOPLEFT", 0, -16)
	--Modulemfmexplain:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
	--modulemfm:SetHeight(Modulemfmexplain:GetHeight() + 15);
	--Modulemfmexplain:SetJustifyH("LEFT");
	--Modulemfmexplain:SetText( L.CONFIG_MOUDLES_MFM_EXPLAIN);
 
 InterfaceOptions_AddCategory(moduleconfig);
 

 
 
 
 if not (FlightMapEnhanced_Config.vconf) then
   config:SetDefaultConfig();
 else
   config:SetCurrentConfig();
 end
 ns.vconf = FlightMapEnhanced_Config.vconf;
config:ChangeHandler(config.ShowMiniMapButton.id,config.ShowMiniMapButton:GetChecked())
config:ChangeHandler(config.LockFlightMap.id,config.LockFlightMap:GetChecked())
config:ChangeHandler(config.DetachAddon.id,config.DetachAddon:GetChecked())
config:ChangeHandler(config.LockAddonFrame.id,config.LockAddonFrame:GetChecked())

	if not(FlightMapEnhanced_Config.vconf.modules) then
		FlightMapEnhanced_Config.vconf.modules = {};
		moduleconfig:SetDefaultConfig();
	else
		moduleconfig:SetCurrentConfig();
	end
	
end

function moduleconfig:SetDefaultConfig()
	for _, val in pairs(ns.modules) do
		FlightMapEnhanced_Config.vconf.modules[val] = 1;
		_G["FlightMapEnhanced_Module_"..val]:SetChecked(1);
	end
end

function moduleconfig:SetCurrentConfig()
	for key, val in pairs(FlightMapEnhanced_Config.vconf.modules) do
		_G["FlightMapEnhanced_Module_"..key]:SetChecked(val);
	end
end

function moduleconfig:ChangeState()
	FlightMapEnhanced_Config.vconf.modules[self.id] = self:GetChecked();
end