local _,ns = ...;
local taxinodeinfos = {};
local firstshow = false;
local nextflight = nil;
local buttonsizechange = false;
local side,floc,flocn,flocd,flocdis,orig_taketaxinode;
local activetimers = {};
local nexttimercheck = 0.5;
local lasttaxicount = {0,0,0,0};
local doreminder = false;
local autotake = false;
ns.modules = {"wmc","mfm","ft"};
local L = ns.L;
FlightMapEnhanced_FlightLocations = {};
FlightMapEnhanced_FlightNames = {};
FlightMapEnhanced_Config = {};
FlightMapEnhancedCFrame = {};

function FlightMapEnhanced_OnLoad(self)
	self:RegisterEvent("TAXIMAP_OPENED");
	self:RegisterEvent("TAXIMAP_CLOSED");
	self:RegisterEvent("ADDON_LOADED");
	FlightMapEnhancedTaxiChoiceContainerScrollBar.Show = 
		function (self)
			
			FlightMapEnhancedTaxiChoiceContainer:SetPoint("BOTTOMRIGHT", FlightMapEnhancedTaxiChoice, "BOTTOMRIGHT", -23, 4);
			for _, button in next, _G["FlightMapEnhancedTaxiChoiceContainer"].buttons do
				button:SetWidth(FlightMapEnhancedTaxiChoice:GetWidth()-22);
			end
			FlightMapEnhancedTaxiChoiceContainer.scrollChild:SetWidth(FlightMapEnhancedTaxiChoice:GetWidth()-22);
			getmetatable(self).__index.Show(self);
		end
		
	FlightMapEnhancedTaxiChoiceContainerScrollBar.Hide = 
		function (self)
			
			FlightMapEnhancedTaxiChoiceContainer:SetPoint("BOTTOMRIGHT", FlightMapEnhancedTaxiChoice, "BOTTOMRIGHT", -4, 4);
			for _, button in next, FlightMapEnhancedTaxiChoiceContainer.buttons do
				button:SetWidth(FlightMapEnhancedTaxiChoice:GetWidth());
			end
			FlightMapEnhancedTaxiChoiceContainer.scrollChild:SetWidth(FlightMapEnhancedTaxiChoice:GetWidth());
			getmetatable(self).__index.Hide(self);
		end
	FlightMapEnhancedTaxiChoiceContainer.update = FlightMapEnhancedTaxiChoiceContainer_Update;
	_G["FlightMapEnhancedTaxiChoiceCollapseOnShowText"]:SetText(L.ALWAYS_COLLAPSE);
end

StaticPopupDialogs["FLIGHTMAPENHANCED_CONFIRMFLIGHT"] = {
  text = L.CONFIRM_FLIGHT,
  button1 = L.YES,
  button2 = L.NO,
  OnAccept = function(self,data)
	 if(ns.ft) then
		ns.ft:taketaxinode(data);
	 end
	 
	 orig_taketaxinode(data);
  end,
  timeout = 0,
  hideOnEscape = true,
}

local function taketaxinode(wn)
	local showconfirm = false;
	if(autotake==true and ns.vconf.ConfirmFlyAuto) then
		showconfirm = true;
	elseif(autotake==false and ns.vconf.ConfirmFlyManual) then
		showconfirm = true;
	end
	autotake = false;
	if(showconfirm==true) then
		local confirm = StaticPopup_Show("FLIGHTMAPENHANCED_CONFIRMFLIGHT",TaxiNodeName(wn));
		if(confirm) then
			confirm.data = wn;
		end
	else
		if(ns.ft) then
			ns.ft:taketaxinode(wn);
		end
		
		orig_taketaxinode(wn);
	end
	
end

