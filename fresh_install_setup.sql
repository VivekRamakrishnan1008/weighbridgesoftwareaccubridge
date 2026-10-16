-- ============================================================
-- Accubridge Weighbridge Software - Fresh MS SQL Server Setup
-- Run this script on a newly installed SQL Server instance.
-- It will create the database, all tables, constraints,
-- default data, and an admin user.
-- ============================================================

-- ============================================================
-- STEP 1: Create the database
-- ============================================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'weighbridge')
BEGIN
    CREATE DATABASE [weighbridge];
END
GO

USE [weighbridge]
GO

-- ============================================================
-- STEP 2: Create tables
-- ============================================================

-- app_data
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[app_data]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[app_data](
        [field] [varchar](100) NOT NULL,
        [mValue] [varchar](2500) NOT NULL,
     CONSTRAINT [PK_app_data] PRIMARY KEY CLUSTERED ([field] ASC)
    ) ON [PRIMARY]
END
GO

-- app_user
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[app_user]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[app_user](
        [id] [tinyint] NOT NULL,
        [username] [varchar](30) NOT NULL,
        [fullname] [varchar](150) NOT NULL,
        [password] [varchar](200) NOT NULL,
        [role] [varchar](50) NOT NULL,
        [status] [varchar](10) NULL,
     CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- help
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[help]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[help](
        [id] [varchar](50) NOT NULL,
        [content] [text] NULL,
     CONSTRAINT [PK_help] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- permission
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[permission]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[permission](
        [id] [tinyint] NOT NULL,
        [permission] [varchar](50) NOT NULL,
     CONSTRAINT [PK_permission] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- search_field
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[search_field]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[search_field](
        [id] [tinyint] NOT NULL,
        [displayName] [varchar](100) NOT NULL,
        [inOutMode] [varchar](50) NOT NULL,
        [entryMode] [varchar](50) NOT NULL,
        [enable] [tinyint] NOT NULL CONSTRAINT [DF_search_field_enable] DEFAULT ((1)),
        [fieldName] [varchar](100) NULL,
     CONSTRAINT [PK_search_field_1] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- search_field_value
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[search_field_value]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[search_field_value](
        [id] [smallint] NOT NULL,
        [search_field_id] [tinyint] NOT NULL,
        [mValue] [varchar](100) NOT NULL,
        [code] [varchar](10) NOT NULL,
     CONSTRAINT [PK_search_field_value_1] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- tag
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tag]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[tag](
        [id] [uniqueidentifier] NOT NULL,
        [displayName] [varchar](100) NOT NULL,
        [entryMode] [varchar](50) NOT NULL,
        [inOutMode] [varchar](50) NOT NULL CONSTRAINT [DF_tag_inOutMode] DEFAULT ('GENERIC'),
        [mValues] [varchar](max) NULL,
     CONSTRAINT [PK_tag] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- ticket_template
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ticket_template]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[ticket_template](
        [id] [tinyint] NOT NULL,
        [name] [varchar](50) NOT NULL,
        [applicableTo] [varchar](100) NULL,
        [printerType] [varchar](50) NOT NULL,
        [defaultPrinter] [varchar](50) NULL,
        [labelLength] [smallint] NOT NULL CONSTRAINT [DF_ticket_template_labelLength] DEFAULT ((200)),
        [copiesPerPrint] [tinyint] NOT NULL CONSTRAINT [DF_ticket_template_copiesPerPrint] DEFAULT ((1)),
        [alignment] [varchar](50) NOT NULL CONSTRAINT [DF_ticket_template_alignment] DEFAULT ('Horizontal'),
        [width] [smallint] NULL,
        [font] [varchar](50) NOT NULL CONSTRAINT [DF_ticket_template_font] DEFAULT ('Arial'),
        [fontSize] [tinyint] NOT NULL CONSTRAINT [DF_ticket_template_fontSize] DEFAULT ((10)),
        [operatingType] [varchar](50) NULL,
     CONSTRAINT [PK_ticket_template] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- template_detail
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[template_detail]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[template_detail](
        [id] [smallint] NOT NULL,
        [templateId] [tinyint] NOT NULL,
        [field] [varchar](50) NULL,
        [type] [varchar](50) NULL,
        [displayName] [varchar](500) NOT NULL,
        [row] [smallint] NULL,
        [col] [smallint] NULL,
        [isIncluded] [bit] NULL,
        [font] [varchar](50) NULL,
     CONSTRAINT [PK_template_detail] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- user_permission
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_permission]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[user_permission](
        [userid] [tinyint] NOT NULL,
        [permissionid] [tinyint] NOT NULL,
     CONSTRAINT [PK_user_permission] PRIMARY KEY CLUSTERED ([userid] ASC, [permissionid] ASC)
    ) ON [PRIMARY]
END
GO

-- vehicle_tare_weight
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vehicle_tare_weight]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[vehicle_tare_weight](
        [vehicleNo] [nvarchar](50) NOT NULL,
        [weight] [float] NOT NULL,
        [createdBy] [tinyint] NOT NULL,
        [weighbridge] [varchar](255) NULL,
     CONSTRAINT [PK_vehicle_tare_weight] PRIMARY KEY CLUSTERED ([vehicleNo] ASC)
    ) ON [PRIMARY]
END
GO

-- weighbridge
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weighbridge]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[weighbridge](
        [id] [tinyint] NOT NULL,
        [title] [nvarchar](50) NOT NULL,
     CONSTRAINT [PK_weighbridge] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- weighindicator
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weighindicator]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[weighindicator](
        [id] [tinyint] NOT NULL,
        [weighstring] [varchar](50) NOT NULL,
        [port] [smallint] NULL,
        [status] [varchar](50) NULL,
        [measuringUnit] [varchar](50) NOT NULL CONSTRAINT [DF_weighindicator_measuringUnit] DEFAULT ('KG'),
        [decimalPoint] [tinyint] NOT NULL CONSTRAINT [DF_weighindicator_decimalPoint] DEFAULT ((0)),
        [type] [varchar](50) NOT NULL CONSTRAINT [DF_weighindicator_type] DEFAULT ('serial'),
        [httpType] [varchar](50) NULL,
        [comPort] [varchar](100) NOT NULL CONSTRAINT [DF_weighindicator_comPort] DEFAULT ('COM3'),
        [wiName] [varchar](50) NOT NULL,
        [ipAddress] [varchar](50) NULL,
     CONSTRAINT [PK_weighindicator] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- weighment
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[weighment](
        [rstNo] [int] NOT NULL,
        [vehicleNo] [varchar](20) NOT NULL,
        [reqId] [varchar](255) NULL,
        [gatePassNo] [varchar](255) NULL,
        [weighmentType] [varchar](50) NOT NULL,
        [poDetails] [varchar](255) NULL,
        [transporterCode] [varchar](50) NULL,
        [transporterName] [varchar](512) NULL,
        [status] [varchar](50) NOT NULL,
        [createdAt] [datetime] NULL,
        [scrollNo] [varchar](500) NULL,
        [scrollDate] [varchar](50) NULL,
        [reqIdDate] [varchar](8) NULL,
        [syncFlag] [tinyint] NOT NULL CONSTRAINT [DF_weighment_syncFlag] DEFAULT ((0)),
        [misc] [varchar](1000) NULL,
        [extras] [varchar](1000) NULL,
        [containerNo] [varchar](100) NULL,
        [licenseNo] [varchar](100) NULL,
        [driverName] [varchar](150) NULL,
        [pucNo] [varchar](100) NULL,
     CONSTRAINT [PK_weighment] PRIMARY KEY CLUSTERED ([rstNo] ASC)
    ) ON [PRIMARY]
END
GO

-- weighment_details
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weighment_details]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[weighment_details](
        [id] [int] NOT NULL,
        [weighmentRstNo] [int] NOT NULL,
        [material] [varchar](255) NULL,
        [supplier] [varchar](255) NULL,
        [firstWeighBridge] [varchar](255) NULL,
        [firstWeight] [float] NOT NULL,
        [firstUnit] [varchar](50) NOT NULL CONSTRAINT [DF_weighment_details_firstUnit] DEFAULT ('Kg'),
        [firstWeightDatetime] [datetime] NOT NULL,
        [firstWeightUser] [tinyint] NULL,
        [secondWeighBridge] [varchar](255) NULL,
        [secondWeight] [float] NULL,
        [secondUnit] [varchar](50) NULL,
        [secondWeightDatetime] [datetime] NULL,
        [secondWeightUser] [tinyint] NULL,
        [remark] [varchar](1000) NULL,
        [netWeight] [float] NULL,
        [customer] [varchar](255) NULL,
        [firstWeightImage] [varchar](1024) NULL,
        [secondWeightImage] [varchar](1024) NULL,
     CONSTRAINT [PK_weighment_details] PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

-- weighstring
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weighstring]') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[weighstring](
        [stringName] [varchar](50) NOT NULL,
        [totalChars] [tinyint] NULL,
        [variableLength] [bit] NOT NULL CONSTRAINT [DF_weighstring_variableLength] DEFAULT ((0)),
        [type] [varchar](50) NOT NULL CONSTRAINT [DF_weighstring_type] DEFAULT ('continuous'),
        [pollingCommand] [varchar](50) NULL,
        [baudRate] [int] NOT NULL CONSTRAINT [DF_weighstring_baudRate] DEFAULT ((2400)),
        [dataBits] [tinyint] NOT NULL CONSTRAINT [DF_weighstring_dataBits] DEFAULT ((8)),
        [stopBits] [tinyint] NOT NULL CONSTRAINT [DF_weighstring_stopBits] DEFAULT ((1)),
        [parity] [varchar](50) NULL,
        [flowControl] [varchar](50) NOT NULL CONSTRAINT [DF_weighstring_flowControl] DEFAULT ('None'),
        [weightCharPosition1] [tinyint] NULL,
        [weightCharPosition2] [tinyint] NULL,
        [weightCharPosition3] [tinyint] NULL,
        [weightCharPosition4] [tinyint] NULL,
        [weightCharPosition5] [tinyint] NULL,
        [weightCharPosition6] [tinyint] NULL,
        [startChar1] [varchar](4) NULL,
        [startChar2] [varchar](4) NULL,
        [startChar3] [varchar](4) NULL,
        [startChar4] [varchar](4) NULL,
        [endChar1] [varchar](4) NULL,
        [endChar2] [varchar](4) NULL,
        [endChar3] [varchar](4) NULL,
        [signCharPosition] [tinyint] NULL,
        [negativeSignValue] [varchar](4) NULL,
        [delimeter] [varchar](10) NULL,
     CONSTRAINT [PK_weighstring] PRIMARY KEY CLUSTERED ([stringName] ASC)
    ) ON [PRIMARY]
END
GO

-- ============================================================
-- STEP 3: Foreign key constraints
-- ============================================================

-- search_field_value -> search_field
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_search_field_value_search_field')
BEGIN
    ALTER TABLE [dbo].[search_field_value] WITH CHECK ADD CONSTRAINT [FK_search_field_value_search_field]
        FOREIGN KEY([search_field_id]) REFERENCES [dbo].[search_field] ([id])
    ALTER TABLE [dbo].[search_field_value] CHECK CONSTRAINT [FK_search_field_value_search_field]
END
GO

-- template_detail -> ticket_template
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_template_detail_ticket_template')
BEGIN
    ALTER TABLE [dbo].[template_detail] WITH CHECK ADD CONSTRAINT [FK_template_detail_ticket_template]
        FOREIGN KEY([templateId]) REFERENCES [dbo].[ticket_template] ([id])
    ALTER TABLE [dbo].[template_detail] CHECK CONSTRAINT [FK_template_detail_ticket_template]
END
GO

-- user_permission -> permission
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_user_permission_permission')
BEGIN
    ALTER TABLE [dbo].[user_permission] WITH CHECK ADD CONSTRAINT [FK_user_permission_permission]
        FOREIGN KEY([permissionid]) REFERENCES [dbo].[permission] ([id])
    ALTER TABLE [dbo].[user_permission] CHECK CONSTRAINT [FK_user_permission_permission]
END
GO

-- user_permission -> app_user
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_user_permission_user')
BEGIN
    ALTER TABLE [dbo].[user_permission] WITH CHECK ADD CONSTRAINT [FK_user_permission_user]
        FOREIGN KEY([userid]) REFERENCES [dbo].[app_user] ([id])
    ALTER TABLE [dbo].[user_permission] CHECK CONSTRAINT [FK_user_permission_user]
END
GO

-- vehicle_tare_weight -> app_user
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_vehicle_tare_weight_vehicle_tare_weight')
BEGIN
    ALTER TABLE [dbo].[vehicle_tare_weight] WITH CHECK ADD CONSTRAINT [FK_vehicle_tare_weight_vehicle_tare_weight]
        FOREIGN KEY([createdBy]) REFERENCES [dbo].[app_user] ([id])
    ALTER TABLE [dbo].[vehicle_tare_weight] CHECK CONSTRAINT [FK_vehicle_tare_weight_vehicle_tare_weight]
END
GO

-- weighindicator -> weighstring
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_weighindicator_weighstring')
BEGIN
    ALTER TABLE [dbo].[weighindicator] WITH CHECK ADD CONSTRAINT [FK_weighindicator_weighstring]
        FOREIGN KEY([weighstring]) REFERENCES [dbo].[weighstring] ([stringName])
    ALTER TABLE [dbo].[weighindicator] CHECK CONSTRAINT [FK_weighindicator_weighstring]
END
GO

-- weighment self-ref
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_weighment_weighment')
BEGIN
    ALTER TABLE [dbo].[weighment] WITH CHECK ADD CONSTRAINT [FK_weighment_weighment]
        FOREIGN KEY([rstNo]) REFERENCES [dbo].[weighment] ([rstNo])
    ALTER TABLE [dbo].[weighment] CHECK CONSTRAINT [FK_weighment_weighment]
END
GO

-- weighment_details -> app_user (secondWeightUser)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_weighment_details_app_user')
BEGIN
    ALTER TABLE [dbo].[weighment_details] WITH CHECK ADD CONSTRAINT [FK_weighment_details_app_user]
        FOREIGN KEY([secondWeightUser]) REFERENCES [dbo].[app_user] ([id])
    ALTER TABLE [dbo].[weighment_details] CHECK CONSTRAINT [FK_weighment_details_app_user]
END
GO

-- weighment_details -> app_user (firstWeightUser)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_weighment_details_app_user1')
BEGIN
    ALTER TABLE [dbo].[weighment_details] WITH CHECK ADD CONSTRAINT [FK_weighment_details_app_user1]
        FOREIGN KEY([firstWeightUser]) REFERENCES [dbo].[app_user] ([id])
    ALTER TABLE [dbo].[weighment_details] CHECK CONSTRAINT [FK_weighment_details_app_user1]
END
GO

-- weighment_details -> weighment
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_weighment_details_weighment')
BEGIN
    ALTER TABLE [dbo].[weighment_details] WITH CHECK ADD CONSTRAINT [FK_weighment_details_weighment]
        FOREIGN KEY([weighmentRstNo]) REFERENCES [dbo].[weighment] ([rstNo])
    ALTER TABLE [dbo].[weighment_details] CHECK CONSTRAINT [FK_weighment_details_weighment]
END
GO

-- ============================================================
-- STEP 4: Seed data (only inserts rows that don't exist yet)
-- ============================================================

-- Default admin user (password: Admin123) and test operator (password: Test123)
IF NOT EXISTS (SELECT 1 FROM [dbo].[app_user] WHERE [id] = 1)
    INSERT INTO [dbo].[app_user] ([id],[username],[fullname],[password],[role],[status])
    VALUES (1, 'admin', 'Administrator', 'Admin123', 'Admin', 'Active')
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[app_user] WHERE [id] = 2)
    INSERT INTO [dbo].[app_user] ([id],[username],[fullname],[password],[role],[status])
    VALUES (2, 'test', 'Test User', 'Test123', 'Operator', 'Active')
GO

-- Permissions
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 1)  INSERT INTO [dbo].[permission] VALUES (1,  'Weighment')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 2)  INSERT INTO [dbo].[permission] VALUES (2,  'System setup')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 3)  INSERT INTO [dbo].[permission] VALUES (3,  'Ticket Setup')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 4)  INSERT INTO [dbo].[permission] VALUES (4,  'Vehicle Setup')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 5)  INSERT INTO [dbo].[permission] VALUES (5,  'Backup')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 6)  INSERT INTO [dbo].[permission] VALUES (6,  'Data edit after complete weighment')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 7)  INSERT INTO [dbo].[permission] VALUES (7,  'Theft detection report')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 8)  INSERT INTO [dbo].[permission] VALUES (8,  'Reports')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 9)  INSERT INTO [dbo].[permission] VALUES (9,  'Code and list entries')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 10) INSERT INTO [dbo].[permission] VALUES (10, 'User Management')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 11) INSERT INTO [dbo].[permission] VALUES (11, 'Change Password')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 12) INSERT INTO [dbo].[permission] VALUES (12, 'Partial Weighment')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 13) INSERT INTO [dbo].[permission] VALUES (13, 'Theft Detection Setup')
IF NOT EXISTS (SELECT 1 FROM [dbo].[permission] WHERE [id] = 14) INSERT INTO [dbo].[permission] VALUES (14, 'SAP Configuration')
GO

