local ns = select( 2, ... );
function ns:initmfm()
	ns.mfm = {};
	local module = ns.mfm;
	local config = CreateFrame("Frame");
	local L = ns.L;
	local missing = {};
	local missing_pointers = {};
	local showconts = {[485]=4,[13]=1,[14]=2,[466]=3}
	local current = 1;
	

	function module:init()
		module:initmissing();		
		
		module.frame = CreateFrame("Frame");
		module.frame:SetScript("OnEvent",module.onevent);
		module.frame:RegisterEvent("WORLD_MAP_UPDATE");
		module.frame:RegisterEvent("UI_INFO_MESSAGE");
	end
	
	
	function module:initmissing()
		local dis = FlightMapEnhanced_Config.discovery;
		local faction =  UnitFactionGroup("player");
		local missingcont = false;
		for i=1,4 do
			missing[i] = {};
			if(ns.flocdis.count[i]==0) then
				missingcont = true;
			end
		end
		local c=0;
		
		for i,v in pairs (ns.floc) do
			for i2,v2 in pairs(v) do
				if(dis[i2] == nil and i2~=26366 and i2~=37815 and i2~=38123 and i2~=24863) then --26366 is the dk only one skip it, skip also aldor/scryer can only have one and work arround would be quite some work and not really worht it
					if(faction == v2.faction or v2.faction == "Neutral") then
						
						if not (missing[v2.cont][i]) then missing[v2.cont][i] = {} end
						
						if(ns.flocdis.count[v2.cont]>0) then
							tinsert(missing[v2.cont][i],{["x"]=v2.x,["y"]=v2.y});
						end
						c=c+1;					
					end
				end
			end
		end	
		if (c==0 and missingcont==false) then
			_G["FlightMapEnhanced_Module_mfm"]:SetChecked(0);
			FlightMapEnhanced_Config.vconf.modules["mfm"] = nil;
		end
	end
	
	function module:hideall()
		for _,v in pairs(missing_pointers) do
			v:Hide();
		end
		current = 1;
	end
	
	function module:CreateIcon(i)
		if(missing_pointers[i]) then return end;
		local  missing_icon=CreateFrame("Button", "LADADISISIA",WorldMapDetailFrame );
		missing_icon:SetWidth(20);
		missing_icon:SetHeight(20);
		missing_icon.icon = missing_icon:CreateTexture("ARTWORK");
		missing_icon.icon:SetAllPoints();
		missing_icon.icon:SetTexture("Interface\\MINIMAP\\TRACKING\\FlightMaster");
		missing_icon:SetFrameLevel(10000);
		missing_pointers[i] = missing_icon;
	end
	
	function module:ShowContinent(w,s)
		if not(missing[w]) then return end
		for i,v in pairs(missing[w]) do
			for i2,v2 in pairs(v) do
				module:CreateIcon(current);
				missing_pointers[current]:SetHeight(s);
				missing_pointers[current]:SetWidth(s);
				missing_pointers[current]:Show();
				ns.Astrolabe:PlaceIconOnWorldMap( WorldMapDetailFrame, missing_pointers[current], i, GetCurrentMapDungeonLevel(), v2.x, v2.y );
				current=current+1;
			end
		end
	
	end
	
	function module:ShowZone(c,m)
		
		if not(missing[c][m]) then return end
		for i,v in pairs(missing[c][m]) do
			module:CreateIcon(current);
			missing_pointers[current]:SetHeight(30);
			missing_pointers[current]:SetWidth(30);
			missing_pointers[current]:Show();
			ns.Astrolabe:PlaceIconOnWorldMap( WorldMapDetailFrame, missing_pointers[current], m, GetCurrentMapDungeonLevel(), v.x, v.y );
			current=current+1;
		end
	end
	
	function module:onevent(event,...)
		if(event=="WORLD_MAP_UPDATE") then
			local curcont = GetCurrentMapContinent(); 
			if(WorldMapFrame:IsVisible() and curcont~=-1 and curcont<5) then
				module:hideall();
				local curmapid = GetCurrentMapAreaID();
				if(curcont==0) then
					module:ShowContinent(1,20);
					module:ShowContinent(2,20);
					module:ShowContinent(4,20);
				elseif(showconts[curmapid]) then
					module:ShowContinent(showconts[curmapid],25);
				else
					module:ShowZone(curcont,curmapid);
				end
			else
				module:hideall();
			end
		elseif(event=="UI_INFO_MESSAGE") then
			if(...==ERR_NEWTAXIPATH) then
				self:RegisterEvent("TAXIMAP_CLOSED")
			end
		elseif(event=="TAXIMAP_CLOSED") then
			self:UnregisterEvent("TAXIMAP_CLOSED");
			module:initmissing();
		end
	
	end
	
	module:init();
end