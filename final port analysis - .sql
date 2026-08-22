use [Final Port Analysis ]


select * from DimCargo
select * from DimContainerSpecification
select * from DimDamageCondition
select * from DimEquipment
select * from DimOperator
select * from DimPortPOD
select * from DimPortPOL
select * from DimTransportProfile
select * from DimVessel
select * from DimVesselCall
select * from FactContainerOperations
select * from FactQCPerformance
select * from FactVesselPortCalls
select * from POD_Master
select * from PortMaster


----Data modeling---
---Finding the primary key for ERD--- 
---Checking the primary key of the columns---
SELECT 
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME AS Primary_Key_Name,
    kcu.COLUMN_NAME,
    kcu.ORDINAL_POSITION
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_NAME = kcu.TABLE_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY tc.TABLE_NAME, kcu.ORDINAL_POSITION;

----checking if the user_voy column have null values or not---
SELECT *
FROM [FactVesselPortCalls]
WHERE User_Voy IS NULL

---checking that the user_voy column have no duplicates 
SELECT 
    user_voy, 
    COUNT(*) AS Duplicate_Count
FROM [FactVesselPortCalls]
GROUP BY User_Voy
HAVING COUNT(*) > 1


----changing the constraint of the User_Voy---
ALTER TABLE [FactVesselPortCalls]
ALTER COLUMN User_Voy nvarchar(50) NOT NULL;

----Adding the primary key of the [FactVesselPortCalls]---
ALTER TABLE [FactVesselPortCalls]
ADD CONSTRAINT PK_FactVesselPortCalls
PRIMARY KEY (User_Voy)


--checking that the type of the columns is correct
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimCargo';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimContainerSpecification'; 

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimDamageCondition';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimEquipment';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimOperator';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimPortPOD';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimPortPOL';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimTransportProfile';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimVessel';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimVesselCall';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactContainerOperations';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactQCPerformance';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactVesselPortCalls';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'POD_Master';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PortMaster';



---Uniting the data typs of the columns---
alter table [factcontaineroperations]
alter column vesselcallkey int

alter table [factcontaineroperations]
alter column operatorkey tinyint

alter table [factcontaineroperations]
alter column dimequipment_equipmentkey tinyint

alter table [factcontaineroperations]
alter column dimdamagecondition_damageconditionkey tinyint

alter table [factqcperformance]
alter column vesselcallkey int

alter table [factqcperformance]
alter column equipmentkey tinyint

alter table [dimvesselcall]
alter column callingyear int


