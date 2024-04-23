CREATE SCHEMA IF NOT EXISTS "violation";

CREATE  TABLE "violation".dim_datetime ( 
	datetime_id          INT  NOT NULL  ,
	"year"               INT    ,
	quarter              INT    ,
	"month"              INT    ,
	"day"                INT    ,
	monthname            VARCHAR(255)    ,
	dayname              VARCHAR(255)    ,
	weekofmonth          INT    ,
	weekofyear           INT    ,
	"hour"               INT    ,
	CONSTRAINT pk_dim_datetime PRIMARY KEY ( datetime_id )
 );

CREATE  TABLE "violation".dim_issuingagencytype ( 
	issuingagencytype_id INT    ,
	issuingagencytype    VARCHAR(255)    ,
	CONSTRAINT pk_issuingagencytype_id UNIQUE ( issuingagencytype_id ) ,
	CONSTRAINT pk_issuingagencytype_id_001 UNIQUE ( issuingagencytype_id ) 
 );

CREATE  TABLE "violation".dim_licensetype ( 
	licensetype_id       INT  NOT NULL  ,
	licensetype          VARCHAR(255)    ,
	CONSTRAINT pk_dim_licensetype PRIMARY KEY ( licensetype_id )
 );

CREATE  TABLE "violation".dim_location ( 
	location_id          INT  NOT NULL  ,
	"state"              VARCHAR(255)    ,
	precinct             VARCHAR(255)    ,
	county               VARCHAR(255)    ,
	CONSTRAINT pk_dim_location PRIMARY KEY ( location_id )
 );

CREATE  TABLE "violation".dim_violationtype ( 
	violationtype_id     INT    ,
	violationtype        VARCHAR(255)    ,
	CONSTRAINT pk_violationtype_id UNIQUE ( violationtype_id ) ,
	CONSTRAINT pk_violationtype_id_001 UNIQUE ( violationtype_id ) 
 );

CREATE  TABLE "violation".facts_violations ( 
	fact_id              BIGINT  NOT NULL  ,
	fine_amount          DECIMAL(5,2)    ,
	penalty_amount       DECIMAL(5,2)    ,
	interest_amount      DECIMAL(5,2)    ,
	reduction_amount     DECIMAL(5,2)    ,
	payment_amount       DECIMAL(5,2)    ,
	location_id          INT    ,
	licensetype_id       INT    ,
	datetime_id          INT    ,
	violationtype_id     INT    ,
	issuingagencytype_id INT    ,
	CONSTRAINT pk_facts_violations PRIMARY KEY ( fact_id )
 );