function ns:timer(seconds,command)
	if(#activetimers==0) then
		FlightMapEnhancedTaxiChoice:SetScript("OnUpdate", function (self,elapsed) 
				nexttimercheck = nexttimercheck - elapsed;
				if(nexttimercheck > 0) then
					return;
				else
					nexttimercheck = 0.5;
				end
				for i,v in pairs(activetimers) do
					v["sleft"] = v["sleft"] - nexttimercheck;
					if(v["sleft"] <= 0) then
						loadstring(v["command"])();
						tremove(activetimers,i);
						if(#activetimers==0) then
							FlightMapEnhancedTaxiChoice:SetScript("OnUpdate",nil);
						end
					end
				end
			end);
	end
	tinsert(activetimers,{["sleft"]=seconds,["command"] = command});
end

local function CalcFlId(x,y,z)
	return tonumber(z..ceil(x*100)..ceil(y*100));

end

local function CalcDist(x1,x2,y1,y2)
	xd = x2-x1;
	yd = y2-y1;
	dist = sqrt(xd*xd + yd*yd)
	return dist;
end


function FlightMapEnhancedTaxiChoiceButton_OnLoad(self)
	local name = self:GetName();
	self.name = _G[name.."Name"];
	self.expandIcon = _G[name.."ExpandIcon"];
	self.highlight = _G[name.."Highlight"];
	self.stripe = _G[name.."Stripe"];
end

function FlightMapEnhanced_Show()
	if (not FlightMapEnhancedTaxiChoiceContainer.buttons) then
		HybridScrollFrame_CreateButtons(FlightMapEnhancedTaxiChoiceContainer, "FlightMapEnhancedButtonTemplate", 1, -2, "TOPLEFT", "TOPLEFT", 0, 0);
	end
	FlightMapEnhancedTaxiChoiceContainer_Update();
end

function FlightMapEnhanced_GetFlight(index)
	if( taxinodeinfos[index]) then
		return taxinodeinfos[index].name,taxinodeinfos[index].isheader,taxinodeinfos[index].flightid,taxinodeinfos[index].isexpanded,taxinodeinfos[index].discovered;
	else
		return nil;
	end
end

function FlightMapEnhancedTaxiChoiceContainer_Update()
	if (not FlightMapEnhancedTaxiChoiceContainer.buttons) then
		return;
	end
	local buttons = FlightMapEnhancedTaxiChoiceContainer.buttons;
	local button = buttons[1];
	local scrollFrame = FlightMapEnhancedTaxiChoiceContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local name, isHeader,flightpathid, isExpanded,discovered;
	local button, index;
	local hidebuttons = false;
	local displayedHeight=0;
	for i=1, numButtons do
		index = offset+i;
		name, isHeader,flightpathid, isExpanded,discovered = FlightMapEnhanced_GetFlight(index);

		button = buttons[i];
		
		if ( not name or name == "") then
			button:Hide();
		else
			if ( isHeader ) then
				button.categoryLeft:Show();
				button.categoryRight:Show();
				button.categoryMiddle:Show();
				button.expandIcon:Show();
				
				if ( isExpanded ) then
					hidebuttons = false;
					button.expandIcon:SetTexCoord(0.5625, 1, 0, 0.4375);
				else
					hidebuttons = true;
					button.expandIcon:SetTexCoord(0, 0.4375, 0, 0.4375);
				end
				button.highlight:SetTexture("Interface\\TokenFrame\\UI-TokenFrame-CategoryButton");
				button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -2);
				button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 2);
				button.name:SetText(name);
				button.name:SetFontObject("GameFontNormal");
				button.name:SetPoint("LEFT", 22, 0);
			else
				button.categoryLeft:Hide();
				button.categoryRight:Hide();
				button.categoryMiddle:Hide();
				button.expandIcon:Hide();
		
				button.highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
				button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
				button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
				if(discovered==true) then
					button.name:SetText(name);
				else
					button.name:SetText("|c00FF0000"..name);
				end
				button.name:SetPoint("LEFT", 11, 0);
				button.flightpath = flightpathid;
				button.name:SetFontObject("GameFontHighlight");
				
			end
			button.isHeader = isHeader;
			button.isExpanded = isExpanded;
			button.flightpathname = name;
			
			button:Show();
		end
		displayedHeight = displayedHeight + button:GetHeight();
	end
	local totalHeight = #taxinodeinfos * (button:GetHeight())+5;
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function FlightMapEnhancedTaxiChoiceButton_OnEnter(self)
	if not(self.isHeader) then
		TaxiNodeOnButtonEnter(_G["TaxiButton"..self.flightpath]);
	end
