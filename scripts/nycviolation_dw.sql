CREATE SCHEMA dw_nycviolation;

CREATE TABLE nycviolation_dw_lgl.INSTANCE.Facts_violations ( 
	Fact_ID int64 NOT NULL  ,
	Fine_Amount numeric  ,
	Penalty_Amount numeric  ,
	Interest_Amount numeric  ,
	Reduction_Amount numeric  ,
	Payment_Amount numeric  ,
	Location_ID int64  ,
	LicenseType_ID int64  ,
	Datetime_ID int64  ,
	ViolationType_ID int64  ,
	IssuingAgencyType_ID int64  
 );

ALTER TABLE nycviolation_dw_lgl.INSTANCE.Facts_violations ADD PRIMARY KEY ( Fact_ID )  NOT ENFORCED;

CREATE TABLE nycviolation_dw_lgl.INSTANCE.dim_Datetime ( 
	Datetime_ID int64 NOT NULL  ,
	Year int64  ,
	Quarter int64  ,
	Month int64  ,
	Day int64  ,
	MonthName string  ,
	DayName string  ,
	WeekOfMonth int64  ,
	WeekOfYear int64  ,
	Hour int64  
 );

ALTER TABLE nycviolation_dw_lgl.INSTANCE.dim_Datetime ADD PRIMARY KEY ( Datetime_ID )  NOT ENFORCED;

CREATE TABLE nycviolation_dw_lgl.INSTANCE.dim_IssuingAgencyType ( 
	IssuingAgencyType_ID int64  ,
	IssuingAgencyType string  
 );

CREATE TABLE nycviolation_dw_lgl.INSTANCE.dim_LicenseType ( 
	LicenseType_ID int64 NOT NULL  ,
	LicenseType string  
 );

ALTER TABLE nycviolation_dw_lgl.INSTANCE.dim_LicenseType ADD PRIMARY KEY ( LicenseType_ID )  NOT ENFORCED;

CREATE TABLE nycviolation_dw_lgl.INSTANCE.dim_Location ( 
	Location_ID int64 NOT NULL  ,
	State string  ,
	Precinct string  ,
	County string  
 );

ALTER TABLE nycviolation_dw_lgl.INSTANCE.dim_Location ADD PRIMARY KEY ( Location_ID )  NOT ENFORCED;

CREATE TABLE nycviolation_dw_lgl.INSTANCE.dim_ViolationType ( 
	ViolationType_ID int64  ,
	ViolationType string  
 );
