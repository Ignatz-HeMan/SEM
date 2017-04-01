# SEM
Reworked Simple Epoch Missions (Original crated by KiloSwiss)

Just paste the sem.pbo into @epochhive\addons folder
Make your Changes in sem_config.sqf in the root folder of this pbo.

- Added a wait until Epoch Server is completely running
- Supports now E3DEN + M3-Editor position exports
- Marker and notifications no longer needs client side codes
- Added Bandit Camp #4
- Complete rewritten loot script (scripts\fn_crateLoot.sqf)
- Other smaller fixes / changes (don't remember all)

Last Changelog:
2017-04-01
- Fixed: Dynamic missions were broken, also if in Config activated
- Added: Some Options to Bandit Device (sem\missionsStatic\bDevice.sqf)
   - Alarm x minutes after mission start, if AI's not killed
   - Big explosions with damaged Buildings and Earthquake within x meter from Device
- Fixed: A small bug in loot script