-- Admin gets ALL permissions (1-14)
DECLARE @i TINYINT = 1
WHILE @i <= 14
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[user_permission] WHERE [userid]=1 AND [permissionid]=@i)
        INSERT INTO [dbo].[user_permission] VALUES (1, @i)
    SET @i = @i + 1
END
-- Test user gets permissions 1-3
SET @i = 1
WHILE @i <= 3
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[user_permission] WHERE [userid]=2 AND [permissionid]=@i)
        INSERT INTO [dbo].[user_permission] VALUES (2, @i)
    SET @i = @i + 1
END
GO

-- App settings (app_data) - only insert if not already present
DECLARE @settings TABLE (field VARCHAR(100), mValue VARCHAR(2500))
INSERT INTO @settings VALUES
('additional_fields','[]'),
('date_format','dd-MM-yyyy hh:mm'),
('enableInbound','true'),
('enableOutbound','false'),
('enableOutboundExport','true'),
('enableOutboundDomestic','true'),
('enableOutboundSubcontract','true'),
('enableOthers','true'),
('enableInternal','false'),
('enableWhiteSpacesInVehicle','false'),
('enableWeightEditing','false'),
('enterFirstWeightManually','false'),
('enableWeighmentTypes','yes'),
('logLevel','error'),
('enable_invoice_creation','true'),
('enable_inbound_challan_weight','false'),
('enable_inbound_validation','false'),
('inbound_upper_limit',''),
('inbound_lower_limit',''),
('inbound_on_validation_failure','Do not save'),
('enable_outbound_challan_weight','false'),
('enable_outbound_validation','false'),
('outbound_upper_limit',''),
('outbound_lower_limit',''),
('outbound_on_validation_failure','Do not save'),
('enable_inbound_outbound','true'),
('enable_internal_weight','true'),
('enable_data_edit_after_completion','false'),
('data_edit_reason_length','200'),
('min_vehicle_length','8'),
('min_reciept_length','4'),
('save_on_zero_weight','false'),
('enable_zero_check','false'),
('zero_tolerance','0'),
('allow_zero_net_weight','false'),
('net_weight_fluctuation','0'),
('enable_stable_weight','true'),
('allowed_variation','0'),
('enable_auto_print_post_weighment','false'),
('print_cnt_post_weight1','1'),
('print_cnt_post_weight2','1'),
('report_header_1',''),
('report_header_2',''),
('report_print_current_date','false'),
('report_print_search_params','false'),
('report_readonly','false'),
('is_report_password_protected','false'),
('report_password',''),
('report_date_format','dd-MM-yyyy'),
('report_time_format','HH:mm'),
('currency',''),
('decimals_in_weight',''),
('enable_scheduled_backup','false'),
('backup_location',''),
('allow_email','false'),
('enable_daily_email','false'),
('daily_email_time',''),
('enable_daily_operator_collection_email','false'),
('collection_email_time',''),
('email_provider',''),
('email_condition',''),
('sender_email_id',''),
('email_password',''),
('sender_name',''),
('email_server',''),
('email_port',''),
('email_protocol',''),
('recipients',''),
('enableSAPIntegration','false'),
('sapUsername',''),
('sapPassword',''),
('sapEndpoint','')

