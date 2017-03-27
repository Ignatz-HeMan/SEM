private ["_addEH","_unit","_EHindex"];

_unit = _this select 0;
_addEH = _this select 1;

if(_addEH)then[{	//Add damage detection EventHandler

	_EHindex = _unit addEventHandler ["handleDamage",{ private["_AIunit","_source"];
		_AIunit = _this select 0;
		_source = _this select 3;
		if(isPlayer _source)then{
			(group _AIunit) reveal [_source, 1.5];
			//_AIunit removeEventHandler ["handleDamage",(_AIunit getVariable "damageEHindex")];
			_AIunit setVariable ["gotHitBy", [_source, time]]; //define attacker and time
			_AIunit setVariable ["damageEHindex", -1];	//this is used later
		};
	}];
	_unit setVariable ["damageEHindex", _EHindex];

},{	//Remove damage detection EventHandler

	_EHindex = _unit getVariable "damageEHindex";
	if(_EHindex >= 0)then{
		_unit removeEventHandler ["handleDamage",_EHindex];
		_unit setVariable ["damageEHindex", -1];
	};
	
	if(!isNil {_unit getVariable "gotHitBy"})then{
		if((time - ((_unit getVariable "gotHitBy") select 1)) >= 150)then{
			_unit setVariable ["gotHitBy", Nil];
		};
	};
	
}];