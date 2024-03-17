 SELECT 
        GETDATE() AS RunDateTime,
        Db_Name(QueryText.dbid) AS DatabaseName,
        Sum(CASE WHEN ExecPlans.usecounts = 1 THEN 1 ELSE 0 END) AS SingleUse,
        Sum(CASE WHEN ExecPlans.usecounts > 1 THEN 1 ELSE 0 END) AS Reused,
        Sum(ExecPlans.size_in_bytes) / (1024) AS TotalSizeKB,
        Convert(INT, Sum(CASE objtype WHEN 'Adhoc' THEN 1 ELSE 0 END) * 1.00 / Count(*) * 100) AS AdHocQueryPercentage
    FROM 
        sys.dm_exec_cached_plans AS ExecPlans
        CROSS APPLY sys.dm_exec_sql_text(ExecPlans.plan_handle) AS QueryText
    WHERE 
        ExecPlans.cacheobjtype = 'Compiled Plan' AND QueryText.dbid IS NOT NULL
    GROUP BY 
        QueryText.dbid;


SELECT 
        GETDATE() AS RunDateTime,
        Db_Name(QueryText.dbid) AS DatabaseName,
        Sum(CASE WHEN ExecPlans.usecounts = 1 THEN 1 ELSE 0 END) AS SingleUse,
        Sum(CASE WHEN ExecPlans.usecounts > 1 THEN 1 ELSE 0 END) AS Reused,
        Sum(ExecPlans.size_in_bytes) / 1024 AS KB
    FROM 
        sys.dm_exec_cached_plans AS ExecPlans
    CROSS APPLY 
        sys.dm_exec_sql_text(ExecPlans.plan_handle) AS QueryText
    WHERE 
        ExecPlans.cacheobjtype = 'Compiled Plan' AND QueryText.dbid IS NOT NULL
    GROUP BY 
        QueryText.dbid;

 
SELECT 
         GETDATE() AS RunDateTime,
        Convert(INT, SUM(CASE a.objtype WHEN 'Adhoc' THEN 1 ELSE 0 END) * 1.00 / COUNT(*) * 100) AS AdHocQueryPercentage
    FROM 
        sys.dm_exec_cached_plans AS a;

SELECT Convert(INT,Sum
        (
        CASE a.objtype 
        WHEN 'Adhoc' 
        THEN 1 ELSE 0 END)
        * 1.00/ Count(*) * 100
              ) as 'Ad-hoc query %'
  FROM sys.dm_exec_cached_plans AS a


SELECT AdHoc_Plan_MB, Total_Cache_MB,
		AdHoc_Plan_MB*100.0 / Total_Cache_MB AS 'AdHoc %'
FROM (
SELECT SUM(CASE 
			WHEN objtype = 'adhoc'
			THEN size_in_bytes
			ELSE 0 END) / 1048576.0 AdHoc_Plan_MB,
        SUM(size_in_bytes) / 1048576.0 Total_Cache_MB
FROM sys.dm_exec_cached_plans) T