end

function FlightMapEnhancedTaxiChoiceButton_OnLeave(self)
	GameTooltip:Hide();
end

function FlightMapEnhancedTaxiChoiceButton_OnClick(self, button, down)
	
	if ( self.isHeader ) then
		if ( self.isExpanded ) then
			FlightMapEnhanced_Config.notexpanded[self.flightpathname] = true;
		else
			
			FlightMapEnhanced_Config.notexpanded[self.flightpathname] = nil;
		end
		FlightMapEnhanced_CreateFlyPathTable();
		FlightMapEnhancedTaxiChoiceContainer_Update();
	else
		TakeTaxiNode(self.flightpath);
	end
end




local function pairsByKeys (t, f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
	return iter
end

--to be removed after alpha
local function checkifdiscovered(fid)
	for index,value in pairs(floc) do
		for index2,value2 in pairs(value) do
			if(index2==fid) then
				return true;
			end
		end
	end
	return false;
end

function ns:GetPlayerData()
	local oldmapid = GetCurrentMapAreaID();
	local oldlevel = GetCurrentMapDungeonLevel();
	SetMapToCurrentZone();
	local cont,mapid,maplevel,px,py;
	cont = GetCurrentMapContinent();
	mapid = GetCurrentMapAreaID();
	maplevel = GetCurrentMapDungeonLevel();
	px,py = GetPlayerMapPosition("player");
	SetMapByID(oldmapid);
	SetDungeonMapLevel(oldlevel);
	return cont,mapid,maplevel,px,py;
end

local function tcount(tab)
   local n = #tab
   if (n == 0) then
     for _ in pairs(tab) do
       n = n + 1
     end
   end
   return n
 end

function FlightMapEnhanced_CreateFlyPathTable()
	local takeflight=0;
	local tmptaxinode={};
	taxinodeinfos = {};
	local numtaxis = NumTaxiNodes();
	local curcont,curmapid = ns:GetPlayerData();

	
	local updatenames = false;
	local updatediscovered = false;
	
	if(doreminder) then
		if(tcount(FlightMapEnhanced_FlightTimes)>0 or tcount(FlightMapEnhanced_FlightLocations)>0) then
			print("|c0000FF00Flight Map Enhanced|r:"..L.NEW_FLIGHT_PATH_DISCOVERED_HELP);
			doreminder = false;
			ns.gconf.lastcheck = time();
		end	
	end
	
	--this need overwork due diff chars know diff locations
	--workarround for now having a table which saves the number of flight points
	--so it update only once per session/continent
	if(numtaxis ~= lasttaxicount[curcont]) then
		updatenames = true;
		lasttaxicount[curcont] = numtaxis;
		--print("updating names");
	end
	if(flocdis["count"][curcont] ~= numtaxis) then
		updatediscovered = true;
		--print("updating known flight path locations");
	end
	for i=1,numtaxis do
		
		local match1,match2 = strmatch(TaxiNodeName(i),"^(.*),(.*)");
		if(match2 == nil) then --zone and subzone same name kinda in captials
			match1 = TaxiNodeName(i);
			match2 = TaxiNodeName(i);
		end
		match1=strtrim(match1);
		match2=strtrim(match2);
		if(updatenames == true or updatediscovered== true) then
			local tx,ty = TaxiNodePosition(i);
			local flid = CalcFlId(tx,ty,curcont);
			if(updatenames == true) then
				if not(flocn[flid]) then
					flocn[flid] = match1;
					flocn["count"][curcont] = flocn["count"][curcont] +1;
				end
			end
			if(updatediscovered==true) then
			   if not(flocdis[flid]) then
				flocdis[flid] = 1;
			   end
			end
		end
		
		if(TaxiNodeGetType(i)=="REACHABLE") then
			if(match1==nextflight) then
				takeflight = i;
			end
			if not (taxinodeinfos[match2]) then
				taxinodeinfos[match2] = {};
			end
			taxinodeinfos[match2][match1] = i;
		elseif(TaxiNodeGetType(i)=="CURRENT") then
				if not(floc[curmapid]) then
					floc[curmapid] = {};
				end
				--CalcFlId
				ns.current = i;
				local tx,ty = TaxiNodePosition(i);
				local flid = CalcFlId(tx,ty,curcont);
				if not(floc[curmapid][flid]) then
					floc[curmapid][flid] = {};
					floc[curmapid][flid].cont = curcont;
					local x,y = GetPlayerMapPosition("player");
					floc[curmapid][flid].x = ceil(x*1000)/1000;
					floc[curmapid][flid].y = ceil(y*1000)/1000;
					local curfaction = UnitFactionGroup("target");
					if(curfaction == "Horde" or curfaction == "Alliance") then
						floc[curmapid][flid]["faction"] = curfaction;
					else
						floc[curmapid][flid]["faction"] = "Neutral";
					end
					--temporary add it also to the saved variables
					if not(FlightMapEnhanced_FlightLocations[curmapid]) then
						FlightMapEnhanced_FlightLocations[curmapid] = {};
					end
					FlightMapEnhanced_FlightLocations[curmapid][flid] = floc[curmapid][flid];
					-- removed due new optionprint("|c0000FF00Flight Map Enhanced|r:"..L.NEW_FLIGHT_PATH_DISCOVERED_HELP);
					--temporary
				end			
				
				
			--end
		end
	end
	if(updatediscovered==true) then
		flocdis["count"][curcont] = numtaxis;
	end
	local runs = 1;
	
	for key, val in pairsByKeys(taxinodeinfos) do
		tmptaxinode[runs] = {};
		tmptaxinode[runs].name = key;
		tmptaxinode[runs].isheader = true;
		tmptaxinode[runs].flightid = 0;
		if (not FlightMapEnhanced_Config.notexpanded[key] and (FlightMapEnhanced_Config.alwayscollapse==nil or firstshow == false)) then
			tmptaxinode[runs].isexpanded = true;
			runs=runs+1;
			for key2, val2 in pairsByKeys(val) do
				tmptaxinode[runs] = {};
				tmptaxinode[runs].name = key2;
				tmptaxinode[runs].isheader = false;
				tmptaxinode[runs].flightid = val2;
				local tx,ty = TaxiNodePosition(val2);
				local flid = CalcFlId(tx,ty,curcont);
						
				if (checkifdiscovered(flid)==true) then
					tmptaxinode[runs].discovered = true;
				else
					tmptaxinode[runs].discovered = false;
				end
				tmptaxinode[runs].isexpanded = true;
				runs=runs+1
			end
		else
			if(FlightMapEnhanced_Config.alwayscollapse==1) then
				FlightMapEnhanced_Config.notexpanded[key] = true;
			end
			tmptaxinode[runs].isexpanded = false;
			runs=runs+1;
		end
	end
	taxinodeinfos = tmptaxinode;
	firstshow = false;
	if(takeflight~=0) then
		nextflight=nil;
		if(ns.wmc) then
			ns.wmc:FlightTaken();
		end
		autotake=true;
		ns:timer(1,"TakeTaxiNode("..takeflight..")");
	end
end




--redudant code clean up at some time
function FlightMapEnhanced_AlterFlightPaths()
	
	local a = ns:GetPlayerData();
	if(FlightMapEnhanced_Config.fps[a] ) then
		if(NumTaxiNodes()==FlightMapEnhanced_Config.fps[a].total) then
			return
		end
	end
	local tmptaxinode,tmptaxinode2 = {},{};
	FlightMapEnhanced_Config.fps[a] = {};
	for i=1,NumTaxiNodes() do
		local match1,match2 = strmatch(TaxiNodeName(i),"^(.*),(.*)");
		if(match2 == nil) then --zone and subzone same name kinda in captials
			match1 = TaxiNodeName(i);
			match2 = TaxiNodeName(i);
		end
		match1=strtrim(match1);
		match2=strtrim(match2);
		if not (tmptaxinode2[match2]) then
			tmptaxinode2[match2] = {};
		end
		tmptaxinode2[match2][match1] = i;
	end

	FlightMapEnhanced_Config.fps[a] = tmptaxinode2;
	FlightMapEnhanced_Config.fps[a].total = tcount;
end

--this could be used by other addon if wanted
function FlightMapEnhanced_SetNextFly(flyto)
	nextflight = flyto;
	print("|c0000FF00Flight Map Enhanced|r: "..L.NEXT_FLIGHT_GOTO.." "..flyto);
end

--this could be used by other addon if wanted
--todo with calculation now over all zones per continent may should changed the format of FlightMapEnhancedLocations.lua
function FlightMapEnhanced_GetClosestFlightPath(mapcont,mapareaid,coordx,coordy)

	--if not (floc[mapareaid]) then
	--	print(L.NO_FLIGHT_LOCATIONS_KNOWN);
	if(flocdis["count"][mapcont] == 0) then
		print(L.NEED_VISIT_FLIGHT_MASTER);
	else
		local closest = 100000;
		local flyto={};
		--old for index,value in pairs(floc[mapareaid]) do
		for index,value in pairs(floc) do
			for i2,v2 in pairs(value) do
				if((v2["faction"]==side or v2["faction"]=="Neutral") and v2["cont"]==mapcont and flocdis[i2]==1  ) then
					--print(ns.Astrolabe:ComputeDistance(mapareaid,0,coordx,coordy,index,0,v2.x,v2.y));
					--old local dist = CalcDist(coordx,value.x,coordy,value.y);
					local dist = ns.Astrolabe:ComputeDistance(mapareaid,0,coordx,coordy,index,0,v2.x,v2.y);
					if(dist<closest) then
						closest = dist;
						flyto={["name"]=flocn[i2],["mapid"]=index,["x"]=v2.x,["y"]=v2.y};
					end
				end
			end
		end
		if(flyto~="") then
			return flyto;
		else
			print(L.NO_FLIGHT_LOCATIONS_KNOWN);
		end
		
	end
end



function FlightMapEnhanced_OnEvent(self,event,...)
	
	if(event=="TAXIMAP_OPENED") then
		if(NumTaxiNodes()==0) then return; end
		firstshow = true;
		FlightMapEnhanced_CreateFlyPathTable();
		if(FlightMapEnhanced_Config.TaxiFramePoints) then
			TaxiFrame:ClearAllPoints();
			TaxiFrame:SetPoint(unpack(FlightMapEnhanced_Config.TaxiFramePoints));
		end
		if(FlightMapEnhanced_Config.TaxiFrameSize) then
			TaxiFrame:SetHeight(FlightMapEnhanced_Config.TaxiFrameSize[1]);
			TaxiFrame:SetWidth(FlightMapEnhanced_Config.TaxiFrameSize[2]);
			TAXI_MAP_WIDTH = TaxiFrame:GetWidth()-10;
			TAXI_MAP_HEIGHT = TaxiFrame:GetHeight()-28;
			TaxiFrame_OnEvent(TaxiFrame,"TAXIMAP_OPENED");
			DrawOneHopLines();
		end
		if( not FlightMapEnhanced_Config.vconf.DetachAddon or not FlightMapEnhanced_Config.FlightMapEnhancedTaxiChoicePoints or not FlightMapEnhanced_Config.FlightMapEnhancedTaxiChoiceSize) then
			FlightMapEnhancedTaxiChoice:SetHeight(TaxiFrame:GetHeight());
			FlightMapEnhancedTaxiChoice:SetWidth(250);
			FlightMapEnhancedTaxiChoice:ClearAllPoints();
			FlightMapEnhancedTaxiChoice:SetPoint("TOPLEFT",TaxiFrame,"BOTTOMRIGHT",0,TaxiFrame:GetHeight());
		else
			FlightMapEnhancedTaxiChoice:SetHeight( FlightMapEnhanced_Config.FlightMapEnhancedTaxiChoiceSize[1]);
			FlightMapEnhancedTaxiChoice:SetWidth(FlightMapEnhanced_Config.FlightMapEnhancedTaxiChoiceSize[2]);
			FlightMapEnhancedTaxiChoice:ClearAllPoints();
			FlightMapEnhancedTaxiChoice:SetPoint(unpack(FlightMapEnhanced_Config.FlightMapEnhancedTaxiChoicePoints));
			buttonsizechange=true;
		end
		FlightMapEnhancedTaxiChoice:Show();
		FlightMapEnhanced_AlterFlightPaths();
	elseif(event=="TAXIMAP_CLOSED") then
		FlightMapEnhancedTaxiChoice:Hide();
		taxinodeinfos = {};
	elseif(event=="ADDON_LOADED") then
		ns.Astrolabe = DongleStub("Astrolabe-1.0");
		local arg1 = ...;
		
		if(arg1 == "FlightMapEnhanced") then
			--FlightMapEnhanced_GlobalConf = nil;
			orig_taketaxinode = TakeTaxiNode;
			TakeTaxiNode = taketaxinode;
			if not(FlightMapEnhanced_GlobalConf) then
				FlightMapEnhanced_GlobalConf = {};
				FlightMapEnhanced_GlobalConf["version"] = 1;
				FlightMapEnhanced_GlobalConf["lastcheck"] = time();
				ns.gconf = FlightMapEnhanced_GlobalConf;
				
			else
				
				ns.gconf = FlightMapEnhanced_GlobalConf;
				if(time()-ns.gconf.lastcheck>604800) then
					doreminder = true;
				end
			end
			
			if not(FlightMapEnhanced_Config.notexpanded) then
				FlightMapEnhanced_Config.notexpanded = {};
			end
			if not(FlightMapEnhanced_Config.discovery) then
				FlightMapEnhanced_Config.discovery = {};
			end
			
			
			flocdis = FlightMapEnhanced_Config.discovery;
			ns.flocdis = flocdis;
			floc = ns.floc;
			local delete=true;
			--temporary add new discovered flightpath from the saved config to the known one and remove any of the saved which are known
			for flocdi,flocdv in pairs(FlightMapEnhanced_FlightLocations) do
				if not(floc[flocdi]) then
					floc[flocdi] = {};
				end
				for flocdi2,flocdv2 in pairs(flocdv) do
					if not(floc[flocdi][flocdi2]) then
						floc[flocdi][flocdi2] = flocdv2;
						delete=false;
						--print("not found");
					else
						FlightMapEnhanced_FlightLocations[flocdi][flocdi2] = nil;
						--print("found");
					end
				end
				
				if(delete==true) then
					--print("delete");
					FlightMapEnhanced_FlightLocations[flocdi] = nil;
				end
				delete=true;
			end
			
			--temporary
			--flocd = FlightMapEnhanced_FlightLocations;
			flocn = FlightMapEnhanced_FlightNames;
			--FlightMapEnhanced_FlightNames = {};
			--print("c"..tcount(FlightMapEnhanced_FlightLocations));
			
			if not(flocn["count"]) then
				flocn["count"] = {};
				flocn["count"][1] = 0;
				flocn["count"][2] = 0;
				flocn["count"][3] = 0;
				flocn["count"][4] = 0;
				flocn["count"][6] = 0;
			end
			
			ns.flocn = flocn;
		
			 if not(flocdis["count"]) then
				flocdis["count"] = {};
				flocdis["count"][1] = 0;
				flocdis["count"][2] = 0;
				flocdis["count"][3] = 0;
				flocdis["count"][4] = 0;
				flocdis["count"][6] = 0;
			 end
			
			
			--FlightMapEnhanced_FlightLocations = {};
			side = UnitFactionGroup("player");
			FlightMapEnhancedTaxiChoiceCollapseOnShow:SetChecked(FlightMapEnhanced_Config.alwayscollapse);
			FlightMapEnhancedTaxiChoice:UnregisterEvent("ADDON_LOADED");
			
			if not (FlightMapEnhanced_Config.minimap) then
				FlightMapEnhanced_Config.minimap = 45;
			end
			FlightMapEnhancedMiniMap_Reposition();
			if not (FlightMapEnhanced_Config.fps) then
				FlightMapEnhanced_Config.fps = {};
			end
			FlightMapEnhancedCFrame:Init();
			if not(FlightMapEnhanced_Config.vconf.module) then
				FlightMapEnhanced_Config.vconf.module = {};
			end
			ns:LoadModules();
			if not(FlightMapEnhanced_Config.vconf.version) then
				ns:configchange(0,10);
			elseif(FlightMapEnhanced_Config.vconf.version<10) then
				ns:configchange(FlightMapEnhanced_Config.vconf.version,10);
			end
			ns.configchange = nil;
			if(ns.gconf.version < 6) then
				ns:gconfigchange(6);
			end
			ns.gconfigchange = nil;
			collectgarbage();
		end	
	end
end

function FlightMapEnhanced_SavePosSize(frame)
	local a,b,c,d,e = _G[frame]:GetPoint(); if(b~=nil) then b=b:GetName(); end;
	FlightMapEnhanced_Config[frame.."Points"] = {a,b,c,d,e}
	FlightMapEnhanced_Config[frame.."Size"] = {_G[frame]:GetHeight(),_G[frame]:GetWidth()};
	if(frame=="FlightMapEnhancedTaxiChoiceContainer") then
		buttonsizechange = true;
	end
end

function FlightMapEnhancedMiniMap_Reposition()
	FlightMapEnhancedMinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(FlightMapEnhanced_Config.minimap)),(80*sin(FlightMapEnhanced_Config.minimap))-52)
