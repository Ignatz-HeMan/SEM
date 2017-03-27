private["_arr","_last","_ran","_sel"];
/*
	Source: http://forums.bistudio.com/showthread.php?97602-Sort-Array-per-Distance
	Edited by KiloSwiss to select a random mission, accorded to their probability setting.
*/


_arr = _this select 0;
_last = _this select 1;

if(count _arr < 2)exitWith{_arr select 0};

if(count _this > 2)then[{_ran = 1 max (_this select 2) min 100},{_ran = 1 max ceil(random 100);}];

while{{_x select 3 >= _ran}count _arr == 0}do{_ran = _ran -1};

_sel = _arr select random (count _arr -1);
while{_sel select 3 < _ran || _sel select 0 == _last}do{_sel = _arr select random (count _arr -1)};

_sel
