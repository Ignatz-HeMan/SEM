/* KiloSwiss */
private["_pos","_dir","_dist","_posX","_posY","_newPos"];

_pos = _this;

_dir = random 360;
_dist = (100 + (random 200));
_posX = (_pos select 0) + sin(_dir) * _dist;
_posY = (_pos select 1) + cos(_dir) * _dist;
_newPos = [_posX, _posY, 0];

_newPos;
