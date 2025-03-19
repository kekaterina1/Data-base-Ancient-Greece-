create table Citizen (
CitizenID bigint primary key,
CitizenName varchar(50),
Sex varchar(50) check (Sex = 'male' or Sex = 'female'),
BirthDate date,
DeathDate date
);
create table Warrior (
WarriorID bigint primary key references Citizen(CitizenID),
RecruitmentDate date,
PlannedRetirementDate date,
FactRetirementDate date,
check ((RecruitmentDate <= FactRetirementDate) and (FactRetirementDate <= PlannedRetirementDate))
);
create table Campaign (
CampaignName varchar(255) primary key,
StartDate date,
EndDate date,
CampaignResult varchar(50) check (CampaignResult = 'victory' or CampaignResult = 'defeat'),
AppointmentDate date references Strategist(AppointmentDate),
check (StartDate <= EndDate)
);
create table Fight (
WarriorID bigint references Warrior(WarriorID),
CampaignName varchar(50) references Campaign(CampaignName),
primary key (WarriorID, CampaignName)
);
create table Meeting (
HoldingDate date primary key,                                                
Agenda varchar(500),
Category varchar(50) check (Category in ('Economy', 'Domestic Policy', 'Foreign Policy', 'Election', 'Overthrow', 'Culture', 'Social Sphere', 'Science', 'Climate'))
);
create table Post (
PostName varchar(50) primary key,
Duration int -- Срок пребывания на посту в годах
);
create table Official (
OfficialID bigint references Citizen(CitizenID),
AppointmentDate date references Meeting(HoldingDate),
FactDismissalDate date,
PostName varchar(50) references Post(PostName),
primary key (OfficialID, AppointmentDate)
);
create table Priest (
PriestID bigint primary key,
AppointmentDate date,
Temple varchar(50),
foreign key (PriestID, AppointmentDate) references Official(OfficialID, AppointmentDate)
);
create table Praying (
PriestID bigint references Priest(PriestID),
CampaignName varchar(50) references Campaign(CampaignName),
God varchar(50),
primary key (PriestID, CampaignName)
);
create table Strategist (
AppointmentDate date primary key,
StrategistID bigint,
Skill varchar(50) NOT NULL check (Skill in ('Bravery', 'Strength', 'Stamina', 'Diplomacy', 'Foresight', 'Tactical skills', 'Charisma')),
foreign key (StrategistID, AppointmentDate) references Official(OfficialID, AppointmentDate),
unique (AppointmentDate, StrategistID)
);
create table UnplannedMeeting (
HoldingDate date primary key references Meeting(HoldingDate),
AppointmentDate date references Strategist(AppointmentDate),
check (AppointmentDate < HoldingDate)
);
create table Participation (
HoldingDate date references Meeting(HoldingDate),
CitizenID bigint references Citizen(CitizenID),
primary key (HoldingDate, CitizenID)
);
create table Overthrow (
HoldingDate date primary key references Meeting(HoldingDate),
AppointmentDate date references Strategist(AppointmentDate),
check (AppointmentDate < HoldingDate)
);
