local ns = select( 2, ... );
function ns:initft()
	ns.ft = {};
	local module = ns.ft;
	local config = CreateFrame("Frame");
	local config_gui = CreateFrame("Frame");
	local L = ns.L;
	local curtaxinode;
    --local orig_taketaxinode;
	local f_times,s_f_times;
	local flight_route={};
	local timer,totaltimer,curhop,curspeed,needspeed,flight_route_accurate,nofastrack,startname,endname,lasttimer,timeleft,nosaving;
	local remapid = {[45665]=45664}; --argent van guard
	local options;
	local dotracking;
	local flystart = 0;
	local flyend = 0;

	local function CalcFlId(x,y,z)
		local flid=tonumber(z..ceil(x*100)..ceil(y*100));
		if(remapid[flid]) then
			return remapid[flid];
		else
			return flid;
		end
	end
	
	local function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	
	function module:getid(uid)
		for _,v in pairs(ns.floc) do
			for i,v2 in pairs(v) do
				if(i==uid) then
					if(v2.id~=nil) then
						return v2.id;
					else
						return -1;
					end
				end
			end
		end
		return -1;
	end
	
	--removing from saved variables the flight times which are in the addon db
	--if not in db add it to it to have all times in 1 place for usage
	function module:removefromsv()
		for i,v in pairs (FlightMapEnhanced_FlightTimes) do
			if(ns.ftracks[i]) then
				FlightMapEnhanced_FlightTimes[i] = nil;
			else
				ns.ftracks[i] = v;
			end
		end
	end
	
	--gonna need overwork for now just ripped of the taketaxinode hook
	function module:buildflyroutes(button)
			if not (options.showaccuratemap) then return; end
			local wn = self:GetID();
	
			
			local numroutes = GetNumRoutes(wn);
			local dX,dY,flid,sX,sY;
			local aflidgen = true;
			flight_route_accurate = '';
			for i=1, numroutes do
				if(i==1) then
					sX = TaxiGetSrcX(wn, i);
					sY = TaxiGetSrcY(wn, i);
					flid = CalcFlId(sX,sY,GetCurrentMapContinent())
					if(ns.flocn[flid] ~= nil) then
					
						local accuid = module:getid(flid);
						if(accuid>-1) then
							flight_route_accurate = GetCurrentMapContinent().."-"..accuid;
						else
							
							aflidgen = false;
						end
					else
						--not having the flid so insert -1
						aflidgen = false;
						print(L.FT_CANNOT_FIND_ID..": "..flid..". "..L.FT_CANNOT_FIND_ID2);
			
					end
				end
				
				dX = TaxiGetDestX(wn, i);
				dY = TaxiGetDestY(wn, i);
				flid = CalcFlId(dX,dY,GetCurrentMapContinent());
				
				--currently The Argent Vanguard flight path fucks, maybe more
				if ns.flocn[flid] ~= nil then
				
					local accuid = module:getid(flid);
					
					if(accuid>-1) then
						flight_route_accurate = flight_route_accurate.."-"..accuid;
					else
						
						aflidgen = false;
					end
					
				else
					print(L.FT_CANNOT_FIND_ID..": "..flid..". "..L.FT_CANNOT_FIND_ID2);
					aflidgen = false;
				end
			
				
			end
		if(options.accurate and f_times[flight_route_accurate] and aflidgen==true) then 
			local mins,secs = module:CalcTime(f_times[flight_route_accurate])
			GameTooltip:AddLine("Flight time: "..mins.."m"..secs.."s", 1.0, 1.0, 1.0);
		end	
			
	end
	
	function module:taketaxinode(wn)
		dotracking = false;
		--if(options.fasttrack) then
			local numroutes = GetNumRoutes(wn);
			local dX,dY,flid,sX,sY;
			nofastrack = false;
			flight_route={};
			local aflidgen = true;
			flight_route_accurate = '';
			for i=1, numroutes do
				if(i==1) then
					sX = TaxiGetSrcX(wn, i);
					sY = TaxiGetSrcY(wn, i);
					flid = CalcFlId(sX,sY,GetCurrentMapContinent())
					startname = FlightMapEnhanced_FlightNames[flid];
					if(ns.flocn[flid] ~= nil) then
						tinsert(flight_route,flid);
						local accuid = module:getid(flid);
						if(accuid>-1) then
							flight_route_accurate = GetCurrentMapContinent().."-"..accuid;
						else
							
							aflidgen = false;
						end
					else
						--not having the flid so insert -1
						aflidgen = false;
						print(L.FT_CANNOT_FIND_ID..": "..flid..". "..L.FT_CANNOT_FIND_ID2);
						tinsert(flight_route,-1);
					end
				end
				
				dX = TaxiGetDestX(wn, i);
				dY = TaxiGetDestY(wn, i);
				flid = CalcFlId(dX,dY,GetCurrentMapContinent());
				
				--currently The Argent Vanguard flight path fucks, maybe more
				if ns.flocn[flid] ~= nil then
					tinsert(flight_route,flid);
					local accuid = module:getid(flid);
					if(accuid>-1) then
						flight_route_accurate = flight_route_accurate.."-"..accuid;
					else
						
						aflidgen = false;
					end
					
				else
					print(L.FT_CANNOT_FIND_ID..": "..flid..". "..L.FT_CANNOT_FIND_ID2);
					aflidgen = false;
					tinsert(flight_route,-1);
				end
				if(flight_route[i]~=-1 and flight_route[i+1]~=1) then
					local ft_timeid;
				--lower id always first
					if(flight_route[i]>flight_route[i+1]) then
						ft_timeid = flight_route[i+1].."|"..flight_route[i];
					else
						ft_timeid = flight_route[i].."|"..flight_route[i+1];
					end
					if not(f_times[ft_timeid]) then
						dotracking=true;
					end
				end
				if(i==numroutes) then
					endname = FlightMapEnhanced_FlightNames[flid]
				end
			end
			curhop = 1;
				
			if not(options.fasttrack) then
				flight_route = {};
				dotracking = false;
			end
		--end
		
			--local sx,sy,sflid,dx,dy,dflid;
			--sx,sy=TaxiNodePosition(ns.current);
			--sflid = CalcFlId(sx,sy,GetCurrentMapContinent());
			--dx,dy=TaxiNodePosition(wn);
			--dflid = CalcFlId(dx,dy,GetCurrentMapContinent());
			--startname = FlightMapEnhanced_FlightNames[sflid];
			--endname = FlightMapEnhanced_FlightNames[dflid];
		--print(flight_route_accurate);
		--print(aflidgen);
		
		if(options.accurate and aflidgen == true) then
			--print("jo");
			--flight_route_accurate = sflid.."-"..dflid;
			if not(f_times[flight_route_accurate]) then
				--print("tracking accurate");
				dotracking=true;
			end
		else
			flight_route_accurate = '';
		end
		
		
		--register events we need
		module.frame:RegisterEvent("PLAYER_CONTROL_LOST");
		nosaving = false;
		
		--orig_taketaxinode(wn);
	end
	
	
	
	function module:init()
		--prehook so the flight path can be calculated before the flight start
		if not(FlightMapEnhanced_FlightTimes) then FlightMapEnhanced_FlightTimes = {}; end
		--FlightMapEnhanced_FlightTimes = {};
		module:removefromsv();
		s_f_times = FlightMapEnhanced_FlightTimes;
		f_times = ns.ftracks;
		--FlightMapEnhanced_FlightTimes = {};
		--orig_taketaxinode = TakeTaxiNode;
		--TakeTaxiNode = taketaxinode;
		module.frame = CreateFrame("Frame");
		module.frame:SetScript("OnEvent",module.onevent);
		--module.frame:RegisterAllEvents();
		config:init();
		--module.tframe = CreateFrame("Frame",nil,UIParent);
		local f = CreateFrame("Frame",nil,UIParent)
		module.tframe = f;
		f:SetFrameStrata("LOW")
		--f:SetWidth(200) -- Set these to whatever height/width is needed 
		f:SetHeight(100) -- for your Texture
		f:SetBackdrop( { 
		  bgFile = "Interface\\Addons\\FlightMapEnhanced\\images\\ftimes_frame", 
		  --edgeFile = "Interface\\UNITPOWERBARALT\\MetalEternium_Horizontal_Frame", tile = false, tileSize = 0, edgeSize = 32, 
		  insets = { left = 0, right = 0, top = 0, bottom = 0 }
		});
		--f:SetPoints("TOPLEFT",UIParent);
		local t = f:CreateTexture(nil,"BACKGROUND")
		t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background-Dark")
		--t:SetWidth(180);
		t:SetHeight(55);
		--t:SetAllPoints(f)
		t:SetPoint("CENTER",f);
		f.texture = t

		local curwidth = 0;
		local font = f:CreateFontString( nil, "OVERLAY", "GameFontNormalSmall" );
		font:SetPoint("TOPLEFT", f,"TOPLEFT", 14, -5)
		font:SetText("|cFF00ff00Flight Map Enhanced - Flight Times");
				
		
		local font1 = f:CreateFontString( nil, "OVERLAY", "GameFontNormalSmall" );
		font1:SetPoint("TOPLEFT", font,"TOPLEFT", 0, -16)
		--font1:SetText("|cFFFFFFFFOgrimmar -> Thunder Bluff");
		f.flightpath = font1;
		
		local font2 = f:CreateFontString( nil, "OVERLAY", "GameFontNormal" );
		font2:SetPoint("TOPLEFT",font1,"TOPLEFT", 0, -20)
		--font2:SetText("Time left: 1m60s");
		font2:SetTextHeight(20);
		f.timeleft = font2;
		
		local font3 = f:CreateFontString( nil, "OVERLAY", "GameFontNormalSmall" );
		font3:SetPoint("TOPLEFT", font2,"TOPLEFT", 0, -25)
		f.modus = font3;
		
		--font3:SetText("|cFFFFFFFFCalculated");
		--if(font3:GetWidth()>curwidth) then curwidth=font3:GetWidth() end;
		--options.points = nil;
		
		
		--f:Show()
		--f:EnableMouse(true);
		f:RegisterForDrag("LeftButton");
		f:SetMovable(true);
		f:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
		f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); local a,b,c,d,e = self:GetPoint(); if(b~=nil) then b=b:GetName(); end; options.points = {a,b,c,d,e} end);
		f:SetScript("OnEnter", function (self) GameTooltip:SetOwner(self, "ANCHOR_TOP");GameTooltip:SetText(L.FT_MOVE, nil, nil, nil, nil, 1); end);
		f:SetScript("OnLeave",function() GameTooltip:Hide(); end); 
		f:Hide();
		hooksecurefunc('TaxiNodeOnButtonEnter',module.buildflyroutes);
	end
	
	function module:timeron()
		timer=0;
		totaltimer=0;
		module.frame:SetScript("OnUpdate",function (self,elapsed)
			timer=timer+elapsed;
			totaltimer=totaltimer+elapsed;
			if(needspeed and timer>=1) then 
				needspeed=false;
				curspeed = round(GetUnitSpeed("Player"),3);
				if(options.accurate and f_times[flight_route_accurate]) then --if accurate on and we have a timer
					module:ShowFlightTime(f_times[flight_route_accurate],-1);
				elseif(options.fasttrack) then --its disabled or dont have accurate values lets calc them
					local ttime,misshops = module:CalcFlightTime_Fasttrack();
					module:ShowFlightTime(ttime,misshops);
				end
				
				if (dotracking==false) then
					module:timeroff();
				end
			
				if(options.fasttrack and options.nounusual and (curspeed < 29 or curspeed > 31)) then
					if not(options.accurate) then
						module:stoptracking();
					else
						module.frame:UnregisterEvent("PLAYER_MONEY");
						nofastrack = true;
					end
				end
			end 
		end);
	end
	
	function module:delaytimer()
		local delaytime = 0;
		module.frame:SetScript("OnUpdate",function (self,elapsed)
			delaytime=delaytime+elapsed;
			if(delaytime>5) then
				if(IsInInstance()==nil and nosaving==false) then
					module:saveaccurate();
					module:savehop();
					--print("saving");
				else
					--print("notsaving");
				end
				module.frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
				module.frame:SetScript("OnUpdate",nil);
			end
		end);
	end
	
	function module:stoptracking()
		
		module:timeroff();
		
		module.frame:UnregisterEvent("PLAYER_CONTROL_LOST");
		module.frame:UnregisterEvent("PLAYER_MONEY");
		--leave this on to disable the flight timer if flight stops early 
		--module.frame:UnregisterEvent("PLAYER_CONTROL_GAINED");
		module.frame:UnregisterEvent("UNIT_FLAGS");
		module.frame:UnregisterEvent("CONFIRM_SUMMON");
		module.frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
		--flight_route = {};
	end
	
	function module:timeroff()
		
		module.frame:SetScript("OnUpdate",nil);
	end
	

	function module:onevent2(event,...)
		tinsert(FlightMapEnhanced_FlightTimes,event);
		
	end
	
	function module:saveaccurate()

		if(options.accurate) then
			if(flight_route_accurate=='') then return; end
			if(not f_times[flight_route_accurate]) then
				local timetook = flyend - flystart;				
				s_f_times[flight_route_accurate] = timetook;
				f_times[flight_route_accurate] = timetook;
			end
		end
	end
	
	function module:savehop()
		if(options.fasttrack and nofastrack~=true) then
			if(flight_route[curhop]~=-1 and flight_route[curhop+1]~=-1) then
				local ft_timeid;
				--lower id always first
				if(flight_route[curhop]>flight_route[curhop+1]) then
					ft_timeid = flight_route[curhop+1].."|"..flight_route[curhop];
				else
					ft_timeid = flight_route[curhop].."|"..flight_route[curhop+1];
				end
				if(not f_times[ft_timeid]) then
					local timetook;
					if(flyend==0) then
						timetook = time() - flystart;
					else
						timetook = flyend - flystart;
					end
					
					
					s_f_times[ft_timeid] = {["speed"]=curspeed,["ftime"]=timetook};
					f_times[ft_timeid] = {["speed"]=curspeed,["ftime"]=timetook};
				end
			end
			curhop=curhop+1;
			timer=0;
		end
	end
	
	function module:onevent(event,...)
		
		--print(event);
		if(event=="PLAYER_CONTROL_LOST") then
			self:UnregisterEvent("PLAYER_CONTROL_LOST");
			self:RegisterEvent("UNIT_FLAGS");
		elseif(event=="PLAYER_MONEY") then
			if(timer<5) then return;end --seems sometimes the player money event comes too late
			--print(IsInInstance());
			module:savehop();
			
			--if(event=="PLAYER_CONTROL_GAINED") then
				--print("back on earth");
			--	module:timeroff();
			--	self:UnregisterEvent("PLAYER_CONTROL_GAINED");
			--	self:UnregisterEvent("PLAYER_MONEY");
			--	self:UnregisterEvent("CONFIRM_SUMMON"); --using this as temp fix it trigger when to confirm summon but not when it happens
				--self:UnregisterEvent("PLAYER_ENTERING_WORLD"); --thise need finetuning for flying into bc zones, which causes this event too
		
			--print(timer.."-"..curspeed);
		elseif(event=="PLAYER_CONTROL_GAINED") then
		
			module:FlightTimerOff()
			module:timeroff();
			module:delaytimer();
			flyend = time();
			self:UnregisterEvent("PLAYER_CONTROL_GAINED");
			self:UnregisterEvent("PLAYER_MONEY");
			self:UnregisterEvent("CONFIRM_SUMMON");
			--self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		elseif(event=="UNIT_FLAGS") then
			if(UnitOnTaxi("player")) then
				flystart = time();
				module:timeron();
				self:RegisterEvent("PLAYER_CONTROL_GAINED");
				if(dotracking) then
					self:RegisterEvent("CONFIRM_SUMMON");
					self:RegisterEvent("PLAYER_ENTERING_WORLD");
					
					if(options.fasttrack) then
						self:RegisterEvent("PLAYER_MONEY"); --figure when a flight path is passed
					end
				else
					nosaving = true; 
				end
				needspeed = true; --somehow sometimes the speed is not known here yet so delaying it
				--print("on taxi");
			else
				--print("not on taxi");
			end
			
			self:UnregisterEvent("UNIT_FLAGS");
		elseif(event=="CONFIRM_SUMMON") then
			module:FlightTimerOff()
			module:stoptracking();
		elseif(event=="PLAYER_ENTERING_WORLD") then
			nosaving = true;
			self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		end
	end
	
	function module:CalcTime(seconds)
		local minutes = floor(seconds/60);
		local seconds = mod(seconds,60);
		return minutes,seconds;
	end
	
	function module:UpdateTimer(elapsed)
		lasttimer = lasttimer + elapsed;
		if(lasttimer>=0.5) then
			timeleft=timeleft-lasttimer;
			local minutes,seconds = module:CalcTime(floor(timeleft));
			module.tframe.timeleft:SetText("|cFFFFFFFF"..L.FT_TIME_LEFT..": |r"..minutes..L.FT_MINUTE_SHORT..seconds..L.FT_SECOND_SHORT);
			lasttimer = 0;
			if(timeleft<=0) then
				module.tframe:SetScript("OnUpdate",nil);
				module.tframe:Hide();
			end
		end
	end
	
	function module:FlightTimerOff()
		module.tframe:SetScript("OnUpdate",nil);
		module.tframe:Hide();	
	end
	
	function module:SetTimerWidth()
		local curwidth = module.tframe.flightpath:GetWidth();
		if(module.tframe.timeleft:GetWidth() > curwidth) then
			curwidth = module.tframe.timeleft:GetWidth();
		end
		
		if(module.tframe.modus:GetWidth() > curwidth) then
			curwidth = module.tframe.modus:GetWidth();
		end
		
		
		module.tframe:SetWidth(curwidth+46);
		module.tframe.texture:SetWidth(curwidth+30);
	
	end
	
	function module:ShowFlightTime(ttime,missinghops)
		if(ttime==0) then return; end
		ttime = ttime-1;
		timeleft = ttime;
		if(missinghops==-1) then
			--print("Flight will take "..ttime.."s (accurate time)");
			module.tframe.modus:SetText("|cFFFFFFFF"..L.FT_MODUS..": "..L.FT_ACCURATE);
		elseif(missinghops==0) then
			module.tframe.modus:SetText("|cFFFFFFFF"..L.FT_MODUS..": "..L.FT_CALCULATED);
		else
			module.tframe.modus:SetText("|cFFFFFFFF"..L.FT_MODUS..": "..L.FT_CALCULATED.." - "..L.FT_MISSING_HOPS..": "..missinghops);
		end
		module.tframe.flightpath:SetText("|cFFFFFFFF"..startname.."->"..endname);
		local minutes,seconds=module:CalcTime(ttime);
		module.tframe.timeleft:SetText("|cFFFFFFFF"..L.FT_TIME_LEFT..": |r"..minutes..L.FT_MINUTE_SHORT..seconds..L.FT_SECOND_SHORT);
		lasttimer = 0;
		module.tframe:SetScript("OnUpdate",module.UpdateTimer);
		module:SetTimerWidth();
		if(options.points) then
			module.tframe:SetPoint(unpack(options.points));
		else
			module.tframe:SetPoint("CENTER",0,0);
		end
		module.tframe:Show();
	end
	
	function module:CalcFlightTime_Fasttrack()
		local ft_timeid;
		local totaltime=0;
		local missinghops=0;
		--print(#(flight_route));
		for i=1,#(flight_route) do
			if(i<#(flight_route)) then
				if(flight_route[i]>flight_route[i+1]) then
					ft_timeid = flight_route[i+1].."|"..flight_route[i];
				else
					ft_timeid = flight_route[i].."|"..flight_route[i+1];
				end
				if(f_times[ft_timeid]) then
					--totaltime = totaltime+((speedsave / curspeed) * timesave)
					totaltime=totaltime+((f_times[ft_timeid].speed/curspeed)*f_times[ft_timeid].ftime);
				else
					missinghops=missinghops+1;
				end
			end
		end
		totaltime=ceil(totaltime); -- -1s due the delay of calculating
		--print("flight will take: "..totaltime.."s - Missing hops: "..missinghops);
		return totaltime,missinghops;
	end
	
	function config:init()
		
		config.name = "Flight Times";
		config.parent = "Flight Map Enhanced";
		
		local moduleft_fasttrack = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_ft_fasttrack", config, "InterfaceOptionsCheckButtonTemplate" );
		config.moduleft_fasttrack = moduleft_fasttrack;
		moduleft_fasttrack.id = "fasttrack";
		moduleft_fasttrack:SetPoint( "TOPLEFT", config, "TOPLEFT", 10, -16);
		moduleft_fasttrack:SetScript("onClick",config.ChangeState);
		_G[ moduleft_fasttrack:GetName().."Text" ]:SetText( "|c00dfb802"..L.FT_USE_FAST_TRACK );

		local moduleft_fasttrack_explain = config:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
		config.moduleft_fasttrack_explain = moduleft_fasttrack_explain;
		moduleft_fasttrack_explain:SetPoint("TOPLEFT", moduleft_fasttrack,"TOPLEFT", 0, -16)
		moduleft_fasttrack_explain:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
		moduleft_fasttrack:SetHeight(moduleft_fasttrack_explain:GetHeight() + 15);
		moduleft_fasttrack_explain:SetJustifyH("LEFT");
		moduleft_fasttrack_explain:SetText( L.FT_USE_FAST_TRACK_EXPLAIN);
		
		
		local moduleft_fasttrack_nounusual = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_ft_fasttrack_nounusual", config, "InterfaceOptionsCheckButtonTemplate" );
		config.moduleft_fasttrack_nounusual = moduleft_fasttrack_nounusual;
		moduleft_fasttrack_nounusual.id = "nounusual";
		moduleft_fasttrack_nounusual:SetPoint( "TOPLEFT", moduleft_fasttrack_explain, "BOTTOMLEFT", 0, -16);
		moduleft_fasttrack_nounusual:SetScript("onClick",config.ChangeState);
		_G[ moduleft_fasttrack_nounusual:GetName().."Text" ]:SetText( "|c00dfb802"..L.FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED );

		local moduleft_fasttrack_nounusual_explain = config:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
		config.moduleft_fasttrack_nounusual_explain = moduleft_fasttrack_nounusual_explain;
		moduleft_fasttrack_nounusual_explain:SetPoint("TOPLEFT", moduleft_fasttrack_nounusual,"TOPLEFT", 0, -16)
		moduleft_fasttrack_nounusual_explain:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
		moduleft_fasttrack_nounusual:SetHeight(moduleft_fasttrack_nounusual_explain:GetHeight() + 15);
		moduleft_fasttrack_nounusual_explain:SetJustifyH("LEFT");
		moduleft_fasttrack_nounusual_explain:SetText( L.FT_USE_FAST_TRACK_NO_UNUSUAL_SPEED_EXPLAIN);
		
		local moduleft_fasttrack_accurate = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_ft_fasttrack_accurate", config, "InterfaceOptionsCheckButtonTemplate" );
		config.moduleft_fasttrack_accurate = moduleft_fasttrack_accurate;
		moduleft_fasttrack_accurate.id = "accurate";
		moduleft_fasttrack_accurate:SetPoint( "TOPLEFT", moduleft_fasttrack_nounusual_explain, "BOTTOMLEFT", 0, -16);
		moduleft_fasttrack_accurate:SetScript("onClick",config.ChangeState);
		_G[ moduleft_fasttrack_accurate:GetName().."Text" ]:SetText( "|c00dfb802"..L.FT_USE_ACCURATE_TRACK );

		local moduleft_fasttrack_accurate_explain = config:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
		config.moduleft_fasttrack_accurate_explain = moduleft_fasttrack_accurate_explain;
		moduleft_fasttrack_accurate_explain:SetPoint("TOPLEFT", moduleft_fasttrack_accurate,"TOPLEFT", 0, -16)
		moduleft_fasttrack_accurate_explain:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
		moduleft_fasttrack_accurate:SetHeight(moduleft_fasttrack_accurate_explain:GetHeight() + 15);
		moduleft_fasttrack_accurate_explain:SetJustifyH("LEFT");
		moduleft_fasttrack_accurate_explain:SetText( L.FT_USE_ACCURATE_TRACK_EXPLAIN);
		
		local moduleft_fasttrack_info = config:CreateFontString( nil, "OVERLAY", "GameFontHighlight" );
		config.moduleft_fasttrack_info = moduleft_fasttrack_info;
		moduleft_fasttrack_info:SetPoint("TOPLEFT", moduleft_fasttrack_accurate_explain,"BOTTOMLEFT", 0, -16)
		moduleft_fasttrack_info:SetWidth(InterfaceOptionsFramePanelContainer:GetRight() - InterfaceOptionsFramePanelContainer:GetLeft() - 30);
		moduleft_fasttrack_info:SetJustifyH("LEFT");
		moduleft_fasttrack_info:SetText( L.FT_INFO);
		
		local moduleft_show_accurate_map = CreateFrame( "CheckButton", "FlightMapEnhanced_Module_ft_show_accurate_map", config, "InterfaceOptionsCheckButtonTemplate" );
		config.moduleft_show_accurate_map = moduleft_show_accurate_map;
		moduleft_show_accurate_map.id = "showaccuratemap";
		moduleft_show_accurate_map:SetPoint( "TOPLEFT", moduleft_fasttrack_info, "BOTTOMLEFT", 0, -16);
		moduleft_show_accurate_map:SetScript("onClick",config.ChangeState);
		_G[ moduleft_show_accurate_map:GetName().."Text" ]:SetText( "|c00dfb802"..L.FT_SHOW_ACCURATE_MAP );
		
		
		InterfaceOptions_AddCategory(config);
		if not(FlightMapEnhanced_Config.vconf.module.ft) then
			FlightMapEnhanced_Config.vconf.module.ft = {};
			config:SetDefaultConfig();
		end
		options = FlightMapEnhanced_Config.vconf.module.ft;
		moduleft_fasttrack:SetChecked(options.fasttrack);
		moduleft_fasttrack_nounusual:SetChecked(options.nounusual);
		moduleft_fasttrack_accurate:SetChecked(options.accurate);
		moduleft_show_accurate_map:SetChecked(options.showaccuratemap);
		--config:GUIInit();
	end 
	
	function config:GUIInit()
		config_gui.name = "GUI Config";
		config_gui.parent = "Flight Times";
		
		InterfaceOptions_AddCategory(config_gui);
	end
		
	function config:ChangeState()
		options[self.id] = self:GetChecked();
	end
	
	function config:SetDefaultConfig()
		FlightMapEnhanced_Config.vconf.module.ft = {["fasttrack"]=1,["nounusual"]=1,["accurate"]=1,["showaccuratemap"]=1};
	end
	
	module:init();
end