---Setting the foreignkeys---

ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_VesselCall
FOREIGN KEY (VesselCallKey) REFERENCES DimVesselCall (VesselCallKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_Operator
FOREIGN KEY (OperatorKey) REFERENCES DimOperator (OperatorKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_ContainerSpecification
FOREIGN KEY (ContainerSpecificationKey) REFERENCES DimContainerSpecification (ContainerSpecificationKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_Cargo
FOREIGN KEY ([DimCargo_CargoKey]) REFERENCES DimCargo (CargoKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_POL
FOREIGN KEY ([DimPortPOL_POLKey]) REFERENCES DimPortPOL (POLKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_Equipment
FOREIGN KEY ([DimEquipment_EquipmentKey]) REFERENCES DimEquipment (EquipmentKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_POD
FOREIGN KEY (PODKey) REFERENCES DimPortPOD (PODKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_DamageCondition
FOREIGN KEY ([DimDamageCondition_DamageConditionKey]) REFERENCES DimDamageCondition (DamageConditionKey);
 
ALTER TABLE FactContainerOperations
ADD CONSTRAINT FK_FCO_TransportProfile
FOREIGN KEY ([DimTransportProfile_TransportProfileKey]) REFERENCES DimTransportProfile (TransportProfileKey);
 
ALTER TABLE FactQCPerformance
ADD CONSTRAINT FK_FQC_VesselCall
FOREIGN KEY (VesselCallKey) REFERENCES DimVesselCall (VesselCallKey);
 
ALTER TABLE FactQCPerformance
ADD CONSTRAINT FK_FQC_Equipment
FOREIGN KEY (EquipmentKey) REFERENCES DimEquipment (EquipmentKey);

ALTER TABLE POD_Master
ADD CONSTRAINT UQ_PODMaster_Code UNIQUE (PODCode);

ALTER TABLE DimPortPOD WITH NOCHECK
ADD CONSTRAINT FK_DimPortPOD_PODMaster
FOREIGN KEY (PODCode) REFERENCES POD_Master (PODCode);
 
ALTER TABLE PortMaster
ADD CONSTRAINT UQ_PortMaster_Code UNIQUE (PortCode);
 
ALTER TABLE DimPortPOL
ADD CONSTRAINT FK_DimPortPOL_PortMaster
FOREIGN KEY (POLCode) REFERENCES PortMaster (PortCode);

ALTER TABLE DimVessel
ADD CONSTRAINT UQ_DimVessel_BusinessKey UNIQUE (VesselBusinessKey);
 
ALTER TABLE DimVesselCall
ADD CONSTRAINT FK_DVC_Vessel
FOREIGN KEY (VesselBusinessKey) REFERENCES DimVessel (VesselBusinessKey);

ALTER TABLE FactVesselPortCalls
ADD CONSTRAINT FK_FVPC_Vessel
FOREIGN KEY (VesselBusinessKey) REFERENCES DimVessel (VesselBusinessKey);
 
ALTER TABLE DimOperator
ADD CONSTRAINT UQ_DimOperator_Code UNIQUE (OperatorCode);
 
ALTER TABLE FactVesselPortCalls WITH NOCHECK
ADD CONSTRAINT FK_FVPC_Operator
FOREIGN KEY (Operator) REFERENCES DimOperator (OperatorCode);




----Deleting two unuseful rows---

DELETE FROM [FactContainerOperations]
WHERE containeroperationkey IN (48676, 48677);

----Data exploration and data analysis---

-- General measures: "How many unique containers, vessels, and voyages were handled by the port each year?---  
SELECT
    COUNT(*) AS [No. of operations],
    COUNT(DISTINCT f.ContainerNumber) AS [No. of containers],
    COUNT(DISTINCT dvc.VesselCode) AS [No. of vessels],
    COUNT(DISTINCT dvc.UserVoyage) AS [No. of voyages]
FROM FactContainerOperations f
JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
WHERE dvc.CallingYear IN (2025, 2026);
 
---Measures per year---
SELECT
    COUNT(*) AS [No. of operations],
    COUNT(DISTINCT f.ContainerNumber) AS [No. of containers],
    COUNT(DISTINCT dvc.VesselCode) AS [No. of vessels],
    COUNT(DISTINCT dvc.UserVoyage) AS [No. of voyages],
    dvc.CallingYear
FROM FactContainerOperations f
JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
GROUP BY dvc.CallingYear;
 
--- No. of visits for each vessel
SELECT
    dvc.VesselName,
    dvc.VesselCode,
    COUNT(DISTINCT dvc.UserVoyage) AS [Number of visits]
FROM FactContainerOperations f
JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
GROUP BY dvc.VesselCode, dvc.VesselName
ORDER BY [Number of visits] DESC;

 --- No. of visits for each vessel per year
SELECT
    dvc.VesselName,
    dvc.VesselCode,
    COUNT(DISTINCT dvc.UserVoyage) AS [Number of visits],
    dvc.CallingYear
FROM FactContainerOperations f
JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
GROUP BY dvc.CallingYear, dvc.VesselCode, dvc.VesselName
ORDER BY dvc.CallingYear ASC, [Number of visits] DESC
 
-- Which operator (OPR) handles the most container operations at the port?
SELECT
    OperatorCode,
    COUNT(*) AS [No. of container operations]
FROM (
    SELECT DISTINCT
        f.ContainerNumber,
        dvc.UserVoyage,
        dop.OperatorCode
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
    JOIN DimOperator dop ON f.OperatorKey = dop.OperatorKey
) AS [Unique container operations]
GROUP BY OperatorCode
ORDER BY [No. of container operations] DESC;


-- Which operator (OPR) handles the most container operations at the port for each year?
SELECT
    OperatorCode,
    COUNT(*) AS [No. of container operations],
    CallingYear
FROM (
    SELECT DISTINCT
        f.ContainerNumber,
        dvc.UserVoyage,
        dop.OperatorCode,
        dvc.CallingYear
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
    JOIN DimOperator dop ON f.OperatorKey = dop.OperatorKey
) AS [Unique container operations]
GROUP BY OperatorCode, CallingYear
ORDER BY CallingYear, [No. of container operations] DESC;

---The no. of full/empty containers---
SELECT
    c.CallingYear AS Year,
    dtp.FullEmptyStatus,
    COUNT(*) AS [No. of containers]
FROM (
    SELECT DISTINCT
        f.ContainerNumber,
        dvc.UserVoyage,
        dvc.CallingYear,
        f.[DimTransportProfile_TransportProfileKey]
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc 
        ON f.VesselCallKey = dvc.VesselCallKey
) AS c
JOIN DimTransportProfile dtp 
    ON c.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
GROUP BY
    c.CallingYear,
    dtp.FullEmptyStatus
ORDER BY
    c.CallingYear,
    dtp.FullEmptyStatus;


---The most commodities imported and exported---
SELECT
    dc.Commodity,
    dtp.Mode,
    COUNT(*) AS [No. of operations]
FROM FactContainerOperations f
JOIN DimCargo dc ON f.[DimCargo_CargoKey] = dc.CargoKey
JOIN DimTransportProfile dtp ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
GROUP BY dc.Commodity, dtp.Mode
ORDER BY dtp.Mode, [No. of operations] DESC;

---The most commodities imported and exported for each year---
SELECT
    dvc.CallingYear AS Year,
    dc.Commodity,
    dtp.Mode,
    COUNT(*) AS [No. of operations]
FROM FactContainerOperations f
JOIN DimCargo dc 
    ON f.[DimCargo_CargoKey] = dc.CargoKey
JOIN DimTransportProfile dtp 
    ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
JOIN DimVesselCall dvc
    ON f.VesselCallKey = dvc.VesselCallKey
GROUP BY
    dvc.CallingYear,
    dc.Commodity,
    dtp.Mode
ORDER BY
    dvc.CallingYear,
    dtp.Mode,
    [No. of operations] DESC;
 
--- Which cargo types have the highest number of operations?---
SELECT
    dc.CargoType,
    COUNT(*) AS [No. of operations]
FROM FactContainerOperations f
JOIN DimCargo dc ON f.[DimCargo_CargoKey] = dc.CargoKey
GROUP BY dc.CargoType
ORDER BY [No. of operations] DESC;
 

-- What are the most frequent cargo types and commodities for each operation mode?
SELECT
    COUNT(*) AS [No. of operations],
    dc.CargoType,
    dc.Commodity,
    dcs.ContainerType,
    dtp.Mode
FROM FactContainerOperations f
JOIN DimCargo dc ON f.[DimCargo_CargoKey] = dc.CargoKey
JOIN DimContainerSpecification dcs ON f.ContainerSpecificationKey = dcs.ContainerSpecificationKey
JOIN DimTransportProfile dtp ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
WHERE dc.CargoType <> 'Empty' 
   OR dc.CargoType IS NULL
GROUP BY dc.CargoType, dc.Commodity, dcs.ContainerType, dtp.Mode
ORDER BY dtp.Mode, [No. of operations] DESC;
 
 
-- Which loading ports have the highest number of container operations?
SELECT
    dpol.POLCode,
    COUNT(*) AS [No. of container operations]
FROM (
    SELECT DISTINCT
        dvc.UserVoyage,
        f.ContainerNumber,
        f.[DimPortPOL_POLKey]
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
) AS c
JOIN DimPortPOL dpol ON c.[DimPortPOL_POLKey] = dpol.POLKey
GROUP BY dpol.POLCode
ORDER BY [No. of container operations] DESC;
 
---What are the loading ports with the highest number of unique container operations,
---And in which country and region are they located?
SELECT
    c.CallingYear AS Year,
    dpol.POLCode,
    COUNT(*) AS [No. of container operations],
    dpol.[PortMaster_PortName] AS PortName,
    dpol.[PortMaster_Country] AS Country,
    dpol.[PortMaster_Region] AS Region
FROM (
    SELECT DISTINCT
        dvc.UserVoyage,
        dvc.CallingYear,
        f.ContainerNumber,
        f.[DimPortPOL_POLKey],
        f.[DimTransportProfile_TransportProfileKey]
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc 
        ON f.VesselCallKey = dvc.VesselCallKey
) AS c
JOIN DimPortPOL dpol 
    ON c.[DimPortPOL_POLKey] = dpol.POLKey
JOIN DimTransportProfile dtp 
    ON c.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
GROUP BY
    c.CallingYear,
    dpol.POLCode,
    dpol.[PortMaster_PortName],
    dpol.[PortMaster_Country],
    dpol.[PortMaster_Region]
ORDER BY
    c.CallingYear,
    [No. of container operations] DESC;

-- Which discharging ports have the highest number of container operations?
SELECT
    dpod.PODCode,
    COUNT(*) AS [No. of container operations]
FROM (
    SELECT DISTINCT
        dvc.UserVoyage,
        f.ContainerNumber,
        f.PODKey
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
) AS c
JOIN DimPortPOD dpod ON c.PODKey = dpod.PODKey
GROUP BY dpod.PODCode
ORDER BY [No. of container operations] DESC;
 


---What are the destination/discharge ports with the highest number of unique container operations,
---And in which country and region are they located?
SELECT
    c.CallingYear AS Year,
    dpod.PODCode,
    COUNT(*) AS [No. of container operations],
    dpod.[POD_Master_PortName] AS PortName,
    dpod.[POD_Master_Country] AS Country,
    dpod.Region
FROM (
    SELECT DISTINCT
        dvc.UserVoyage,
        dvc.CallingYear,
        f.ContainerNumber,
        f.PODKey
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc 
        ON f.VesselCallKey = dvc.VesselCallKey
) AS c
JOIN DimPortPOD dpod 
    ON c.PODKey = dpod.PODKey
GROUP BY
    c.CallingYear,
    dpod.PODCode,
    dpod.[POD_Master_PortName],
    dpod.[POD_Master_Country],
    dpod.Region
ORDER BY
    c.CallingYear,
    [No. of container operations] DESC;
 
 
---How effectively is the container terminal utilizing its design capacity on a monthly basis?---
---And what impact did early 2026 geopolitical events have on throughput trends?---
---Terminal Capacity Utilization by month---

WITH teu_calc AS (
    SELECT
        FORMAT(f.InDateOnly, 'yyyy-MM') AS YearMonth,
        dcs.TEUFactor AS TEU
    FROM FactContainerOperations f
    JOIN DimContainerSpecification dcs 
        ON f.ContainerSpecificationKey = dcs.ContainerSpecificationKey
    WHERE f.InDateOnly IS NOT NULL
      AND MONTH(f.InDateOnly) <= 3)
SELECT
    YearMonth,
    SUM(TEU) AS Actual_TEU,
    500000 / 12.0 AS Design_Capacity_TEU_Monthly,
    ROUND(
        SUM(TEU) / (500000.0 / 12) * 100, 1) AS Utilization_Percentage
FROM teu_calc
GROUP BY YearMonth
ORDER BY YearMonth;

---Quay Crane Productivity (Monthly)---
---What is the monthly productivity of the cranes?---
SELECT
    FORMAT(f.InDateOnly, 'yyyy-MM') AS YearMonth,
    de.EquipmentNumber AS Crane,
    dvc.VesselCode,
    dvc.CallingSequence AS Vessel_Call,
    COUNT(f.ContainerNumber) AS Total_Moves,
    SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), f.QCWorkingHoursSource)) / 3600.0 AS Total_Crane_Hours,
    ROUND(COUNT(f.ContainerNumber) * 1.0 / NULLIF(SUM(DATEDIFF(SECOND,CAST('00:00:00' AS TIME), f.QCWorkingHoursSource)) / 3600.0,0),1) AS Avg_Moves_Per_Hour
FROM FactContainerOperations f
JOIN DimEquipment de
    ON f.DimEquipment_EquipmentKey = de.EquipmentKey
JOIN DimVesselCall dvc
    ON f.VesselCallKey = dvc.VesselCallKey
WHERE de.EquipmentNumber IS NOT NULL
  AND de.EquipmentNumber <> ''
  AND MONTH(f.InDateOnly) BETWEEN 1 AND 3
GROUP BY
    FORMAT(f.InDateOnly, 'yyyy-MM'),
    de.EquipmentNumber,
    dvc.VesselCode,
    dvc.CallingSequence
ORDER BY
    YearMonth,
    Crane;

--- Monthly Quay Crane Productivity (Moves per Hour)---
SELECT
    FORMAT(f.InDateOnly, 'yyyy-MM') AS YearMonth,
    COUNT(f.ContainerNumber) AS Total_Moves,
    SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), f.QCWorkingHoursSource)) / 3600.0 AS Total_Crane_Hours,
    ROUND(COUNT(f.ContainerNumber) * 1.0 / NULLIF(SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), f.QCWorkingHoursSource)) / 3600.0,0),1) AS Moves_Per_Hour
