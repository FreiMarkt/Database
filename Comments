/*
This is the actual code that was executed in the DB server.
Also, it has comments what was changed.
Pay attention and try to avoid such mistakes in the future.
*/


/* there is no data type 'datetime' I've replaced it by 'date' */
create table Passivemember (
MemberID Char(15)  primary key not null, /*The memberID is genarated by the system randomly and be assigned to members*/
Username Char(15) not null,
ppassword Char(16) not null, /*The length of password should be >6 and >15, should contains numbers and letters*/
age      Int      not null,
gender   bit  not null, /*if gender=1, then gender="male", else if gender=0, then gender="female"*/
address  Char(200) not null,
email    Char(30)  not null, /*the email address should contain "@"*/
phonenumber Char(12) not null,
paymentStatus bit  not null, /*if paymentstatus=1, then paymentstatus="paid", else if paymentstatus=0, then paymentstatus="unpaid"*/
FiftyfiveMember bit  not null,/*if FiftyfiveMember=1, then FiftyfiveMember="Yes", else if FiftyfiveMember=0, then FiftyfiveMember="No"*/
postalCode Char(15) not null,
Birthday  date  not null, /*the format of Birthday should be like that "yyyymmdd"*/
RoleID    Int       not null /*1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 5=Other time banks, 6=Organizations*/
)

/* NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "passivemember_pkey" for table "passivemember"

Query returned successfully with no result in 464 ms. */

/* Pay attention to type "bit" and its syntax */
/* SQL standard is to write "insert into <table name>" not "insert <table name>" */
insert into Passivemember values ('001', 'Derick Chow','070667',23,B'1', 'Yliopistokatu 16 503,Oulu,Finland','yongzhou1314@gmail.com','0414938862',B'1',B'0','90570','19911028',1)

/* no type datetime */
create table ActiveMember (
memberID char(15)    not null primary key,/*Because MemberID is unique,one ID belongs to one member,it can identify the member, so it is primary key*/
username char(50)    not null,
ppassword char(16)    not null,
age      int         not null,
gender   bit  not null,
address  char(200)   not null,
email    char(30)    not null,
phonenumber char(12) not null,
accountNo char(15) not null, /*The AccountNo is genarated by the system randomly and be assigned to members*/
FiftyfiveMember bit  not null, /*if FiftyfiveMember=1, then FiftyfiveMember="Yes", else if FiftyfiveMember=0, then FiftyfiveMember="No"*/
postalcode char(15)   not null,
Birthday date    not null,
RoleID   int         not null/*1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 5=Other time banks, 6=Organizations*/
)	

/* Same problems as per last insert statement */
insert into activemember values ('002', 'Fang Xin','fangxin1104',21,B'0', 'Yliopistokatu 16 303,Oulu,Finland','fangxin1104@gmail.com','0414938867','78768237',B'1','90570','19911028',1)

create table Teller(
RoleID  Int not null,
TellerName Char(50) not null,
ppassword   Char(15) not null,
TellerID   Char(15) not null primary key,
email      Char(30) not null,
Phonenumber Char(12) not null
)

/* datetime replaced with date */
create table Verification (
VerficiationDate Date not null,
TellerID Char(15) not null,
MemberID Char(15) not null,
ResigerationDate Date not null,
constraint VerificationFK1 foreign key(TellerID) references Teller(TellerID), /*It is hard to explain what is foreign key, you can google "foreign key" by yourself*/
  constraint VerificationFK2 foreign key(MemberID) references Passivemember(MemberID)   
)


/* datetime replaced with date */
create table Transactiondetails(
TransactionName Char(50) not null,
TransactionID Char(15) not null primary key,
ddescription Char(200) not null,
WorkingHours Numeric(6,2) not null,
OffererID Char(15) not null, /*It means the activemember who provides the job*/
TransactionStatus bit not null,/*if TransactionStatus=1, then TransactionStatus="Done", else if TransactionStatus=0, then TransactionStatus="Undone"*/
Category Char(50) not null,
RecipientID Char(15) not null, /*It means the active member who accepts the job*/
TransactionTime date not null,
constraint TransactionDetailsFK1 foreign key(offererID) references Activemember(memberID), 
  constraint TransactionDetailsFK2 foreign key(recipientID) references Activemember(MemberID)
)

create table PersonalAccount (
AccountNo char(15) not null primary key,
SumHours Numeric(6,2) not null, /*the sum of all your hours in your personal account*/
TransactionID  Char(15)  not null,
MemberID Char(15) not null,
constraint personalAccountFK foreign key(MemberID) references Activemember(memberID)
)

/* datetime*/
/* postgres doesn't support keyword clustered. It is SQL Server specific. Don't use it. */
create table Timecheck(
OffererName Char(50) not null,
RecipientName Char(50) not null,
RecipientAccountNo Char(15) not null,
OffererAccountNo Char(15) not null,
TransactionID  Char(15) not null,
WorkingHours  numeric(6,2) not null,
SignDate date not null,
constraint TimecheckPK primary key (RecipientAccountNo,offererAccountNo,TransactionID),
  constraint TimecheckFK1 foreign key(RecipientAccountNo) references personalAccount(accountNo), 
  constraint TimecheckFK2 foreign key(offererAccountNo) references personalAccount(accountNo),
  constraint TimecheckFK3 foreign key(TransactionID) references TransactionDetails(TransactionID)
  
)

/* datatime and clustered */
create table TimeCheckModification(
modificationdate date not null,
TellerID Char(15) not null,
TransactionID Char(15) not null,
constraint TimecheckModificationPK primary key (TellerID,TransactionID),
constraint TimeCheckModificationFK foreign key(TellerID) references Teller(TellerID), 
  constraint  TimeCheckModificationFK1 foreign key(TransactionID) references TransactionDetails(TransactionID)
)

/* datetime and clustered */
create table Transactionrecord(
TransactionID Char(15) not null,
TransactionTime date not null,
RecipientID Char(15) not null,
OffererID Char(15) not null,
constraint TransactionrecordPK primary key (recipientID,offererID,TransactionID),
constraint TransactionrecordFK foreign key(recipientID) references Activemember(MemberID), 
 constraint TransactionrecordFK1 foreign key(offererID) references Activemember(MemberID), 
  constraint  TransactionrecordFK2 foreign key(TransactionID) references  Transactiondetails(TransactionID)

)

/* datetime and clustered */
create table Supervise(
ProfileReviewDate   date  not null,
UserID  Char(15) not null,
TellerID Char (15) not null,
constraint SupervisePK primary key (userID,TellerID),
  constraint superviseFK foreign key(userID) references passiveMember(MemberID), 
    constraint superviseFK1 foreign key(TellerID) references Teller(TellerID)
)

create table Systemadministrator (
adminID Char(15) not null primary key,
ppassword Char(15) not null,
adminname  Char(20) not null,
gender   bit  not null,
age   int not null,
email Char(30) not null,
Phonenumber Char(20) not null,
RoleID int  not null
)