INSERT INTO [dbo].[app_data] ([field],[mValue])
SELECT s.field, s.mValue
FROM @settings s
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[app_data] a WHERE a.field = s.field)
GO

-- Default weigh indicator strings (common configurations)
IF NOT EXISTS (SELECT 1 FROM [dbo].[weighstring] WHERE [stringName] = 'String13')
    INSERT INTO [dbo].[weighstring] ([stringName],[totalChars],[variableLength],[type],[pollingCommand],[baudRate],[dataBits],[stopBits],[parity],[flowControl],[weightCharPosition1],[weightCharPosition2],[weightCharPosition3],[weightCharPosition4],[weightCharPosition5],[weightCharPosition6],[startChar1],[startChar2],[startChar3],[startChar4],[endChar1],[endChar2],[endChar3],[signCharPosition],[negativeSignValue],[delimeter])
    VALUES ('String13', 8, 0, 'continuous', NULL, 2400, 8, 1, 'none', 'None', 2, 3, 4, 5, 6, NULL, '2', NULL, NULL, NULL, '3', 'D', 'A', 1, '-', '\n')
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[weighstring] WHERE [stringName] = 'Avery11')
    INSERT INTO [dbo].[weighstring] ([stringName],[totalChars],[variableLength],[type],[pollingCommand],[baudRate],[dataBits],[stopBits],[parity],[flowControl],[weightCharPosition1],[weightCharPosition2],[weightCharPosition3],[weightCharPosition4],[weightCharPosition5],[weightCharPosition6],[startChar1],[startChar2],[startChar3],[startChar4],[endChar1],[endChar2],[endChar3],[signCharPosition],[negativeSignValue],[delimeter])
    VALUES ('Avery11', 25, 0, 'polling', '05', 1200, 7, 1, 'even', 'None', 3, 4, 5, 6, 7, NULL, '2', NULL, NULL, NULL, '3', 'D', 'A', 1, '-', 'newline')
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[weighstring] WHERE [stringName] = 'Avery8')
    INSERT INTO [dbo].[weighstring] ([stringName],[totalChars],[variableLength],[type],[pollingCommand],[baudRate],[dataBits],[stopBits],[parity],[flowControl],[weightCharPosition1],[weightCharPosition2],[weightCharPosition3],[weightCharPosition4],[weightCharPosition5],[weightCharPosition6],[startChar1],[startChar2],[startChar3],[startChar4],[endChar1],[endChar2],[endChar3],[signCharPosition],[negativeSignValue],[delimeter])
    VALUES ('Avery8', 19, 0, 'continuous', NULL, 1200, 7, 1, 'even', 'None', 5, 6, 7, 8, 9, NULL, '2', NULL, NULL, NULL, '3', 'D', 'A', 3, '-', '\n')
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[weighstring] WHERE [stringName] = 'Avery7')
    INSERT INTO [dbo].[weighstring] ([stringName],[totalChars],[variableLength],[type],[pollingCommand],[baudRate],[dataBits],[stopBits],[parity],[flowControl],[weightCharPosition1],[weightCharPosition2],[weightCharPosition3],[weightCharPosition4],[weightCharPosition5],[weightCharPosition6],[startChar1],[startChar2],[startChar3],[startChar4],[endChar1],[endChar2],[endChar3],[signCharPosition],[negativeSignValue],[delimeter])
    VALUES ('Avery7', 27, 0, 'continuous', NULL, 2400, 7, 1, 'even', 'None', 5, 6, 7, 8, 9, NULL, '2', NULL, NULL, NULL, '3', 'D', 'A', 3, '-', 'newline')
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[weighstring] WHERE [stringName] = 'UNP')
    INSERT INTO [dbo].[weighstring] ([stringName],[totalChars],[variableLength],[type],[pollingCommand],[baudRate],[dataBits],[stopBits],[parity],[flowControl],[weightCharPosition1],[weightCharPosition2],[weightCharPosition3],[weightCharPosition4],[weightCharPosition5],[weightCharPosition6],[startChar1],[startChar2],[startChar3],[startChar4],[endChar1],[endChar2],[endChar3],[signCharPosition],[negativeSignValue],[delimeter])
    VALUES ('UNP', 13, 0, 'continuous', NULL, 9600, 8, 1, 'None', 'None', 3, 4, 5, 6, 7, NULL, '2', NULL, NULL, NULL, '3', NULL, NULL, 2, '-', NULL)
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[weighstring] WHERE [stringName] = 'String15')
    INSERT INTO [dbo].[weighstring] ([stringName],[totalChars],[variableLength],[type],[pollingCommand],[baudRate],[dataBits],[stopBits],[parity],[flowControl],[weightCharPosition1],[weightCharPosition2],[weightCharPosition3],[weightCharPosition4],[weightCharPosition5],[weightCharPosition6],[startChar1],[startChar2],[startChar3],[startChar4],[endChar1],[endChar2],[endChar3],[signCharPosition],[negativeSignValue],[delimeter])
    VALUES ('String15', 9, 0, 'continuous', NULL, 2400, 8, 1, 'None', 'None', 2, 3, 4, 5, 6, 7, '2', NULL, NULL, NULL, '3', NULL, NULL, 1, '-', 'newline')
