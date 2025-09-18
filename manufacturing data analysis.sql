create database Manufacturingdb;
use Manufacturingdb;
select * from Manufacturingdb;

#----KPIS-----#

-- Total Orders

SELECT COUNT(DISTINCT `Doc Num`) AS TotalOrders
FROM Manufacturingdb;


-- Total Manufactured Qty

SELECT SUM(COALESCE(`today Manufactured qty`, 0)) AS TotalManufacturedQty
FROM Manufacturingdb;


-- Total Rejected Qty 

SELECT SUM(COALESCE(`Rejected Qty`, 0)) AS TotalRejectedQty
FROM Manufacturingdb;


-- Processed Qty

SELECT SUM(COALESCE(`Processed Qty`, 0)) AS TotalProcessedQty
FROM Manufacturingdb;

-- Wastage Qty (WOQty - ManufacturedQty)

SELECT 
  SUM(COALESCE(`WO Qty`, 0)) - SUM(COALESCE(`today Manufactured qty`, 0)) AS WastageQty
FROM Manufacturingdb;

-- Total Value

SELECT SUM(COALESCE(`TotalValue`, 0)) AS TotalOrderValue
FROM Manufacturingdb;


-- Report

-- Department-wise MFG & Rejection

SELECT `Department Name`,
       SUM(`today Manufactured qty`) AS ManufacturedQty,
       SUM(`Rejected Qty`) AS RejectedQty
FROM Manufacturingdb
GROUP BY `Department Name`;

-- Employee-wise Rejected Qty

SELECT `Emp Name`, 
       SUM(`Rejected Qty`) AS TotalRejected
FROM Manufacturingdb
GROUP BY `Emp Name`
ORDER BY TotalRejected DESC;

-- Machine-wise Rejected Qty

SELECT `Machine Code`,
       SUM(`Rejected Qty`) AS TotalRejected
FROM Manufacturingdb
GROUP BY `Machine Code`
ORDER BY TotalRejected DESC;

-- Monthly Trends

SELECT DATE_FORMAT(`Doc Date`, '%Y-%m') AS Month,
       SUM(`WO Qty`) AS PlannedQty,
       SUM(`today Manufactured qty`) AS ManufacturedQty
FROM Manufacturingdb
GROUP BY Month
ORDER BY Month;

-- Buyer-Wise Performance Report

SELECT Buyer,
       COUNT(DISTINCT `Doc Num`) AS Orders,
       SUM(`today Manufactured qty`) AS ManufacturedQty,
       SUM(`Rejected Qty`) AS RejectedQty,
       SUM(TotalValue) AS TotalOrderValue
FROM Manufacturingdb
GROUP BY Buyer
ORDER BY TotalOrderValue DESC;

-- Operation-Wise Summary

SELECT `Operation Name`,
       COUNT(*) AS JobCount,
       SUM(`today Manufactured qty`) AS TotalMFG,
       SUM(`Rejected Qty`) AS TotalRejected
FROM Manufacturingdb
GROUP BY `Operation Name`
ORDER BY TotalMFG DESC;

-- Item-Wise Output

SELECT `Item Name`,
       COUNT(DISTINCT `Doc Num`) AS OrderCount,
       SUM(`today Manufactured qty`) AS TotalMFG,
       SUM(`Rejected Qty`) AS TotalRejected,
       SUM(TotalValue) AS TotalValue
FROM Manufacturingdb
GROUP BY `Item Name`
ORDER BY TotalMFG DESC
LIMIT 10;

-- High Wastage Orders

SELECT `Doc Num`, `WO Qty`, `today Manufactured qty`,
       (`WO Qty` - `today Manufactured qty`) AS WastageQty
FROM Manufacturingdb
WHERE (`WO Qty` - `today Manufactured qty`) > 0
ORDER BY WastageQty DESC
LIMIT 10;

