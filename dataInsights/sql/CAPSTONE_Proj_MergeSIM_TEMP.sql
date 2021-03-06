/****** Script for SelectTopNRows command from SSMS  ******/
with SIM as 
(
SELECT
      [YEAR]*10000+[MONTH]*100+DAY(creation_date_time) YYYYMMDD
      ,[WeekDay]
      ,[description_groupe]
      ,[caserne]
      ,[nom_ville]
      ,[nom_arrond]
	  ,longitude
	  ,latitude
      ,sum([nombre_unites]) nombre_unites
	  ,count([incident_nbr]) incident_nbr
  FROM [CAPSTONE].[dbo].[SIM_AllData]
group by       
		[YEAR]*10000+[MONTH]*100+DAY(creation_date_time)
      ,[WeekDay]
      ,[incident_type_desc]
      ,[description_groupe]
      ,[caserne]
      ,[nom_ville]
      ,[nom_arrond]
	  ,longitude
	  ,latitude

)
, TEMP as
(
SELECT year([Date_Time])*10000+month([Date_Time])*100+Day([Date_Time]) YYYYMMDD
       ,[Max_Temp___C_]
      ,[Min_Temp___C_]
      ,[Mean_Temp___C_]
      ,[Total_Precip__mm_]
      ,[Snow_on_Grnd__cm_]
      ,[Dir_of_Max_Gust__10s_deg_]
      ,[Spd_of_Max_Gust__km_h_]
  FROM [CAPSTONE].[dbo].[temp_montreal_station30165]
)
, FINAL as
(
select a.*
		,b.Max_Temp___C_
		,b.Min_Temp___C_
		,b.Mean_Temp___C_
		,b.Total_Precip__mm_
		,b.Snow_on_Grnd__cm_
		,b.Dir_of_Max_Gust__10s_deg_
		,b.Spd_of_Max_Gust__km_h_

from SIM a
left join TEMP b
on a.YYYYMMDD = b.YYYYMMDD

)
select a.*
		,b.Max_Temp___C_
		,b.Min_Temp___C_
		,b.Mean_Temp___C_
		,b.Total_Precip__mm_
		,b.Snow_on_Grnd__cm_
		,b.Dir_of_Max_Gust__10s_deg_
		,b.Spd_of_Max_Gust__km_h_

from SIM a
left join TEMP b
on a.YYYYMMDD = b.YYYYMMDD
where a.YYYYMMDD > 20080000
	and description_groupe  in ('Premier répondant')