GO

-- Default search fields
IF NOT EXISTS (SELECT 1 FROM [dbo].[search_field] WHERE [id] = 1)
    INSERT INTO [dbo].[search_field] ([id],[displayName],[inOutMode],[entryMode],[enable],[fieldName]) VALUES (1, 'Supplier', 'GENERIC', 'LIST_SOFT', 1, 'supplier')
IF NOT EXISTS (SELECT 1 FROM [dbo].[search_field] WHERE [id] = 2)
    INSERT INTO [dbo].[search_field] ([id],[displayName],[inOutMode],[entryMode],[enable],[fieldName]) VALUES (2, 'Material', 'GENERIC', 'LIST_SOFT', 1, 'material')
IF NOT EXISTS (SELECT 1 FROM [dbo].[search_field] WHERE [id] = 3)
    INSERT INTO [dbo].[search_field] ([id],[displayName],[inOutMode],[entryMode],[enable],[fieldName]) VALUES (3, 'Transporter', 'GENERIC', 'LIST_SOFT', 1, 'transporter')
IF NOT EXISTS (SELECT 1 FROM [dbo].[search_field] WHERE [id] = 4)
    INSERT INTO [dbo].[search_field] ([id],[displayName],[inOutMode],[entryMode],[enable],[fieldName]) VALUES (4, 'Customer', 'GENERIC', 'LIST_SOFT', 1, 'customer')