FROM FactContainerOperations f
JOIN DimEquipment de
    ON f.[DimEquipment_EquipmentKey] = de.EquipmentKey
WHERE de.EquipmentNumber IS NOT NULL
  AND de.EquipmentNumber <> ''
  AND MONTH(f.InDateOnly) IN (1, 2, 3)
GROUP BY FORMAT(f.InDateOnly, 'yyyy-MM')
ORDER BY YearMonth;

---Dwell Time---
---What is the average number of days a container stays at the port?---
SELECT
    DATEPART(YEAR, f.InDateOnly) AS Year,
    DATEPART(MONTH, f.InDateOnly) AS Month,
    dtp.Mode,
    AVG(f.StackDays) AS Avg_Stack_Days
FROM FactContainerOperations f
JOIN DimTransportProfile dtp ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
WHERE f.OutDateOnly IS NOT NULL
AND MONTH(f.InDateOnly) IN (1, 2, 3)
GROUP BY dtp.Mode, DATEPART(YEAR, f.InDateOnly), DATEPART(MONTH, f.InDateOnly)
ORDER BY Year, Month;

---Dwell Time Year-over-Year Analysis---
WITH Monthly_Dwell AS (
    SELECT
        YEAR(f.InDateOnly) AS Year,
        MONTH(f.InDateOnly) AS Month,
        dtp.Mode,
        AVG(f.StackDays) AS Avg_Dwell
    FROM FactContainerOperations f
    JOIN DimTransportProfile dtp ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
    WHERE f.OutDateOnly IS NOT NULL
      AND YEAR(f.InDateOnly) IN (2025, 2026)
      AND MONTH(f.InDateOnly) IN (1, 2, 3)
    GROUP BY
        YEAR(f.InDateOnly),
        MONTH(f.InDateOnly),
        dtp.Mode)
