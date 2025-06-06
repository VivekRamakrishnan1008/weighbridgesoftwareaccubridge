USE [weighbridge]
GO
/****** Object:  Table [dbo].[app_data]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[app_data](
	[field] [varchar](100) NOT NULL,
	[mValue] [varchar](150) NOT NULL,
 CONSTRAINT [PK_app_data] PRIMARY KEY CLUSTERED 
(
	[field] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[app_user]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[app_user](
	[id] [tinyint] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[fullname] [varchar](150) NOT NULL,
	[password] [varchar](200) NOT NULL,
	[role] [varchar](50) NOT NULL,
	[status] [varchar](10) NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[help]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[help](
	[id] [varchar](50) NOT NULL,
	[content] [text] NULL,
 CONSTRAINT [PK_help] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permission]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permission](
	[id] [tinyint] NOT NULL,
	[permission] [varchar](50) NOT NULL,
 CONSTRAINT [PK_permission] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[search_field]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[search_field](
	[id] [tinyint] NOT NULL,
	[displayName] [varchar](100) NOT NULL,
	[inOutMode] [varchar](50) NOT NULL,
	[entryMode] [varchar](50) NOT NULL,
	[enable] [tinyint] NOT NULL,
	[fieldName] [varchar](100) NULL,
 CONSTRAINT [PK_search_field_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[search_field_value]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[search_field_value](
	[id] [smallint] NOT NULL,
	[search_field_id] [tinyint] NOT NULL,
	[mValue] [varchar](100) NOT NULL,
	[code] [varchar](10) NOT NULL,
 CONSTRAINT [PK_search_field_value_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tag]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tag](
	[id] [uniqueidentifier] NOT NULL,
	[displayName] [varchar](100) NOT NULL,
	[entryMode] [varchar](50) NOT NULL,
	[inOutMode] [varchar](50) NOT NULL,
	[mValues] [varchar](max) NULL,
 CONSTRAINT [PK_tag] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[template_detail]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
 CONSTRAINT [PK_template_detail] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ticket_template]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ticket_template](
	[id] [tinyint] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[applicableTo] [varchar](100) NULL,
	[printerType] [varchar](50) NOT NULL,
	[defaultPrinter] [varchar](50) NULL,
	[labelLength] [smallint] NOT NULL,
	[copiesPerPrint] [tinyint] NOT NULL,
	[alignment] [varchar](50) NOT NULL,
	[width] [smallint] NULL,
	[font] [varchar](50) NOT NULL,
	[fontSize] [tinyint] NOT NULL,
	[operatingType] [varchar](50) NULL,
 CONSTRAINT [PK_ticket_template] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_permission]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_permission](
	[userid] [tinyint] NOT NULL,
	[permissionid] [tinyint] NOT NULL,
 CONSTRAINT [PK_user_permission] PRIMARY KEY CLUSTERED 
(
	[userid] ASC,
	[permissionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_tare_weight]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_tare_weight](
	[vehicleNo] [nvarchar](50) NOT NULL,
	[weight] [float] NOT NULL,
	[createdBy] [tinyint] NOT NULL,
	[weighbridge] [varchar](255) NULL,
 CONSTRAINT [PK_vehicle_tare_weight] PRIMARY KEY CLUSTERED 
(
	[vehicleNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weighbridge]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weighbridge](
	[id] [tinyint] NOT NULL,
	[title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_weighbridge] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weighindicator]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weighindicator](
	[id] [tinyint] NOT NULL,
	[weighstring] [varchar](50) NOT NULL,
	[port] [smallint] NULL,
	[status] [varchar](50) NULL,
	[measuringUnit] [varchar](50) NOT NULL,
	[decimalPoint] [tinyint] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[httpType] [varchar](50) NULL,
	[comPort] [varchar](100) NOT NULL,
	[wiName] [varchar](50) NOT NULL,
	[ipAddress] [varchar](50) NULL,
 CONSTRAINT [PK_weighindicator] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weighment]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[scrollNo] [varchar](255) NULL,
	[scrollDate] [varchar](255) NULL,
	[reqIdDate] [varchar](255) NULL,
	[syncFlag] [tinyint] NOT NULL,
	[misc] [varchar](1000) NULL,
 CONSTRAINT [PK_weighment] PRIMARY KEY CLUSTERED 
(
	[rstNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weighment_details]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weighment_details](
	[id] [int] NOT NULL,
	[weighmentRstNo] [int] NOT NULL,
	[material] [varchar](255) NULL,
	[supplier] [varchar](255) NULL,
	[firstWeighBridge] [varchar](255) NULL,
	[firstWeight] [float] NOT NULL,
	[firstUnit] [varchar](50) NOT NULL,
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
 CONSTRAINT [PK_weighment_details] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weighstring]    Script Date: 09-05-2022 13:18:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weighstring](
	[stringName] [varchar](50) NOT NULL,
	[totalChars] [tinyint] NULL,
	[variableLength] [bit] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[pollingCommand] [varchar](50) NULL,
	[baudRate] [int] NOT NULL,
	[dataBits] [tinyint] NOT NULL,
	[stopBits] [tinyint] NOT NULL,
	[parity] [varchar](50) NULL,
	[flowControl] [varchar](50) NOT NULL,
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
 CONSTRAINT [PK_weighstring] PRIMARY KEY CLUSTERED 
(
	[stringName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[search_field] ADD  CONSTRAINT [DF_search_field_enable]  DEFAULT ((1)) FOR [enable]
GO
ALTER TABLE [dbo].[tag] ADD  CONSTRAINT [DF_tag_inOutMode]  DEFAULT ('GENERIC') FOR [inOutMode]
GO
ALTER TABLE [dbo].[ticket_template] ADD  CONSTRAINT [DF_ticket_template_labelLength]  DEFAULT ((200)) FOR [labelLength]
GO
ALTER TABLE [dbo].[ticket_template] ADD  CONSTRAINT [DF_ticket_template_copiesPerPrint]  DEFAULT ((1)) FOR [copiesPerPrint]
GO
ALTER TABLE [dbo].[ticket_template] ADD  CONSTRAINT [DF_ticket_template_alignment]  DEFAULT ('Horizontal') FOR [alignment]
GO
ALTER TABLE [dbo].[ticket_template] ADD  CONSTRAINT [DF_ticket_template_font]  DEFAULT ('Arial') FOR [font]
GO
ALTER TABLE [dbo].[ticket_template] ADD  CONSTRAINT [DF_ticket_template_fontSize]  DEFAULT ((10)) FOR [fontSize]
GO
ALTER TABLE [dbo].[weighindicator] ADD  CONSTRAINT [DF_weighindicator_measuringUnit]  DEFAULT ('KG') FOR [measuringUnit]
GO
ALTER TABLE [dbo].[weighindicator] ADD  CONSTRAINT [DF_weighindicator_decimalPoint]  DEFAULT ((0)) FOR [decimalPoint]
GO
ALTER TABLE [dbo].[weighindicator] ADD  CONSTRAINT [DF_weighindicator_type]  DEFAULT ('serial') FOR [type]
GO
ALTER TABLE [dbo].[weighindicator] ADD  CONSTRAINT [DF_weighindicator_comPort]  DEFAULT ('COM3') FOR [comPort]
GO
ALTER TABLE [dbo].[weighment] ADD  CONSTRAINT [DF_weighment_syncFlag]  DEFAULT ((0)) FOR [syncFlag]
GO
ALTER TABLE [dbo].[weighment_details] ADD  CONSTRAINT [DF_weighment_details_firstUnit]  DEFAULT ('Kg') FOR [firstUnit]
GO
ALTER TABLE [dbo].[weighstring] ADD  CONSTRAINT [DF_weighstring_variableLength]  DEFAULT ((0)) FOR [variableLength]
GO
ALTER TABLE [dbo].[weighstring] ADD  CONSTRAINT [DF_weighstring_type]  DEFAULT ('continuous') FOR [type]
GO
ALTER TABLE [dbo].[weighstring] ADD  CONSTRAINT [DF_weighstring_baudRate]  DEFAULT ((2400)) FOR [baudRate]
GO
ALTER TABLE [dbo].[weighstring] ADD  CONSTRAINT [DF_weighstring_dataBits]  DEFAULT ((8)) FOR [dataBits]
GO
ALTER TABLE [dbo].[weighstring] ADD  CONSTRAINT [DF_weighstring_stopBits]  DEFAULT ((1)) FOR [stopBits]
GO
ALTER TABLE [dbo].[weighstring] ADD  CONSTRAINT [DF_weighstring_flowControl]  DEFAULT ('None') FOR [flowControl]
GO
ALTER TABLE [dbo].[search_field_value]  WITH CHECK ADD  CONSTRAINT [FK_search_field_value_search_field] FOREIGN KEY([search_field_id])
REFERENCES [dbo].[search_field] ([id])
GO
ALTER TABLE [dbo].[search_field_value] CHECK CONSTRAINT [FK_search_field_value_search_field]
GO
ALTER TABLE [dbo].[template_detail]  WITH CHECK ADD  CONSTRAINT [FK_template_detail_ticket_template] FOREIGN KEY([templateId])
REFERENCES [dbo].[ticket_template] ([id])
GO
ALTER TABLE [dbo].[template_detail] CHECK CONSTRAINT [FK_template_detail_ticket_template]
GO
ALTER TABLE [dbo].[user_permission]  WITH CHECK ADD  CONSTRAINT [FK_user_permission_permission] FOREIGN KEY([permissionid])
REFERENCES [dbo].[permission] ([id])
GO
ALTER TABLE [dbo].[user_permission] CHECK CONSTRAINT [FK_user_permission_permission]
GO
ALTER TABLE [dbo].[user_permission]  WITH CHECK ADD  CONSTRAINT [FK_user_permission_user] FOREIGN KEY([userid])
REFERENCES [dbo].[app_user] ([id])
GO
ALTER TABLE [dbo].[user_permission] CHECK CONSTRAINT [FK_user_permission_user]
GO
ALTER TABLE [dbo].[vehicle_tare_weight]  WITH CHECK ADD  CONSTRAINT [FK_vehicle_tare_weight_vehicle_tare_weight] FOREIGN KEY([createdBy])
REFERENCES [dbo].[app_user] ([id])
GO
ALTER TABLE [dbo].[vehicle_tare_weight] CHECK CONSTRAINT [FK_vehicle_tare_weight_vehicle_tare_weight]
GO
ALTER TABLE [dbo].[weighindicator]  WITH CHECK ADD  CONSTRAINT [FK_weighindicator_weighstring] FOREIGN KEY([weighstring])
REFERENCES [dbo].[weighstring] ([stringName])
GO
ALTER TABLE [dbo].[weighindicator] CHECK CONSTRAINT [FK_weighindicator_weighstring]
GO
ALTER TABLE [dbo].[weighment]  WITH CHECK ADD  CONSTRAINT [FK_weighment_weighment] FOREIGN KEY([rstNo])
REFERENCES [dbo].[weighment] ([rstNo])
GO
ALTER TABLE [dbo].[weighment] CHECK CONSTRAINT [FK_weighment_weighment]
GO
ALTER TABLE [dbo].[weighment_details]  WITH CHECK ADD  CONSTRAINT [FK_weighment_details_app_user] FOREIGN KEY([secondWeightUser])
REFERENCES [dbo].[app_user] ([id])
GO
ALTER TABLE [dbo].[weighment_details] CHECK CONSTRAINT [FK_weighment_details_app_user]
GO
ALTER TABLE [dbo].[weighment_details]  WITH CHECK ADD  CONSTRAINT [FK_weighment_details_app_user1] FOREIGN KEY([firstWeightUser])
REFERENCES [dbo].[app_user] ([id])
GO
ALTER TABLE [dbo].[weighment_details] CHECK CONSTRAINT [FK_weighment_details_app_user1]
GO
ALTER TABLE [dbo].[weighment_details]  WITH CHECK ADD  CONSTRAINT [FK_weighment_details_weighment] FOREIGN KEY([weighmentRstNo])
REFERENCES [dbo].[weighment] ([rstNo])
GO
ALTER TABLE [dbo].[weighment_details] CHECK CONSTRAINT [FK_weighment_details_weighment]
GO
