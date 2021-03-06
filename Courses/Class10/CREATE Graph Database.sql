CREATE DATABASE Graph
GO

USE [Graph]
GO
/****** Object:  Table [dbo].[OrgHierarchy]    Script Date: 10/19/2017 1:41:49 PM ******/

CREATE TABLE [dbo].[OrgHierarchy](
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[ReportsTo] [int] NULL,
	[Department] [varchar](20) NULL
) ON [PRIMARY]

GO

INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (1, N'Davolio', N'Nancy', 3, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (2, N'Fuller', N'Andrew', NULL, NULL)
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (3, N'Leverling', N'Janet', 2, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (4, N'Peacock', N'Margaret', 3, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (5, N'Buchanan', N'Steven', 2, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (6, N'Suyama', N'Michael', 5, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (7, N'King', N'Robert', 5, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (8, N'Callahan', N'Laura', 4, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (9, N'Dodsworth', N'Anne', 4, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (10, N'Robinson', N'Peter', 8, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (11, N'Smith', N'Mary', 8, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (12, N'Chang', N'Leslie', 7, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (13, N'Morales', N'Conney', 12, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (14, N'Ng', N'Jordan', 12, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (15, N'Black', N'Lela', 11, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (16, N'Lee', N'Josh', 14, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (17, N'Spencer', N'Monica', 16, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (19, N'Smith', N'JoAnna', 17, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (20, N'White', N'Peter', 16, N'Finance')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (21, N'Thompson', N'Connie', 11, N'IT')
GO
INSERT [dbo].[OrgHierarchy] ([EmployeeID], [LastName], [FirstName], [ReportsTo], [Department]) VALUES (22, N'Norman', N'Alyssa', 16, N'Finance')
GO