end

function FlightMapEnhanced_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	FlightMapEnhanced_Config.minimap = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	FlightMapEnhancedMiniMap_Reposition() -- move the button
end

function FlightMapEnhancedMinimapButton_OnClick()
	
	local a = ns:GetPlayerData();
	if not(FlightMapEnhanced_Config.fps[a]) then
		print(L.NEED_VISIT_FLIGHT_MASTER_MINIMAP);
		return;
	end
	local menu = {};

	menu[1] = { text = "none", func = function() nextflight=nil;if(ns.wmc) then	ns.wmc:FlightTaken(); end end,checked=true }
	local round = 2;
	for key, val in pairsByKeys(FlightMapEnhanced_Config.fps[a]) do
		if(key~="total") then
			local tmpmenu = {};
			--tinsert(tmpmenu,{ text = key, hasArrow = true,menuList= {}});
			tmpmenu.text = key;
			tmpmenu.hasArrow=true;
			tmpmenu.menuList = {};
			
			--local menulist = {};
			--menulist.menuList = {};
			
			for key2,val2 in pairsByKeys(val) do
				if(key2==nextflight) then
					
					tinsert(tmpmenu.menuList, { text = key2,checked=true});
					tmpmenu.checked = true;
					menu[1].checked = false;
				else
					tinsert(tmpmenu.menuList, { text = key2, func = function() nextflight=key2;DropDownList1:Hide(); end});
				end
			end
			menu[round]=tmpmenu;
			round=round+1;
		end
	end

