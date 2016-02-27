//More info: 
//https://community.bistudio.com/wiki/createDiaryRecord
//https://community.bistudio.com/wiki/createDiarySubject
#include "functions.sqf";
#include "..\logic\activeMods.sqf";

//Adds briefing file
player createDiarySubject ["Diary", "Diary"];

//Define variables to be potentially inserted in briefing file text with parameter %(number)
_intelLow = if (low_players) then {
	"<br /> <br /> They have set up roadblocks <marker name = 'marker_block1'>here</marker>, <marker name = 'marker_block2'>here</marker>, and <marker name = 'marker_block3'>here</marker>, which are guarded by truck-mounted machine guns and some infantry. Surveillance has reported the terrorists digging up the road some way from each block. Expect them to have laid mines there.";
} else {
	"";
};

_missionLow = if (low_players) then {
	"<br /><br /> To assist in the task, a small assault force is standing by to provide fire support as you clear the buildings. Clear the roadblocks <marker name = 'marker_block1'>here</marker>, <marker name = 'marker_block2'>here</marker>, and <marker name = 'marker_block3'>here</marker>, and call in the assault via your action menu once you're ready to begin the assault.";
} else {
	"";
};

_signal = if ( "task_force_radio" call caran_checkMod ) then { "SignalTFAR.txt"; } else {""; };
if ( "acre_" call caran_checkMod ) then { _signal = "SignalACRE.txt"; };

//Add new diary pages with caran_briefingFile. 
//If including variables, add them as a list to the end of the parameters list: ["ExampleSubject", "ExampleName", "ExampleFile", [ExampleParams]]
if ( "task_force_radio" call caran_checkMod || "acre_" call caran_checkMod ) then {
	["Diary", "Signal", _signal] call caran_briefingFile;
};
_intel = ["Diary", "Intel", "Intel.txt", [_intelLow]] call caran_briefingFile;
_mission = ["Diary", "Mission", "Mission.txt", [_missionLow]] call caran_briefingFile;
_situation = ["Diary", "Situation", "Situation.txt"] call caran_briefingFile;