-- Client Fix V2: Invoice No, LR No, Company Name, and data cleanup
-- Run this on client SQL Server (SQLEXPRESS01) database: weighbridge
-- Date: 2026-03-28

USE weighbridge;
GO

-- 1. Add Invoice No and LR No to ticket template
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font)
VALUES (40, 1, 'invoiceNo', 'ticket-field', 'Invoice No', 4, 40, 1, 'R');
GO

INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font)
VALUES (41, 1, 'lrNo', 'ticket-field', 'LR No', 7, 40, 1, 'R');
GO

-- 2. Update company name in ticket header
UPDATE template_detail SET displayName = 'CG POWER & INDUSTRIAL SOLUTION LTD,M6,STAMPING DIVISION,', col = 15 WHERE id = 22;
GO

UPDATE template_detail SET displayName = 'B-110,B-111/B,B112/2,NAGAPUR MIDC,AHILYANAGAR-414111', col = 15 WHERE id = 23;
GO

-- 3. Strip "000-" prefix from existing supplier/material/customer data in weighment_detail
UPDATE weighment_detail 
SET supplier = SUBSTRING(supplier, CHARINDEX('-', supplier) + 1, LEN(supplier)) 
WHERE supplier IS NOT NULL AND CHARINDEX('-', supplier) > 0;
GO

UPDATE weighment_detail 
SET material = SUBSTRING(material, CHARINDEX('-', material) + 1, LEN(material)) 
WHERE material IS NOT NULL AND CHARINDEX('-', material) > 0;
GO

UPDATE weighment_detail 
SET customer = SUBSTRING(customer, CHARINDEX('-', customer) + 1, LEN(customer)) 
WHERE customer IS NOT NULL AND CHARINDEX('-', customer) > 0;
GO

-- Note: invoiceNo and lrNo columns on the weighment table will be auto-added 
-- by the new asar on app startup (db-service.js migration).

PRINT 'Client Fix V2 completed successfully.';
GO