FlightMapEnhanced_menuFrame = FlightMapEnhanced_menuFrame or CreateFrame("Frame", "FlightMapEnhanced_menuFrame", UIParent, "UIDropDownMenuTemplate")
EasyMenu(menu, FlightMapEnhanced_menuFrame, "cursor", 0 , 0, "MENU");
end
	 
function FlightMapEnhancedShowToolTip(self,which)
	if(which=="minimap") then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT");
		GameTooltip:SetText("Flight Map Enhanced");
		GameTooltip:AddLine(L.TOOLTIP_LINE1_MINIMAP);
		GameTooltip:AddLine(L.TOOLTIP_LINE2_MINIMAP);
		GameTooltip:Show();
	elseif(which=="flightmapcollapse") then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(L.TOOLTIP_FLIGHTMAP_COLLAPSE, nil, nil, nil, nil, 1);
	end
	GameTooltip:Show();
end

TaxiFrame:SetResizable(true);
TaxiFrame:SetScript("OnDragStart", function () TaxiFrame:StartMoving(); end);
TaxiFrame:SetScript("OnDragStop", function () TaxiFrame:StopMovingOrSizing();FlightMapEnhanced_SavePosSize("TaxiFrame")  end);


function ns:LoadModules()
	for key, val in pairs(ns.modules) do
		if(FlightMapEnhanced_Config.vconf.modules[val]==1) then
			ns["init"..val]();
		end
		ns["init"..val] = nil;
	end
	
	
end
