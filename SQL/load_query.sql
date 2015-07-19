
-- NOTE THAT WE REMOVED NA's from the tables to enforce variable types. Also removed the .0 at the end of the dates

drop table if exists sandbox.topic_indicators; 

create table sandbox.topic_indicators(
"topic_id" int,
"topic_word" text
)
;

COPY sandbox.topic_indicators FROM '/Users/Rishi/Desktop/DATA/topic_indicators.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.contact; 

CREATE TABLE sandbox.contact (
"id" int,
"dob" TIMESTAMP,	
"ismale" boolean,	
"ethnicityref" text,	
"jobtitle" text,	
"crb" boolean,	
"crbdate" TIMESTAMP,	
"membershiprenewaldate"  TIMESTAMP,	
"islapsedmember" boolean, 
"istrainer" boolean,
"latitude" float,
"longitude" float
)
;

COPY sandbox.contact FROM '/Users/Rishi/Desktop/DATA/contact.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.contactorganisation; 
CREATE TABLE sandbox.contactorganisation(
"id" int,
"contactid" int,
"organisationid" int,
"ismain" boolean,
"isinvoice" boolean
);

COPY sandbox.contactorganisation FROM '/Users/Rishi/Desktop/DATA/contactorganisation.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.facilitatorevents;
CREATE TABLE sandbox.facilitatorevents(
"contactid" int,
"datestamp" timestamp,
"description" text,
"projectid" int
);

COPY sandbox.facilitatorevents FROM '/Users/Rishi/Desktop/DATA/facilitatorevents.csv' DELIMITER ',' CSV HEADER;


drop table if exists sandbox.group;
CREATE TABLE sandbox.group(
"id" int,
"name" text,
"organisationid" int,
"zoneid" int,
"type" int,
"OtherActivity" text,
"OtherOrgType" text
);

COPY sandbox.group FROM '/Users/Rishi/Desktop/DATA/group.csv' DELIMITER ',' CSV HEADER;


drop table if exists sandbox.groupmember;
CREATE TABLE sandbox.groupmember(
"id" int,
"dob" timestamp,
"ismale" boolean,
"ethnicityref" text,
"disabilityref" text,
"latitude" float,
"longitude" float
);

COPY sandbox.groupmember FROM '/Users/Rishi/Desktop/DATA/groupmember.csv' DELIMITER ',' CSV HEADER;


drop table if exists sandbox.groupproject;
CREATE TABLE sandbox.groupproject(
"id" int,
"groupid" int,
"name" text,
"stage" int,
"potfundperiodid" int,
"potfundamount" float,
"contactid" int,
"registered" timestamp,
"nobenefiting" int,
"paneldate" timestamp,
"description" text,
"panelbudget" boolean,
"panelreport" boolean,
"panelinvoice" boolean,
"evaluationfacilitator" boolean,
"evaluationgroup" boolean,
"evaluationreceipts" boolean,
"evaluationproceeding" boolean,
"evaluationcertificates" boolean,
"groupprojecthistoryid" int,
"groupprojectevaluationfacilitatorid" int,
"groupprojectpanelreportid" int,
"groupprojectpanelinvoiceid" int,
"panelstyle" text,
"ishistorysubmitted" boolean,
"iscostsubmitted" boolean,
"ispanelreportsubmitted" boolean,
"ispanelinvoicesubmitted" boolean,
"isfacilitatorevaluationsubmitted" boolean,
"isecmsubmitted" boolean,
"isfundreturnsubmitted" boolean,
"statustimestamp" timestamp,
"panellocation" text,
"minimummembers" int,
"isendskillwheel" boolean,
"isindividualplanning" boolean,
"chequenotes" text,
"licenseholderid" int,
"keyfundstage" int,
"projectissues" text,
"howwillprojecttackleissues" text,
"allmembersnotified" boolean,
"datefacilitatorevalcompleted" timestamp,
"projectsubmitteddate" timestamp
);