GO

-- Default ticket template
IF NOT EXISTS (SELECT 1 FROM [dbo].[ticket_template] WHERE [id] = 1)
    INSERT INTO [dbo].[ticket_template] ([id],[name],[applicableTo],[printerType],[labelLength],[copiesPerPrint],[alignment],[width],[font],[fontSize],[defaultPrinter],[operatingType])
    VALUES (1, 'GENERIC', 'GENERIC', 'DOT-MATRIX', 200, 1, 'Horizontal', 200, 'Arial', 10, NULL, NULL)
GO

-- Default template detail fields
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 1)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (1, 1, 'transporterCode', 'ticket-field', 'Tranporter Code', 7, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 2)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (2, 1, 'transporterName', 'ticket-field', 'Transporter Name', 6, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 3)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (3, 1, 'scrollNo', 'ticket-field', 'Scroll No', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 4)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (4, 1, 'rstNo', 'ticket-field', 'Rst No', 4, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 5)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (5, 1, 'vehicleNo', 'ticket-field', 'Vehicle No', 5, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 6)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (6, 1, 'reqId', 'ticket-field', 'Request Id', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 7)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (7, 1, 'status', 'ticket-field', 'status', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 8)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (8, 1, 'gatePassNo', 'ticket-field', 'Gate Pass No.', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 9)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (9, 1, 'poDetails', 'ticket-field', 'PO Details', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 10)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (10, 1, 'createdAt', 'ticket-field', 'Created At', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 11)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (11, 1, 'duration', 'ticket-field', 'Duration', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 12)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (12, 1, 'weighmentType', 'ticket-field', 'Inbound / Outbound', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 13)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (13, 1, 'weighmentDetails', 'ticket-field', 'Weighment Details', 12, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 14)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (14, 1, 'weighDetails_id', 'ticket-field', 'Weighslip No', NULL, NULL, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 15)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (15, 1, 'weighDetails_material', 'ticket-field', 'Material', 6, 40, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 16)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (16, 1, 'weighDetails_supplier', 'ticket-field', 'Supplier', 5, 40, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 17)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (17, 1, 'weighDetails_firstWeight', 'ticket-field', 'Wt1(KG)', 8, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 18)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (18, 1, 'weighDetails_firstWeightDatetime', 'ticket-field', 'In Date / Time', 8, 40, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 19)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (19, 1, 'weighDetails_secondWeight', 'ticket-field', 'Wt2(KG)', 9, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 20)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (20, 1, 'weighDetails_secondWeightDatetime', 'ticket-field', 'Out Date / Time', 9, 40, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 21)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (21, 1, 'weighDetails_netWeight', 'ticket-field', 'Net Wt(KG)', 10, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 22)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (22, 1, NULL, 'freetext', 'WEIGHBRIDGE TICKET', 1, 30, 1, 'DB')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 23)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (23, 1, NULL, 'freetext', '---', 2, 30, 1, 'DB')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 24)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (24, 1, NULL, 'freetext', '---------------------------------------------------------------------------------', 3, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 25)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (25, 1, NULL, 'freetext', '---------------------------------------------------------------------------------', 11, 1, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 26)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (26, 1, 'material', 'weighment_detail', 'Material', NULL, 1, 0, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 27)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (27, 1, 'supplier', 'weighment_detail', 'Supplier', NULL, 1, 0, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 28)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (28, 1, 'firstWeight', 'weighment_detail', 'WT1', NULL, 2, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 29)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (29, 1, 'firstWeightDatetime', 'weighment_detail', 'WT1 Datetime', NULL, 5, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 30)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (30, 1, 'secondWeight', 'weighment_detail', 'WT2', NULL, 9, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 31)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (31, 1, 'firstUnit', 'weighment_detail', 'WT1 Unit', NULL, 1, 0, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 32)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (32, 1, 'secondUnit', 'weighment_detail', 'WT2 Unit', NULL, 1, 0, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 33)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (33, 1, 'secondWeightDatetime', 'weighment_detail', 'WT2 Datetime', NULL, 11, 1, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 34)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (34, 1, 'remark', 'weighment_detail', 'Rmrk', NULL, 1, 0, 'R')
IF NOT EXISTS (SELECT 1 FROM [dbo].[template_detail] WHERE [id] = 35)
    INSERT INTO [dbo].[template_detail] ([id],[templateId],[field],[type],[displayName],[row],[col],[isIncluded],[font]) VALUES (35, 1, 'netWeight', 'weighment_detail', 'Nt Wt', NULL, 13, 1, 'R')
GO

-- ============================================================
-- STEP 5: Enable TCP/IP access (informational)
-- ============================================================
-- IMPORTANT: After running this script, ensure:
--   1. SQL Server Browser service is running
--   2. TCP/IP protocol is enabled in SQL Server Configuration Manager
--   3. SQL Server is set to Mixed Mode authentication (if using SQL logins)
--   4. Firewall allows port 1433 (default SQL Server port)
--
-- To create a dedicated SQL login for the app (recommended):
--
--   CREATE LOGIN [accubridge_user] WITH PASSWORD = N'YourStrongPassword';
--   USE [weighbridge];
--   CREATE USER [accubridge_user] FOR LOGIN [accubridge_user];
--   ALTER ROLE [db_owner] ADD MEMBER [accubridge_user];
--   GO
--
-- Then configure the app's Initial Setup with:
--   Server: localhost  (or the machine name/IP)
--   Port:   1433
--   DB:     weighbridge
--   User:   accubridge_user
--   Pass:   YourStrongPassword

PRINT '=== Accubridge database setup complete ==='
PRINT 'Database:  weighbridge'
PRINT 'Admin user: admin / Admin123'
PRINT 'Test user:  test  / Test123'
GO
