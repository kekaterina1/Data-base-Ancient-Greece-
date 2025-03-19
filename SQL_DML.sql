1. Запрос, выводящий количество жертв в каждой войне в порядке убывания
select C.CampaignName, count(*) as DeathCount from Fight F
join Campaign C
on F.CampaignName = C.CampaignName
join Citizen Cz
on Cz.CitizenID = F.WarriorID
where Cz.DeathDate >= C.StartDate and Cz.DeathDate <= C.EndDate
group by C.CampaignName
order by DeathCount desc;

2. Запрос, выводящий топ-3 стратега по количеству побед
select S.StrategistID, Cz.CitizenName as StrategistName, count(*) as VictoryCount from Strategist S
join Campaign C
on S.AppointmentDate = C.AppointmentDate
join Citizen Cz
on Cz.CitizenID = S.StrategistID
where C.CampaignResult = 'victory'
group by S.StrategistID, StrategistName
order by VictoryCount desc
limit 3;

3. Запрос, выводящий количество участий в экклексиях для людей, которым на данный момент не более 30 лет
select distinct C.CitizenID, C.CitizenName, now()::date - C.BirthDate as CitizenAge, count(*) over (partition by C.CitizenID) as ParticipationCount from Citizen C
join Participation P
on C.CitizenID = P.CitizenID
where C.DeathDate is NULL
and now()::date - C.BirthDate <= 30;

4. Запрос, выводящий процент молитв Зевсу в победных кампаниях (процент жрецов, которые молились Зевсу от общего количества молившихся жрецов)
with VictoryZeusPraying as
(select distinct C.CampaignName, count(*) over (partition by C.CampaignName) as PrayingToZeusCount from Praying P
join Campaign C
on P.CampaignName = C.CampaignName
where C.CampaignResult = 'victory'
and P.God = 'Zeus'),
VictoryPraying as
(select distinct C.CampaignName, count(*) over (partition by C.CampaignName) as PrayingCount from Praying P
join Campaign C
on P.CampaignName = C.CampaignName
where C.CampaignResult = 'victory')
select VZP.CampaignName, round(VZP.PrayingToZeusCount * 100 / nullif(VP.PrayingCount, 0), 1) as ZeusPrayingPercentage from VictoryZeusPraying VZP
join VictoryPraying VP
on VZP.CampaignName = VP.CampaignName;

Транзакции
1. Объединение в одну транзакцию обновления даты смерти для жителя и фактической даты окончания службы для воина
begin transaction;
update Warrior set FactRetirementDate = '01-08-2022'
where WarriorID = 123456;
update Citizen set DeathDate = '01-08-2022'
where CitizenID = 123456;
commit transaction;

2. Транзакция для обновления даты окончания службы, даты смерти и статуса войны в случае смерти стратега
begin transaction;
update Citizen set DeathDate = '01-08-2022'
where CitizenID = 123458;
update Official set FactDismissalDate = '01-08-2022'
where OfficialID = 123458;
update Campaign set CampaignResult = 'defeat'
where EndDate is null;
commit transaction;

