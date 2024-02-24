SELECT * FROM ssis.ScriptComplete sc  

-- mgdw.Plex.Detailed_Production_History definition

-- Drop table

-- DROP TABLE mgdw.Plex.Detailed_Production_History;

CREATE TABLE repsys.Plex.Detailed_Production_History (
	PCN int NOT NULL,
	Production_No int NOT NULL,
	Workcenter_Code nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Part_No nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Part_Key int NOT NULL,
	Revision nvarchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Heat_Code_Heat_No nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Piece_Weight decimal(19,5) NULL,
	Net_Weight decimal(19,5) NULL,
	Material_Code nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Serial_No nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Record_Date datetime2 NOT NULL,
	Sample_Weight decimal(19,5) NULL,
	Quantity decimal(19,5) NOT NULL,
	Gross_Weight decimal(19,5) NULL,
	Tare_Weight decimal(19,5) NULL,
	Shift nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Workcenter_Type nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Standard_Production_Rate decimal(18,0) NULL,
	Operation_Code nvarchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Note nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Job_No nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tracking_No nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Master_Unit_No nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Location nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
);