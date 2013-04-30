private["_playerPos","_item","_hastentitem","_location","_building","_isOk","_config","_text","_objectsPond","_isPond","_pondPos","_dir","_dis","_sfx","_tent"];

//check if can pitch here
call gear_ui_init;

//Player Pos
_playerPos = 	getPosATL player;

//Classname
_item = _this;

//Config
_config =   configFile >> "CFGWeapons" >> _item;
_text =     getText (_config >> "displayName");
_stashtype =  "0";
_consume =  getText (_config >> "consume");

_hasitemcount = {_x == _consume} count magazines player;

//if ("ItemSandbag" in magazines player) then { _stashtype = "StashMedium"; };

if (_hasitemcount == 0) exitwith {};
if (_hasitemcount == 1) then { _stashtype =   getText (_config >> "stashsmall"); };
if (_hasitemcount == 2) then { _stashtype =   getText (_config >> "stashmedium"); };

_location = player modeltoworld [0,2.5,0];
_location set [2,0];

//blocked
if (["concrete",dayz_surfaceType] call fnc_inString) exitwith { diag_log ("surface concrete"); };

_worldspace = [_stashtype, player] call fn_niceSpot;

if ((count _worldspace) == 2) then {
 
	player removeMagazine _consume;
	if (_hasitemcount == 2) then {
		player removeMagazine _consume;
	};
	_dir = round(direction player);
	
	//wait a bit
	player playActionNow "Medic";
	sleep 1;

	_dis=20;
	_sfx = "tentunpack";
	[player,_sfx,0,false,_dis] call dayz_zombieSpeak;  
	[player,_dis,true,(getPosATL player)] spawn player_alertZombies;
	
	sleep 5;
	//place tent (local)
	_stash = createVehicle [_stashtype, _location, [], 0, "CAN_COLLIDE"];
	_stash setdir _dir;
	_stash setpos _location;
	player reveal _stash;
	_location = getPosATL _stash;

	_stash setVariable ["characterID",dayz_characterID,true];
	dayzPublishObj = [dayz_characterID,_stash,[_dir,_location],_stashtype];
	
	publicVariable "dayzPublishObj";
	
	cutText [localize "str_success_tent_pitch", "PLAIN DOWN"];
} else {
	cutText [localize "str_fail_tent_pitch", "PLAIN DOWN"];
};