SELECT
    Month,
    Mode,
    ROUND(MAX(CASE WHEN Year = 2025 THEN Avg_Dwell END), 2) AS Dwell_2025,
    ROUND(MAX(CASE WHEN Year = 2026 THEN Avg_Dwell END), 2) AS Dwell_2026,
    ROUND((MAX(CASE WHEN Year = 2026 THEN Avg_Dwell END)
            -
            MAX(CASE WHEN Year = 2025 THEN Avg_Dwell END))
            /NULLIF(MAX(CASE WHEN Year = 2025 THEN Avg_Dwell END), 0)* 100, 2) AS Change_Percentage
FROM Monthly_Dwell
GROUP BY Month, Mode
ORDER BY Month, Mode;

---How many containers/voyages/ships were exported and imported monthly, and what was the average Dwell Time per month?---
SELECT
    YEAR(f.InDateOnly) AS Year,
    MONTH(f.InDateOnly) AS Month,
    dtp.Mode,
    COUNT(DISTINCT CONCAT(f.ContainerNumber, '-', dvc.UserVoyage)) AS Containers,
    COUNT(DISTINCT dvc.UserVoyage) AS Voyages,
    COUNT(DISTINCT CONCAT(dvc.VesselCode, '-', dvc.CallingSequence)) AS Vessel_Calls,
    ROUND(AVG(f.StackDays), 2) AS Avg_Dwell_Time
