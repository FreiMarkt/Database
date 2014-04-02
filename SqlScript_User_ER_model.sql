/*I tested those scripts on Sql Server 2000, it can also work on the PostgreSql, the only thing you should do is copying these
codes and pasting them on your database develop platform, then deploy them, if you still have questions, please
contact us. I have made some description of the scripts, you can check it*/
set nocount on 
set dateformat ymd
use master
go 
  if not exists(select * from syslogins where name='user01')
  exec sp_addlogin user01,user01
go
/*create database*/
if exists(select *from sysdatabases where name='TimeBankDB')/*the name of our database is TimeBankDB*/
     drop database TimeBankDB
go 
create database TimeBankDB
on primary
 ( name='TimeBankDB',
   filename='f:\myWork\TimeBankDB.mdf',/*.mdf is master database file, it means this file will be put in the myWork folder of your F: disk, you can change it by yourself*/
   size=1,
   maxsize=5,
   filegrowth=1)
log on 
 ( name='TimeBankLog',
   filename='f:\myWork\TimeBankLog.ldf',/*.ldf is Log databse file, it means the same as .mdf, you can change according to your needs*/
   size=1,
   maxsize=5,
   filegrowth=1)
go

/*data mydatabase*/
use TimeBankDB
go

/* add my user*/
exec sp_adduser user01,user01
go
/*create tables of different roles*/
drop table passivemember /*in case there are existed tables with the same name*/
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
Birthday  Datetime  not null, /*the format of Birthday should be like that "yyyymmdd"*/
RoleID    Int       not null /*1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 5=Other time banks, 6=Organizations*/
)
insert Passivemember values ('001', 'Derick Chow','070667',23,1, 'Yliopistokatu 16 503,Oulu,Finland','yongzhou1314@gmail.com','0414938862',1,0,'90570','19911028',1)
/*this is the insert sentence, you can use it to insert data to database frequently, but pay attentions to the format of data*/
drop table activemember
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
Birthday datetime    not null,
RoleID   int         not null,/*1=Active user (non-55+account), 2=Active user (55+account), 3=Passive user (non-55+account), 4=Passive user (55+account), 5=Other time banks, 6=Organizations*/
constraint ActivememberFK foreign key(accountNo) references personalAccount(accountNo)
)

insert activemember values ('002', 'Fang Xin','fangxin1104',21,0, 'Yliopistokatu 16 303,Oulu,Finland','fangxin1104@gmail.com','0414938867','78768237',1,'90570','19911028',1)

drop table teller
create table Teller(
RoleID  Int not null,
TellerName Char(50) not null,
ppassword   Char(15) not null,
TellerID   Char(15) not null primary key,
email      Char(30) not null,
Phonenumber Char(12) not null
)

drop table verification
create table Verification (
VerficiationDate Datetime not null,
TellerID Char(15) not null,
MemberID Char(15) not null,
ResigerationDate Datetime not null,
constraint VerificationFK1 foreign key(TellerID) references Teller(TellerID), /*It is hard to explain what is foreign key, you can google "foreign key" by yourself*/
  constraint VerificationFK2 foreign key(MemberID) references Passivemember(MemberID)   
)
drop table Transactiondetails
create table Transactiondetails(
TransactionName Char(50) not null,
TransactionID Char(15) not null primary key,
ddescription Char(200) not null,
WorkingHours Numeric(6,2) not null,
OffererID Char(15) not null, /*It means the activemember who provides the job*/
TransactionStatus bit not null,/*if TransactionStatus=1, then TransactionStatus="Done", else if TransactionStatus=0, then TransactionStatus="Undone"*/
Category Char(50) not null,
RecipientID Char(15) not null, /*It means the active member who accepts the job*/
TransactionTime datetime not null,
constraint TransactionDetailsFK1 foreign key(offererID) references Activemember(memberID), 
  constraint TransactionDetailsFK2 foreign key(recipientID) references Activemember(MemberID)
)
drop table personalAccount
create table PersonalAccount (
AccountNo char(15) not null primary key,
SumHours Numeric(6,2) not null, /*the sum of all your hours in your personal account*/
TransactionID  Char(15)  not null,
MemberID Char(15) not null,
constraint personalAccountFK foreign key(MemberID) references Activemember(memberID)
)

drop table Timecheck
create table Timecheck(
OffererName Char(50) not null,
RecipientName Char(50) not null,
RecipientAccountNo Char(15) not null,
OffererAccountNo Char(15) not null,
TransactionID  Char(15) not null,
WorkingHours  numeric(6,2) not null,
SignDate datetime not null,
constraint TimecheckPK primary key clustered(RecipientAccountNo,offererAccountNo,TransactionID),
  constraint TimecheckFK1 foreign key(RecipientAccountNo) references personalAccount(accountNo), 
  constraint TimecheckFK2 foreign key(offererAccountNo) references personalAccount(accountNo),
  constraint TimecheckFK3 foreign key(TransactionID) references TransactionDetails(TransactionID)
  
)
 drop table TimeCheckModification
create table TimeCheckModification(
modificationdate datetime not null,
TellerID Char(15) not null,
TransactionID Char(15) not null,
constraint TimecheckModificationPK primary key clustered(TellerID,TransactionID),
constraint TimeCheckModificationFK foreign key(TellerID) references Teller(TellerID), 
  constraint  TimeCheckModificationFK1 foreign key(TransactionID) references TransactionDetails(TransactionID)
)

drop table Transactionrecord
create table Transactionrecord(
TransactionID Char(15) not null,
TransactionTime datetime not null,
RecipientID Char(15) not null,
OffererID Char(15) not null,
constraint TransactionrecordPK primary key clustered(recipientID,offererID,TransactionID),
constraint TransactionrecordFK foreign key(recipientID) references Activemember(MemberID), 
 constraint TransactionrecordFK1 foreign key(offererID) references Activemember(MemberID), 
  constraint  TransactionrecordFK2 foreign key(TransactionID) references  Transactiondetails(TransactionID)

)

drop table Supervise
create table Supervise(
ProfileReviewDate   datetime  not null,
UserID  Char(15) not null,
TellerID Char (15) not null,
constraint SupervisePK primary key clustered(userID,TellerID),
  constraint superviseFK foreign key(userID) references passiveMember(MemberID), 
    constraint superviseFK1 foreign key(TellerID) references Teller(TellerID)
)
 drop table Systemadministrator
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

 
