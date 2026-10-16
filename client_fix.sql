-- STEP 1: Run this first (select these 4 lines and press F5)
UPDATE search_field SET fieldName='supplier' WHERE id=1;
UPDATE search_field SET fieldName='material' WHERE id=2;
UPDATE search_field SET fieldName='transporter' WHERE id=3;
UPDATE search_field SET fieldName='customer' WHERE id=4;

-- STEP 2: Run this to verify (select and press F5)
SELECT id, displayName, fieldName, enable, entryMode, inOutMode FROM search_field;

-- STEP 3: Run this line alone (select and press F5)
DELETE FROM template_detail WHERE templateId = 1;

-- STEP 4: Run this line alone (select and press F5)
DELETE FROM ticket_template WHERE id = 1;

-- STEP 5: Run this line alone (select and press F5)
INSERT INTO ticket_template (id, [name], applicableTo, printerType, defaultPrinter, labelLength, copiesPerPrint, alignment, width, font, fontSize, operatingType) VALUES (1, 'GENERIC', 'GENERIC', 'DOT-MATRIX', NULL, 200, 1, 'Horizontal', 200, 'Arial', 10, NULL);

-- STEP 6: Select ALL lines below and press F5
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (1, 1, 'transporterCode', 'ticket-field', 'Tranporter Code', 7, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (2, 1, 'transporterName', 'ticket-field', 'Transporter Name', 6, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (3, 1, 'scrollNo', 'ticket-field', 'Scroll No', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (4, 1, 'rstNo', 'ticket-field', 'Rst No', 4, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (5, 1, 'vehicleNo', 'ticket-field', 'Vehicle No', 5, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (6, 1, 'reqId', 'ticket-field', 'Request Id', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (7, 1, 'status', 'ticket-field', 'status', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (8, 1, 'gatePassNo', 'ticket-field', 'Gate Pass No.', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (9, 1, 'poDetails', 'ticket-field', 'PO Details', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (10, 1, 'createdAt', 'ticket-field', 'Created At', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (11, 1, 'duration', 'ticket-field', 'Duration', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (12, 1, 'weighmentType', 'ticket-field', 'Inbound / Outbound', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (13, 1, 'weighmentDetails', 'ticket-field', 'Weighment Details', 12, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (14, 1, 'weighDetails_id', 'ticket-field', 'Weighslip No', NULL, NULL, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (15, 1, 'weighDetails_material', 'ticket-field', 'Material', 6, 40, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (16, 1, 'weighDetails_supplier', 'ticket-field', 'Supplier', 5, 40, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (17, 1, 'weighDetails_firstWeight', 'ticket-field', 'Wt1(KG)', 8, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (18, 1, 'weighDetails_firstWeightDatetime', 'ticket-field', 'In Date / Time', 8, 40, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (19, 1, 'weighDetails_secondWeight', 'ticket-field', 'Wt2(KG)', 9, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (20, 1, 'weighDetails_secondWeightDatetime', 'ticket-field', 'Out Date / Time', 9, 40, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (21, 1, 'weighDetails_netWeight', 'ticket-field', 'Net Wt(KG)', 10, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (22, 1, NULL, 'freetext', 'BHARAT FORGE LIMITED', 1, 30, 1, 'DB');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (23, 1, NULL, 'freetext', 'MUNDHWA, PUNE 411036', 2, 30, 1, 'DB');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (24, 1, NULL, 'freetext', '---------------------------------------------------------------------------------', 3, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (25, 1, NULL, 'freetext', '---------------------------------------------------------------------------------', 11, 1, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (26, 1, 'material', 'weighment_detail', 'Material', NULL, 1, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (27, 1, 'supplier', 'weighment_detail', 'Supplier', NULL, 1, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (28, 1, 'firstWeight', 'weighment_detail', 'WT1', NULL, 2, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (29, 1, 'firstWeightDatetime', 'weighment_detail', 'WT1 Datetime', NULL, 5, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (30, 1, 'secondWeight', 'weighment_detail', 'WT2', NULL, 9, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (31, 1, 'firstUnit', 'weighment_detail', 'WT1 Unit', NULL, 1, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (32, 1, 'secondUnit', 'weighment_detail', 'WT2 Unit', NULL, 1, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (33, 1, 'secondWeightDatetime', 'weighment_detail', 'WT2 Datetime', NULL, 11, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (34, 1, 'remark', 'weighment_detail', 'Rmrk', NULL, 1, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (35, 1, 'netWeight', 'weighment_detail', 'Nt Wt', NULL, 13, 1, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (36, 1, 'img1', 'image-field', 'Image 1', NULL, NULL, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (37, 1, 'img2', 'image-field', 'Image 2', NULL, NULL, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (38, 1, 'img3', 'image-field', 'Image 3', NULL, NULL, 0, 'R');
INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (39, 1, 'img4', 'image-field', 'Image 4', NULL, NULL, 0, 'R');

-- STEP 7: Run these to verify
SELECT * FROM ticket_template;
SELECT * FROM template_detail WHERE templateId = 1;
