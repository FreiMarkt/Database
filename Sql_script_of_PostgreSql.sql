I have made a lot of modifications based on the sql scripts of MySql, include some combination of tables and modifications
of attributes, the size of data types, etc. So I suggest you to use PostgreSql with this version of sql script.
Firstly, you should create database; Then you can paste all the scripts from "create table feedback" at one time
by removing the star line; [after connect to the pgAdmin III， you can open the "Query", paste them on it]
********************************************************************
-- Database: "TimeBankDB"

-- DROP DATABASE "TimeBankDB";

CREATE DATABASE "TimeBankDB"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;
************************************************************

-- Table: "Feedbacks"

-- DROP TABLE "Feedbacks";

CREATE TABLE "Feedbacks"
(
  feedback text NOT NULL, -- a detail of positive and negative feedbacks related to the user
  feedbackid character varying(15) NOT NULL, -- unique for each feedbacks
  memberid character varying(15)[] NOT NULL,
  CONSTRAINT "FeedbackPK" PRIMARY KEY (feedbackid),
  CONSTRAINT "FeedbackFK" FOREIGN KEY (memberid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Feedbacks"
  OWNER TO postgres;
COMMENT ON TABLE "Feedbacks"
  IS 'feedbacks related to each member: postive as well as negative';
COMMENT ON COLUMN "Feedbacks".feedback IS 'a detail of positive and negative feedbacks related to the user';
COMMENT ON COLUMN "Feedbacks".feedbackid IS 'unique for each feedbacks';
************************************************************
-- Table: "JobPosting"

-- DROP TABLE "JobPosting";

CREATE TABLE "JobPosting"
(
  accountno character varying(15)[] NOT NULL, -- unique for each active member
  jobcategory character varying(20)[] NOT NULL, -- division of jobs according to their nature
  jobid character varying(15)[] NOT NULL, -- according to when the job was posted, a unique ID is given for each job
  memberid character varying(15)[] NOT NULL,
  postingdate date NOT NULL, -- Date when the job was posted
  CONSTRAINT "JobPostingFK" FOREIGN KEY (accountno)
      REFERENCES personalaccount (accountno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "JobPostingFK2" FOREIGN KEY (jobid)
      REFERENCES "Jobs" (jobid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "JobPostingFK3" FOREIGN KEY (memberid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "JobPosting"
  OWNER TO postgres;
COMMENT ON COLUMN "JobPosting".accountno IS 'unique for each active member';
COMMENT ON COLUMN "JobPosting".jobcategory IS 'division of jobs according to their nature';
COMMENT ON COLUMN "JobPosting".jobid IS 'according to when the job was posted, a unique ID is given for each job';
COMMENT ON COLUMN "JobPosting".postingdate IS 'Date when the job was posted';

******************************************************************
-- Table: "Jobs"

-- DROP TABLE "Jobs";

CREATE TABLE "Jobs"
(
  offererid character varying(15)[] NOT NULL, -- id of the person who is offering the job
  jobcategory character varying(20)[] NOT NULL,
  jobid character varying(15)[] NOT NULL, -- unique for each job posted
  availabledate date NOT NULL, -- date from which the job is available to carry out
  jobduration numeric(6,2) NOT NULL, -- date within which the job is available
  jobdescription text,
  jobrequirements text NOT NULL, -- special qualities needed for the job
  finishdate date NOT NULL, -- date when the job is expected to finish
  jobaddress text NOT NULL, -- place to do the job
  jobname character varying(50)[] NOT NULL, -- specification of the job
  CONSTRAINT "JobsPK" PRIMARY KEY (jobid),
  CONSTRAINT "JobsFK" FOREIGN KEY (offererid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Jobs"
  OWNER TO postgres;
COMMENT ON COLUMN "Jobs".offererid IS 'id of the person who is offering the job';
COMMENT ON COLUMN "Jobs".jobid IS 'unique for each job posted';
COMMENT ON COLUMN "Jobs".availabledate IS 'date from which the job is available to carry out';
COMMENT ON COLUMN "Jobs".jobduration IS 'date within which the job is available';
COMMENT ON COLUMN "Jobs".jobrequirements IS 'special qualities needed for the job';
COMMENT ON COLUMN "Jobs".finishdate IS 'date when the job is expected to finish';
COMMENT ON COLUMN "Jobs".jobaddress IS 'place to do the job';
COMMENT ON COLUMN "Jobs".jobname IS 'specification of the job';
*************************************************************************************
-- Table: "SkillPosting"

-- DROP TABLE "SkillPosting";

CREATE TABLE "SkillPosting"
(
  memberid character varying(15)[] NOT NULL, -- unique for each active member
  accountno character varying(15)[] NOT NULL, -- unique for each active member. must use this during transactions
  postingdate date NOT NULL, -- Date when the skill was posted
  spcomment text, -- About timing and other criteria
  skillid character varying(15)[] NOT NULL, -- unique for each different skill posted
  skillcategory character varying(20)[] NOT NULL, -- division of skill according to their nature
  CONSTRAINT "SkillPostingFK" FOREIGN KEY (memberid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "SkillPostingFK2" FOREIGN KEY (accountno)
      REFERENCES personalaccount (accountno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "SkillPostingFK3" FOREIGN KEY (skillid)
      REFERENCES "Skills" (skillid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "SkillPosting"
  OWNER TO postgres;
COMMENT ON COLUMN "SkillPosting".memberid IS 'unique for each active member';
COMMENT ON COLUMN "SkillPosting".accountno IS 'unique for each active member. must use this during transactions
';
COMMENT ON COLUMN "SkillPosting".postingdate IS 'Date when the skill was posted';
COMMENT ON COLUMN "SkillPosting".spcomment IS 'About timing and other criteria';
COMMENT ON COLUMN "SkillPosting".skillid IS 'unique for each different skill posted
';
COMMENT ON COLUMN "SkillPosting".skillcategory IS 'division of skill according to their nature';


-- Index: "fki_SkillPostingFK"

-- DROP INDEX "fki_SkillPostingFK";

CREATE INDEX "fki_SkillPostingFK"
  ON "SkillPosting"
  USING btree
  (memberid COLLATE pg_catalog."default");

-- Index: "fki_SkillPostingFK2"

-- DROP INDEX "fki_SkillPostingFK2";

CREATE INDEX "fki_SkillPostingFK2"
  ON "SkillPosting"
  USING btree
  (accountno COLLATE pg_catalog."default");

-- Index: "fki_SkillPostingFK3"

-- DROP INDEX "fki_SkillPostingFK3";

CREATE INDEX "fki_SkillPostingFK3"
  ON "SkillPosting"
  USING btree
  (skillid COLLATE pg_catalog."default");

***********************************************************************
-- Table: "Skills"

-- DROP TABLE "Skills";

CREATE TABLE "Skills"
(
  skillid character varying(15)[] NOT NULL, -- unique for each skill
  skilldescription text NOT NULL, -- detail of the skills
  skillname character varying(20)[] NOT NULL,
  skillcategory character varying(20)[] NOT NULL,
  workerid character varying(15)[] NOT NULL, -- unique for each active member
  CONSTRAINT "SkillsPK" PRIMARY KEY (skillid),
  CONSTRAINT "SkillsFK" FOREIGN KEY (workerid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Skills"
  OWNER TO postgres;
COMMENT ON COLUMN "Skills".skillid IS 'unique for each skill';
COMMENT ON COLUMN "Skills".skilldescription IS 'detail of the skills';
COMMENT ON COLUMN "Skills".workerid IS 'unique for each active member
';


-- Index: "fki_SkillsFK"

-- DROP INDEX "fki_SkillsFK";

CREATE INDEX "fki_SkillsFK"
  ON "Skills"
  USING btree
  (workerid COLLATE pg_catalog."default");

****************************************************************************************
-- Table: confirmation

-- DROP TABLE confirmation;

CREATE TABLE confirmation
(
  workerid character varying(15)[] NOT NULL,
  offererid character varying(15)[] NOT NULL,
  jobid character varying(15)[] NOT NULL,
  confirmationdate date NOT NULL, -- date when the agreement is done between offerer and worker
  CONSTRAINT "ConfirmationFK" FOREIGN KEY (workerid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ConfirmationFK2" FOREIGN KEY (offererid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ConfirmationFK3" FOREIGN KEY (jobid)
      REFERENCES "Jobs" (jobid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE confirmation
  OWNER TO postgres;
COMMENT ON COLUMN confirmation.confirmationdate IS 'date when the agreement is done between offerer and worker
';


-- Index: "fki_ConfirmationFK"

-- DROP INDEX "fki_ConfirmationFK";

CREATE INDEX "fki_ConfirmationFK"
  ON confirmation
  USING btree
  (workerid COLLATE pg_catalog."default");

-- Index: "fki_ConfirmationFK2"

-- DROP INDEX "fki_ConfirmationFK2";

CREATE INDEX "fki_ConfirmationFK2"
  ON confirmation
  USING btree
  (offererid COLLATE pg_catalog."default");

-- Index: "fki_ConfirmationFK3"

-- DROP INDEX "fki_ConfirmationFK3";

CREATE INDEX "fki_ConfirmationFK3"
  ON confirmation
  USING btree
  (jobid COLLATE pg_catalog."default");

********************************************************************************************
-- Table: jobstatus

-- DROP TABLE jobstatus;

CREATE TABLE jobstatus
(
  jobid character varying(15)[] NOT NULL,
  jobstatus smallint NOT NULL DEFAULT 0, -- 0=free, 1=reserved, 2=completed
  CONSTRAINT "JobStatusFK" FOREIGN KEY (jobid)
      REFERENCES "Jobs" (jobid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE jobstatus
  OWNER TO postgres;
COMMENT ON COLUMN jobstatus.jobstatus IS '0=free, 1=reserved, 2=completed';


-- Index: "fki_JobStatusFK"

-- DROP INDEX "fki_JobStatusFK";

CREATE INDEX "fki_JobStatusFK"
  ON jobstatus
  USING btree
  (jobid COLLATE pg_catalog."default");

*****************************************************************************************
-- Table: member

-- DROP TABLE member;

CREATE TABLE member
(
  memberid character varying(15)[] NOT NULL, -- it is the primary key for identify each passivemember.
  username character varying(25)[] NOT NULL, -- It is the name of passivemember
  ppassword character varying(16)[] NOT NULL, -- It is password when member login, the length of it should >6 and <16
  age smallint NOT NULL,
  gender boolean NOT NULL DEFAULT true, -- true="Male", false="Female"
  address text NOT NULL, -- It is the recent address of passivemember.
  email character varying(30)[] NOT NULL, -- The email address should contains "@".
  phonenumber character varying(20) NOT NULL, -- it is the phone number which can be reached.
  paymentstatus boolean NOT NULL DEFAULT true, -- It is the payment status of membership fee, true=paid, false=unpaid.
  fiftyfivemember boolean NOT NULL DEFAULT true, -- If your age>55, then you are 55+Member, the status is true, otherwise, the status is false.
  postalcode character varying(15)[] NOT NULL, -- It is the postal code for your recent address.
  birthday date NOT NULL,
  roleid smallint NOT NULL DEFAULT 3, -- 1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 

5=teller, 6=system administator
  CONSTRAINT "PassiveMemberPK" PRIMARY KEY (memberid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE member
  OWNER TO postgres;
COMMENT ON TABLE member
  IS 'Member is the one who has paid the membership fee, and participate in the transactions. There are two types of member: passivemember and activemember.';
COMMENT ON COLUMN member.memberid IS 'it is the primary key for identify each passivemember.';
COMMENT ON COLUMN member.username IS 'It is the name of passivemember';
COMMENT ON COLUMN member.ppassword IS 'It is password when member login, the length of it should >6 and <16';
COMMENT ON COLUMN member.gender IS 'true="Male", false="Female"';
COMMENT ON COLUMN member.address IS 'It is the recent address of passivemember.';
COMMENT ON COLUMN member.email IS 'The email address should contains "@".';
COMMENT ON COLUMN member.phonenumber IS 'it is the phone number which can be reached.';
COMMENT ON COLUMN member.paymentstatus IS 'It is the payment status of membership fee, true=paid, false=unpaid.';
COMMENT ON COLUMN member.fiftyfivemember IS 'If your age>55, then you are 55+Member, the status is true, otherwise, the status is false.';
COMMENT ON COLUMN member.postalcode IS 'It is the postal code for your recent address.';
COMMENT ON COLUMN member.roleid IS '1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 5=teller, 

6=system administator';

************************************************************************************************
-- Table: modifyreceipts

-- DROP TABLE modifyreceipts;

CREATE TABLE modifyreceipts
(
  offererid character varying(15)[] NOT NULL, -- specific ID for each job provider
  hours numeric(6,2) NOT NULL, -- total amount of hours agreed to be paid to the worker
  completiondate date NOT NULL, -- date the job is completed or agreed to be completed
  transactionid character varying(15)[] NOT NULL -- unique for each transaction
)
WITH (
  OIDS=FALSE
);
ALTER TABLE modifyreceipts
  OWNER TO postgres;
COMMENT ON COLUMN modifyreceipts.offererid IS 'specific ID for each job provider';
COMMENT ON COLUMN modifyreceipts.hours IS 'total amount of hours agreed to be paid to the worker';
COMMENT ON COLUMN modifyreceipts.completiondate IS 'date the job is completed or agreed to be completed';
COMMENT ON COLUMN modifyreceipts.transactionid IS 'unique for each transaction';

*****************************************************************************************
-- Table: offerercontact

-- DROP TABLE offerercontact;

CREATE TABLE offerercontact
(
  offereid character varying(15)[] NOT NULL,
  email text NOT NULL,
  address text NOT NULL,
  phonenumber character varying(20)[] NOT NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE offerercontact
  OWNER TO postgres;
****************************************************************************************
-- Table: personalaccount

-- DROP TABLE personalaccount;

CREATE TABLE personalaccount
(
  accountno character varying(15)[] NOT NULL, -- It is your personal account number which is assigned randomly by system.
  memberid character varying(15)[] NOT NULL, -- It is the foreign key which can connect the member table.
  sumhours numeric(6,2)[] NOT NULL, -- It is the sum of hours which earned by you. After you pay membership fee, you will get three hours at the first time.
  transactionid character varying(15)[] NOT NULL, -- It is ID of each transaction.
  CONSTRAINT "PersonalAccountPK" PRIMARY KEY (accountno),
  CONSTRAINT "PersonalAccountFK1" FOREIGN KEY (memberid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "PersonalAccountFK2" FOREIGN KEY (transactionid)
      REFERENCES transaction (transactionid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE personalaccount
  OWNER TO postgres;
COMMENT ON COLUMN personalaccount.accountno IS 'It is your personal account number which is assigned randomly by system.';
COMMENT ON COLUMN personalaccount.memberid IS 'It is the foreign key which can connect the member table.';
COMMENT ON COLUMN personalaccount.sumhours IS 'It is the sum of hours which earned by you. After you pay membership fee, you will get three hours at the first time.';
COMMENT ON COLUMN personalaccount.transactionid IS 'It is ID of each transaction.';

*********************************************************************************************************
-- Table: profileverification

-- DROP TABLE profileverification;

CREATE TABLE profileverification
(
  memberid character varying(15)[] NOT NULL,
  tellerid character varying(15)[] NOT NULL,
  verificationdate date NOT NULL, -- it is the date of verification
  verificationstatus boolean NOT NULL DEFAULT true, -- true=pass;...
  CONSTRAINT "ProfileVerificationFK" FOREIGN KEY (memberid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ProfileVerificationFK2" FOREIGN KEY (tellerid)
      REFERENCES teller (tellerid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE profileverification
  OWNER TO postgres;
COMMENT ON TABLE profileverification
  IS 'it is a table of member profile verification record.';
COMMENT ON COLUMN profileverification.verificationdate IS 'it is the date of verification';
COMMENT ON COLUMN profileverification.verificationstatus IS 'true=pass;
false=failure';
**************************************************************************************************************
-- Table: receipt

-- DROP TABLE receipt;

CREATE TABLE receipt
(
  "offererID" character varying(15)[] NOT NULL,
  recipientid character varying(15)[] NOT NULL,
  recipientaccountno character varying(15)[] NOT NULL, -- It is the account number of recipient.
  offereraccountno character varying[] NOT NULL, -- it is the account number of offerer.
  transactionid character varying(15)[] NOT NULL,
  workinghours numeric(6,2)[] NOT NULL,
  signdate date NOT NULL, -- it is the date of signing the receipt.
  CONSTRAINT "ReceiptFK" FOREIGN KEY ("offererID")
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ReceiptFK2" FOREIGN KEY (recipientid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ReceiptFK3" FOREIGN KEY (recipientaccountno)
      REFERENCES personalaccount (accountno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ReceiptFK4" FOREIGN KEY (offereraccountno)
      REFERENCES personalaccount (accountno) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ReceiptFK5" FOREIGN KEY (transactionid)
      REFERENCES transaction (transactionid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE receipt
  OWNER TO postgres;
COMMENT ON TABLE receipt
  IS 'receipt is a paper which records the details of each transaction';
COMMENT ON COLUMN receipt.recipientaccountno IS 'It is the account number of recipient.';
COMMENT ON COLUMN receipt.offereraccountno IS 'it is the account number of offerer.';
COMMENT ON COLUMN receipt.signdate IS 'it is the date of signing the receipt.';

**************************************************************************************************
-- Table: receiptmodification

-- DROP TABLE receiptmodification;

CREATE TABLE receiptmodification
(
  tellerid character varying(15)[] NOT NULL,
  transactionid character varying(15)[] NOT NULL,
  ddescription text, -- it is the description about where and what you have modified.
  modificationdate date NOT NULL, -- it is the date of receipt modification
  CONSTRAINT "ReceiptModificationFK" FOREIGN KEY (tellerid)
      REFERENCES teller (tellerid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "ReceiptModificationFK2" FOREIGN KEY (transactionid)
      REFERENCES transaction (transactionid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE receiptmodification
  OWNER TO postgres;
COMMENT ON TABLE receiptmodification
  IS 'It is the table of receipt modification.';
COMMENT ON COLUMN receiptmodification.ddescription IS 'it is the description about where and what you have modified.';
COMMENT ON COLUMN receiptmodification.modificationdate IS 'it is the date of receipt modification';

************************************************************************************************************************************
-- Table: supervision

-- DROP TABLE supervision;

CREATE TABLE supervision
(
  tellerid character varying(15)[] NOT NULL,
  memberid character varying(15)[] NOT NULL,
  feedbackid character varying(15) NOT NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE supervision
  OWNER TO postgres;
COMMENT ON TABLE supervision
  IS 'it is a table about teller supervise member''s behaviors';
*****************************************************************************************************
-- Table: systemadministrator

-- DROP TABLE systemadministrator;

CREATE TABLE systemadministrator
(
  adminid character varying(15)[] NOT NULL, -- It is the ID of administrator.
  adminname character varying(15)[] NOT NULL, -- the name of administrator
  ppassword character varying(16)[] NOT NULL, -- the length of password should >6 and <16
  email character varying(30)[] NOT NULL, -- should contain @
  phonenumber character varying(20)[] NOT NULL,
  roleid smallint NOT NULL DEFAULT 6 -- 1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 

5=teller, 6=system administator
)
WITH (
  OIDS=FALSE
);
ALTER TABLE systemadministrator
  OWNER TO postgres;
COMMENT ON TABLE systemadministrator
  IS 'it is system administrator';
COMMENT ON COLUMN systemadministrator.adminid IS 'It is the ID of administrator.';
COMMENT ON COLUMN systemadministrator.adminname IS 'the name of administrator';
COMMENT ON COLUMN systemadministrator.ppassword IS 'the length of password should >6 and <16';
COMMENT ON COLUMN systemadministrator.email IS 'should contain @';
COMMENT ON COLUMN systemadministrator.roleid IS '1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user 

(55+account), 5=teller, 6=system administator';

*********************************************************************************************************************
-- Table: teller

-- DROP TABLE teller;

CREATE TABLE teller
(
  tellerid character varying(15)[] NOT NULL, -- It is the ID which assigned by system randomly of teller.
  tellername character varying(25)[] NOT NULL, -- it is the name of teller
  ppassword character varying(16)[] NOT NULL, -- the length of it should >6 and <16
  email character varying(30)[] NOT NULL,
  phonenumber character varying(20)[] NOT NULL,
  roleid smallint NOT NULL DEFAULT 4, -- 1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 

5=teller, 6=system administator
  CONSTRAINT "TellerPK" PRIMARY KEY (tellerid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE teller
  OWNER TO postgres;
COMMENT ON TABLE teller
  IS 'Teller is a kind of administrators, he is responsible for the verifications and modification of members profiles and time-checks.';
COMMENT ON COLUMN teller.tellerid IS 'It is the ID which assigned by system randomly of teller.';
COMMENT ON COLUMN teller.tellername IS 'it is the name of teller';
COMMENT ON COLUMN teller.ppassword IS 'the length of it should >6 and <16';
COMMENT ON COLUMN teller.roleid IS '1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 5=teller, 

6=system administator';

******************************************************************************************************************
-- Table: transaction

-- DROP TABLE transaction;

CREATE TABLE transaction
(
  transactionid character varying(15)[] NOT NULL, -- it is the id which assigned by system randomly of each transaction.
  transactionname character varying(50)[] NOT NULL,
  ddescription text, -- it is the description of each transaction.
  workinghour numeric(6,2)[] NOT NULL, -- each transaction has specific hours used for exchanging.
  offererid character varying(15)[] NOT NULL, -- it is the ID of member who provide the job.
  recipientid character varying(15)[] NOT NULL, -- it is the ID of member who recieve the job.
  transactionstatus boolean NOT NULL DEFAULT true, -- true=done; false=undone
  transactiontime date NOT NULL, -- it is the time of when transaction is done
  CONSTRAINT "TransactionPK" PRIMARY KEY (transactionid),
  CONSTRAINT "TransactionFK1" FOREIGN KEY (offererid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "TransactionFK2" FOREIGN KEY (recipientid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE transaction
  OWNER TO postgres;
COMMENT ON TABLE transaction
  IS 'It is the transaction details which record each peice of transaction.';
COMMENT ON COLUMN transaction.transactionid IS 'it is the id which assigned by system randomly of each transaction.';
COMMENT ON COLUMN transaction.ddescription IS 'it is the description of each transaction.';
COMMENT ON COLUMN transaction.workinghour IS 'each transaction has specific hours used for exchanging.';
COMMENT ON COLUMN transaction.offererid IS 'it is the ID of member who provide the job.';
COMMENT ON COLUMN transaction.recipientid IS 'it is the ID of member who recieve the job.';
COMMENT ON COLUMN transaction.transactionstatus IS 'true=done; false=undone';
COMMENT ON COLUMN transaction.transactiontime IS 'it is the time of when transaction is done';

*************************************************************************************************************
-- Table: verifytimechecks

-- DROP TABLE verifytimechecks;

CREATE TABLE verifytimechecks
(
  offererid character varying(15)[] NOT NULL,
  workerid character varying(15)[] NOT NULL,
  transactionid character varying(15)[] NOT NULL,
  verificationdate date NOT NULL, -- date when the payment of time check is verified
  CONSTRAINT "verifyTimecheckFK" FOREIGN KEY (offererid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "verifyTimecheckFk2" FOREIGN KEY (workerid)
      REFERENCES member (memberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "verifyTimecheckFk3" FOREIGN KEY (transactionid)
      REFERENCES transaction (transactionid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE verifytimechecks
  OWNER TO postgres;
COMMENT ON COLUMN verifytimechecks.verificationdate IS 'date when the payment of time check is verified';


-- Index: "fki_verifyTimecheckFK"

-- DROP INDEX "fki_verifyTimecheckFK";

CREATE INDEX "fki_verifyTimecheckFK"
  ON verifytimechecks
  USING btree
  (offererid COLLATE pg_catalog."default");

-- Index: "fki_verifyTimecheckFk2"

-- DROP INDEX "fki_verifyTimecheckFk2";

CREATE INDEX "fki_verifyTimecheckFk2"
  ON verifytimechecks
  USING btree
  (workerid COLLATE pg_catalog."default");

-- Index: "fki_verifyTimecheckFk3"

-- DROP INDEX "fki_verifyTimecheckFk3";

CREATE INDEX "fki_verifyTimecheckFk3"
  ON verifytimechecks
  USING btree
  (transactionid COLLATE pg_catalog."default");

*********************************************************************************************

