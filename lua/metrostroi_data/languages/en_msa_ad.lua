--Описание сигналтула
MSignaltool_Name = 	"Signalling Tool"
MSignaltool_Des = 	"Adds and modifies signalling equipment (ALS/ARS), signs and ATO elements"
MSignaltool_nul = 	"LMB: Spawn/Update selected signalling equipment (point at the inner side of the track)\nR: Copy Settings\nRMB: Remove"
MSignaltool_Undo = 	"Undone Signalling Equipment"

--PA
PA_Last_ST = "Last Station"
PA_Last_ST_Des = "Select if it's the terminal station"
PA_WP = "Wrong Path"
PA_Dist_Start = "Distance to the\ndeadend start:"
PA_Dist_End = "Distance to the\ndeadend end:"
PA_Line_Change = "Line Change (NOT USED)"
PA_Line_Change_Route = "Line Change\nTrack:"
PA_Line_Change_STID = "Line Change\nStation ID:"
PA_ST_Name = "Station Name:"
PA_ST_Name_Des = "Station name in PA"
PA_Last_ST_Name = "Last Station Name:"
PA_Last_ST_Name_Des = "Examples: Сталинской, Улицы Дыбенко"
PA_Has_Switches = "Has Switches"
PA_Horlift = "Platform Edge Doors"
PA_Horlift_Des = "Horlift, Closed type stations"

--SBPP
SBPP_ST1 = 		"ST1 (X=120-160 m)"
SBPP_ST2 = 		"ST2 (X=15-20 m)"
SBPP_OD = 		"OD"
SBPP_None = 	"None"
SBPP_BrakPos =  "Braking Pos."
SBPP_DL = 		"Deadend"
SBPP_DL_Des = 	"Deadend (Deadend Stop)"
SBPP_RP = 		"Right Pos (TRIGGERS UPPS)"
SBPP_RP_Des = 	"Right Position"
SBPP_RKP = 		"RK Position:"
SBPP_WT = 		"Work time (s):"

--Other
OT_X2 = 		"X-2"
OT_X3 = 		"X-3"
OT_T = 			"T"
OT_0 = 			"0"
OT_STID = 		"Station ID:"
OT_STID_Des = 	"Station Index (!stations)"
OT_OPV = 		"OPV"
OT_STT = 		"Station Track:"
OT_STT_Des = 	"Station Track Number"
OT_RD = 		"Right Doors"

--PlankCommand
PC_Right = 		"Right"
PC_5M = 		"5 m"
PC_20M = 		"20 m"
PC_50M = 		"50 m"
PC_STX2 = 		"Station X-2"
PC_STX3 = 		"Station X-3"
PC_0R = 		"0 Regulated"
PC_Route = 		"Route:"
PC_Route_Des = 	"Station Route"

--UPPS
UPPS_Roll = "Roll:"


--Types
Type_Signals = {[0] = "Choose Type","Signal","Sign","Autodrive (PAM)","Autostop","KGU"}
Type_Signal = {[0] = "Choose Type","Inside","Outside Big","Outside Small","Dwarf","Invisible","New Inside"}
Type_Signal_Route = {[0] = "Choose Type","Auto", "Manual","Repeater","Emergency"}
Type_Signs = {
	"NF (OF)","40 km/h","60 km/h","70 km/h","80 km/h",
	"Station Border","Street С (Horn)","Street STOP","Danger","Deadend (Night)",
	"OPV lighting","STOP (!)","EB Limit","T Start","T End","T Assemble","TED off","TED on","С (Horn)","EB start","Station Lift Down Device Sign",
	"Right Doors","Phone ▲","Phone ▼","UP1",
	"Street STOP cyka","Street НЧ(ОЧ)","Street 35 km/h","Street 40 km/h","Street 60 km/h","Street 70 km/h","Street 80 km/h",
	"Street Т Assemble","35 km/h","Danger 200 m","Third Rail End","Third Rail End (Inverted)","UP2","UP3","UP4","UP5 (No Model)","УП6",
	"Street EB Limit", "Metal structure","50 km/h","Street 50 km/h",
	"X-2",
	"ALS-0","ALS-NF",
	"013 End","334 End","X-2 Street (no textures)", "3","T1", "4","5","6","Street 5","Street 6",
	"PB Sign","10 km/h","25/40 km/h","35/60 km/h","40/70 km/h","Т Test","Т Test 100 m",

	"OPV","OPV 3 Cars","OPV 4 Cars","OPV 5 Cars","OPV 6 Cars","On-Track OPV"
}
Type_PAM = {
	[0] = "Choose Type","Commands (Plank)","Station Braking (Plank)", "Open Doors Command",
	"PA Light Sensor","PA Marker","UPPS Sensor","SBPP Sensor"
}
Type_Autostops = {[0] = "Choose Type","Separated", "Inertial", "Static", "Inertial single-acting"}