FROM FactContainerOperations f
JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
JOIN DimTransportProfile dtp ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
WHERE YEAR(f.InDateOnly) IN (2025, 2026)
AND MONTH(f.InDateOnly) IN (1, 2, 3)
GROUP BY
    YEAR(f.InDateOnly),
    MONTH(f.InDateOnly),
    dtp.Mode
ORDER BY Year, Month, dtp.Mode;

---Vessel Turnaround Time---
---What is the average time for ship maneuvering?---
SELECT
    DATEPART(YEAR, ATB) AS Year,
    DATEPART(MONTH, ATB) AS Month,
    AVG(VesselTurnaroundHours) AS Avg_Turnaround_Hours,
    COUNT(*) AS Vessel_Calls
FROM FactVesselPortCalls
GROUP BY DATEPART(YEAR, ATB), DATEPART(MONTH, ATB)
ORDER BY Year, Month;

---Vessel Turnaround Time Breakdown by Operational Mode (Import vs. Export)---
---Does the time required for ship maneuvering vary depending on the loading method?---
SELECT
    DATEPART(YEAR, fvpc.ATB) AS Year,
    DATEPART(MONTH, fvpc.ATB) AS Month,
    dtp.Mode,
    COUNT(DISTINCT fvpc.[Vessel_Code]) AS Vessels_Count,
    ROUND(AVG(fvpc.VesselTurnaroundHours), 2) AS Avg_Turnaround_Hours
