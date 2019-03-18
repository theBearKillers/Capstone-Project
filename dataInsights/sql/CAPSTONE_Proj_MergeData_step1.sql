With SIM as
(
select *
from [CAPSTONE].[dbo].[donneesouvertes-interventions-sim_2015_CUR]
UNION ALL
select *
from [CAPSTONE].[dbo].[donneesouvertes-interventions-sim-2005-2014]
)
--select max(creation_date_time) from SIM
select 
		cast(a.[incident_nbr] as bigint) incident_nbr
	  ,a.[creation_date_time]
      ,year(a.[creation_date_time]) [YEAR]
	  ,month(a.[creation_date_time]) [MONTH]
	  ,datepart(dw, a.[creation_date_time]) [WeekDay]
	  ,datepart(hh, a.[creation_date_time]) [Hour]
      ,a.[incident_type_desc]
	  ,b.Grouping_L1
	  ,b.Grouping_L2
	  ,b.[Description]
      ,a.[description_groupe]
      ,cast(a.[caserne] as bigint) caserne 
      ,a.[nom_ville]
      ,a.[nom_arrond] 
      ,cast(a.[division] as int) division
      ,a.[latitude]
      ,a.[longitude]
      ,cast(a.[nombre_unites] as int) nombre_unites

	  ,c.[NO_CIVIQUE] CS_NO_CIVIQUE
      ,c.[RUE] CS_RUE
      ,c.[LATITUDE] CS_LATITUDE
      ,c.[LONGITUDE] CS_LONGITUDE
      ,c.[ARRONDISSEMENT] CS_ARRONDISSEMENT
      ,c.[VILLE] CS_VILLE
      ,c.[DATE_DEBUT] CS_DATE_DEBUT
      ,c.[DATE_FIN] CS_DATE_FIN
      ,c.[MTM8_X] CS_MTM8_X
      ,c.[MTM8_Y] CS_MTM8_Y
	  ,case when b.[Description] in ('Premier répondant'
									,'Appel de Cie de détection'
									,'Alarme privé ou locale'
									,'Intervention combinée premier répondant et accident de voiture sans victime captive sur la rue'
									,'Service non requis pour une intervention bâtiment'
									,'Inondation'
									,'Aliments surchauffés'
									,'Accident de véhicule sans victime coincée sur la rue'
									,'Problèmes électriques'
									,'Odeur suspecte - gaz'
									) then 1 else 0 end  top_10_Inc_Descr 

INTO [CAPSTONE].[dbo].[SIM_AllData]
--drop table [CAPSTONE].[dbo].[SIM_AllData]
from SIM a
inner join (SELECT b.Grouping_L1
			  ,b.Grouping_L2
			  ,a.[INCIDENT_TYPE_DESCRIPTION]
			  ,a.[Description]
			  ,a.[ID]
			FROM [CAPSTONE].[dbo].[type-interventions-descriptions_ID] a
			inner join [CAPSTONE].[dbo].[DESCRIPTION_Grouping_ID] b
			on a.id = b.id) b
on a.incident_type_desc = b.INCIDENT_TYPE_DESCRIPTION
left join [CAPSTONE].[dbo].[casernes] c
on a.caserne = c.CASERNE
order by 2


