if (!isnull _this) then {
	removeVest _this;
	//removeHeadgear _this;
	removeGoggles _this;
	removeAllItems _this;
	removeAllWeapons _this;
	removeBackpackGlobal _this;
	{_this removeMagazine _x}count magazines _this;
};