FROM FactVesselPortCalls fvpc
JOIN DimVesselCall dvc
    ON  CAST(fvpc.[Vessel_Code] AS NVARCHAR(50)) = CAST(dvc.VesselCode AS NVARCHAR(50))
    AND CAST(fvpc.[User_Voy] AS NVARCHAR(50))    = CAST(dvc.UserVoyage AS NVARCHAR(50))
JOIN FactContainerOperations f 
    ON f.VesselCallKey = dvc.VesselCallKey
JOIN DimTransportProfile dtp 
    ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
WHERE DATEPART(MONTH, fvpc.ATB) IN (1, 2, 3)
  AND DATEPART(YEAR, fvpc.ATB) IN (2025, 2026)
GROUP BY
    DATEPART(YEAR, fvpc.ATB),
    DATEPART(MONTH, fvpc.ATB),
    dtp.Mode
ORDER BY Year, Month, dtp.Mode;

---Import & Export---
---What is the import-to-export ratio for each year?---
SELECT
    dvc.CallingYear AS Year,
    dtp.Mode,
    COUNT(*) AS Total_Containers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY dvc.CallingYear), 1) AS Pct_Of_Year
FROM FactContainerOperations f
JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
JOIN DimTransportProfile dtp ON f.[DimTransportProfile_TransportProfileKey] = dtp.TransportProfileKey
WHERE MONTH(f.InDateOnly) IN (1, 2, 3)
GROUP BY dvc.CallingYear, dtp.Mode
ORDER BY Year, dtp.Mode;

---What is the percentage of containers per country (by port of discharge) out of the total for each year?---
WITH country_totals AS (
    SELECT
        dvc.CallingYear AS Year,
        dpod.[POD_Master_Country] AS Country,
        COUNT(*) AS Total_Containers
    FROM FactContainerOperations f
    JOIN DimVesselCall dvc ON f.VesselCallKey = dvc.VesselCallKey
    JOIN DimPortPOD dpod ON f.PODKey = dpod.PODKey
    GROUP BY dvc.CallingYear, dpod.[POD_Master_Country])
SELECT
    Year,
    Country,
    Total_Containers,
    ROUND(Total_Containers * 100.0 / SUM(Total_Containers) OVER (PARTITION BY Year), 1) AS Pct_Of_Year
FROM country_totals
ORDER BY Year, Total_Containers DESC;









































































 
 
