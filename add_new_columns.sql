-- Script to add missing columns to weighment table
-- Execute this SQL script in your SQL Server Management Studio

USE [weighbridge]
GO

-- Add containerNo column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'containerNo')
BEGIN
    ALTER TABLE [dbo].[weighment]
    ADD [containerNo] [varchar](100) NULL
END
GO

-- Add licenseNo column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'licenseNo')
BEGIN
    ALTER TABLE [dbo].[weighment]
    ADD [licenseNo] [varchar](100) NULL
END
GO

-- Add driverName column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'driverName')
BEGIN
    ALTER TABLE [dbo].[weighment]
    ADD [driverName] [varchar](150) NULL
END
GO

-- Add pucNo column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'pucNo')
BEGIN
    ALTER TABLE [dbo].[weighment]
    ADD [pucNo] [varchar](100) NULL
END
GO

-- Verify the columns were added
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'weighment'
AND COLUMN_NAME IN ('containerNo', 'licenseNo', 'driverName', 'pucNo')
GO

-- Fix material field position in ticket template
-- The weighDetails_material field had row=NULL, col=NULL which caused it to be
-- filtered out of the ticket preview and print. This sets it to row=6, col=40.
IF EXISTS (SELECT 1 FROM template_detail WHERE field = 'weighDetails_material' AND row IS NULL AND col IS NULL)
BEGIN
    UPDATE template_detail
    SET row = 6, col = 40
    WHERE field = 'weighDetails_material' AND row IS NULL AND col IS NULL
END
GO

-- Verify fix
SELECT id, templateId, field, displayName, row, col, isIncluded
FROM template_detail
WHERE field = 'weighDetails_material'
GO