COPY sandbox.groupproject FROM '/Users/Rishi/Desktop/DATA/groupproject.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.groupprojectmember;
CREATE TABLE sandbox.groupprojectmember(
"id" int,
"groupmemberid" int,
"groupprojectid" int,
"groupprojectmemberindividualplanningid" int,
"registered" timestamp,
"ncsparticipant" int,
"isineducation" boolean,
"ispreviouslyinvolved" boolean,
"ispublicconsent" boolean
);

COPY sandbox.groupprojectmember FROM '/Users/Rishi/Desktop/DATA/groupprojectmember.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.groupprojectfacilitatorevaluation;
CREATE TABLE sandbox.groupprojectfacilitatorevaluation(
"id" int,	
"howworkedfor" text,	
"howsupported" text,	
"groupbenfited" text,	
"hintstips" text,	
"howmanybenefited" int,	
"progressedvolunteer" int,	
"progressedtraining" int,	
"progressedemployment" int,	
"progressededucation" int,	
"disadvantaged" int,	
"accredited" text,	
"numberaccredited" int,	
"isprogressed" int,	
"notprogressed" text,	
"hoursinvolvedinsaf" int
);

COPY sandbox.groupprojectfacilitatorevaluation FROM '/Users/Rishi/Desktop/DATA/groupprojectfacilitatorevaluation.csv' DELIMITER ',' CSV HEADER;


drop table if exists sandbox.groupprojectmemberskillwheel;
CREATE TABLE sandbox.groupprojectmemberskillwheel(
"id" int,
"groupprojectmemberid" int,
"isbefore" boolean,
"isafter" boolean,
"timestamp" timestamp
);

COPY sandbox.groupprojectmemberskillwheel FROM '/Users/Rishi/Desktop/DATA/groupprojectmemberskillwheel.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.groupprojectmemberskillwheelitem;
CREATE TABLE sandbox.groupprojectmemberskillwheelitem(
"id" int,
"groupprojectmemberskillwheelid" int,
"reference" text,
"value" int
);

COPY sandbox.groupprojectmemberskillwheelitem FROM '/Users/Rishi/Desktop/DATA/groupprojectmemberskillwheelitem.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.groupprojecttype;
CREATE TABLE sandbox.groupprojecttype(
"id" int,
"groupprojectid" int,
"type" text
);

COPY sandbox.groupprojecttype FROM '/Users/Rishi/Desktop/DATA/groupprojecttype.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.note;
CREATE TABLE sandbox.note(
"id" int,
"subject" text,
"body" text,
"groupprojectid" int
);

COPY sandbox.note FROM '/Users/Rishi/Desktop/DATA/note.csv' DELIMITER ',' CSV HEADER;


drop table if exists sandbox.organisation;
CREATE TABLE sandbox.organisation(
"id" int,
"name" text,
"postcode" text,
"latitude" float,
"longitude" float
);

COPY sandbox.organisation FROM '/Users/Rishi/Desktop/DATA/organisation.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.trainingdate;
CREATE TABLE sandbox.trainingdate(
"id" int,
"trainingid" int,
"licenseholderid" int,
"date" timestamp,
"starttime" timestamp,
"endtime" timestamp,
"venueid" int,
"contactid" int,
"isactive" boolean,
"description" text
);

COPY sandbox.trainingdate FROM '/Users/Rishi/Desktop/DATA/trainingdate.csv' DELIMITER ',' CSV HEADER;

drop table if exists sandbox.trainingdatebooking;
CREATE TABLE sandbox.trainingdatebooking(
 "id" int,
"trainingdateid" int,
"contactid" int,
"amount" float,
"invited" boolean,
"paid" boolean,
"attended" boolean,
"invoiced" boolean,
"iscancelled" boolean,
"isemailed" boolean
);

COPY sandbox.trainingdatebooking FROM '/Users/Rishi/Desktop/DATA/trainingdatebooking.csv' DELIMITER ',' CSV HEADER;
