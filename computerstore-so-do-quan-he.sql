USE [master]
GO
/****** Object:  Database [QuayLyBanMayTinhVaLinhKienMayTinh]    Script Date: 5/17/2021 4:13:18 PM ******/
CREATE DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuayLyBanMayTinhVaLinhKienMayTinh', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\QuayLyBanMayTinhVaLinhKienMayTinh.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QuayLyBanMayTinhVaLinhKienMayTinh_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\QuayLyBanMayTinhVaLinhKienMayTinh_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuayLyBanMayTinhVaLinhKienMayTinh].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET RECOVERY FULL 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET  MULTI_USER 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'QuayLyBanMayTinhVaLinhKienMayTinh', N'ON'
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET QUERY_STORE = OFF
GO
USE [QuayLyBanMayTinhVaLinhKienMayTinh]
GO
/****** Object:  Table [dbo].[account]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account](
	[account_id] [int] NOT NULL,
	[email] [nvarchar](255) NULL,
	[password] [nvarchar](255) NULL,
	[full_name] [nvarchar](255) NULL,
	[address] [nvarchar](255) NULL,
	[phone_number] [int] NULL,
	[image] [nvarchar](255) NULL,
	[account_type_id] [bigint] NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_account] PRIMARY KEY CLUSTERED 
(
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[account_type]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_type](
	[account_type_id] [int] NOT NULL,
	[value] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_account_type] PRIMARY KEY CLUSTERED 
(
	[account_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bill]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bill](
	[bill_id] [int] NOT NULL,
	[employee_id] [int] NULL,
	[customer_id] [int] NULL,
	[order_status_id] [int] NULL,
	[order_type_id] [int] NULL,
	[name] [nvarchar](255) NULL,
	[address] [nvarchar](255) NULL,
	[note] [text] NULL,
	[total_money] [float] NULL,
	[into_money] [float] NULL,
	[created_at] [datetime] NULL,
	[updatedDate] [datetime] NULL,
 CONSTRAINT [PK_bill] PRIMARY KEY CLUSTERED 
(
	[bill_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bill_detail]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bill_detail](
	[bill_detail_id] [int] NOT NULL,
	[bill_id] [int] NULL,
	[product_id] [int] NULL,
	[price] [float] NULL,
	[amount] [int] NULL,
 CONSTRAINT [PK_bill_detail] PRIMARY KEY CLUSTERED 
(
	[bill_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[build_pc]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[build_pc](
	[build_pc_id] [int] NOT NULL,
	[customer_id] [int] NULL,
	[product_id] [int] NULL,
	[price] [float] NULL,
	[quantity] [int] NULL,
 CONSTRAINT [PK_build_pc] PRIMARY KEY CLUSTERED 
(
	[build_pc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comment]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[comment](
	[comment_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[customer_id] [int] NULL,
	[comment_content] [text] NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[coupon]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coupon](
	[coupon_id] [int] NOT NULL,
	[employee_id] [int] NULL,
	[supplier_id] [int] NULL,
	[total_money] [float] NULL,
	[note] [text] NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_coupon] PRIMARY KEY CLUSTERED 
(
	[coupon_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[coupon_detail]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coupon_detail](
	[coupon_detail_id] [int] NOT NULL,
	[coupon_id] [int] NULL,
	[product_id] [int] NULL,
	[price] [float] NULL,
	[amount] [int] NULL,
 CONSTRAINT [PK_coupon_detail] PRIMARY KEY CLUSTERED 
(
	[coupon_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[news]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[news](
	[news_id] [int] NOT NULL,
	[title] [nvarchar](255) NULL,
	[news_content] [text] NULL,
	[hightlight] [nvarchar](255) NULL,
	[thumbnail] [nvarchar](255) NULL,
	[url] [nvarchar](255) NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_news] PRIMARY KEY CLUSTERED 
(
	[news_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_status]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_status](
	[order_status_id] [int] NOT NULL,
	[value] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_order_status] PRIMARY KEY CLUSTERED 
(
	[order_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_type]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_type](
	[order_type_id] [int] NOT NULL,
	[value] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_order_type] PRIMARY KEY CLUSTERED 
(
	[order_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product](
	[product_id] [int] NOT NULL,
	[product_name] [nvarchar](255) NULL,
	[trademark_id] [int] NULL,
	[prorduct_type_id] [int] NULL,
	[price] [float] NULL,
	[amount] [int] NULL,
	[warranty] [int] NULL,
	[description] [text] NULL,
 CONSTRAINT [PK_product] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_image]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_image](
	[product_image_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[image] [nvarchar](255) NULL,
 CONSTRAINT [PK_product_image] PRIMARY KEY CLUSTERED 
(
	[product_image_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_promotion]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_promotion](
	[product_promotion_id] [int] NOT NULL,
	[product_id] [int] NULL,
	[promotion_date_id] [int] NULL,
	[promotion_level] [int] NULL,
 CONSTRAINT [PK_product_promotion] PRIMARY KEY CLUSTERED 
(
	[product_promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_type]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_type](
	[product_type_id] [int] NOT NULL,
	[product_type_name] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_product_type] PRIMARY KEY CLUSTERED 
(
	[product_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[promotion_date]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promotion_date](
	[promotion_date_id] [int] NOT NULL,
	[date] [datetime] NULL,
 CONSTRAINT [PK_promotion_date] PRIMARY KEY CLUSTERED 
(
	[promotion_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[supplier]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[supplier](
	[supplier_id] [int] NOT NULL,
	[supplier_name] [nvarchar](255) NULL,
	[supplier_address] [nvarchar](255) NULL,
	[email] [nvarchar](255) NULL,
	[hotline] [nvarchar](255) NULL,
 CONSTRAINT [PK_supplier] PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trademark]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trademark](
	[trademark_id] [int] NOT NULL,
	[trademark_name] [nvarchar](255) NULL,
	[image] [nvarchar](255) NULL,
 CONSTRAINT [PK_trademark] PRIMARY KEY CLUSTERED 
(
	[trademark_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voucher]    Script Date: 5/17/2021 4:13:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voucher](
	[voucher_id] [int] NOT NULL,
	[customer_id] [int] NULL,
	[voucher_level] [int] NULL,
 CONSTRAINT [PK_voucher] PRIMARY KEY CLUSTERED 
(
	[voucher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bill]  WITH CHECK ADD  CONSTRAINT [FK_bill_account] FOREIGN KEY([employee_id])
REFERENCES [dbo].[account] ([account_id])
GO
ALTER TABLE [dbo].[bill] CHECK CONSTRAINT [FK_bill_account]
GO
ALTER TABLE [dbo].[bill]  WITH CHECK ADD  CONSTRAINT [FK_bill_account1] FOREIGN KEY([customer_id])
REFERENCES [dbo].[account] ([account_id])
GO
ALTER TABLE [dbo].[bill] CHECK CONSTRAINT [FK_bill_account1]
GO
ALTER TABLE [dbo].[bill]  WITH CHECK ADD  CONSTRAINT [FK_bill_order_status] FOREIGN KEY([order_status_id])
REFERENCES [dbo].[order_status] ([order_status_id])
GO
ALTER TABLE [dbo].[bill] CHECK CONSTRAINT [FK_bill_order_status]
GO
ALTER TABLE [dbo].[bill]  WITH CHECK ADD  CONSTRAINT [FK_bill_order_type] FOREIGN KEY([order_type_id])
REFERENCES [dbo].[order_type] ([order_type_id])
GO
ALTER TABLE [dbo].[bill] CHECK CONSTRAINT [FK_bill_order_type]
GO
ALTER TABLE [dbo].[bill_detail]  WITH CHECK ADD  CONSTRAINT [FK_bill_detail_bill] FOREIGN KEY([bill_id])
REFERENCES [dbo].[bill] ([bill_id])
GO
ALTER TABLE [dbo].[bill_detail] CHECK CONSTRAINT [FK_bill_detail_bill]
GO
ALTER TABLE [dbo].[bill_detail]  WITH CHECK ADD  CONSTRAINT [FK_bill_detail_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[bill_detail] CHECK CONSTRAINT [FK_bill_detail_product]
GO
ALTER TABLE [dbo].[build_pc]  WITH CHECK ADD  CONSTRAINT [FK_build_pc_account] FOREIGN KEY([customer_id])
REFERENCES [dbo].[account] ([account_id])
GO
ALTER TABLE [dbo].[build_pc] CHECK CONSTRAINT [FK_build_pc_account]
GO
ALTER TABLE [dbo].[build_pc]  WITH CHECK ADD  CONSTRAINT [FK_build_pc_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[build_pc] CHECK CONSTRAINT [FK_build_pc_product]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_account] FOREIGN KEY([customer_id])
REFERENCES [dbo].[account] ([account_id])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_account]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_product]
GO
ALTER TABLE [dbo].[coupon]  WITH CHECK ADD  CONSTRAINT [FK_coupon_account] FOREIGN KEY([employee_id])
REFERENCES [dbo].[account] ([account_id])
GO
ALTER TABLE [dbo].[coupon] CHECK CONSTRAINT [FK_coupon_account]
GO
ALTER TABLE [dbo].[coupon]  WITH CHECK ADD  CONSTRAINT [FK_coupon_supplier] FOREIGN KEY([supplier_id])
REFERENCES [dbo].[supplier] ([supplier_id])
GO
ALTER TABLE [dbo].[coupon] CHECK CONSTRAINT [FK_coupon_supplier]
GO
ALTER TABLE [dbo].[coupon_detail]  WITH CHECK ADD  CONSTRAINT [FK_coupon_detail_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[coupon_detail] CHECK CONSTRAINT [FK_coupon_detail_product]
GO
ALTER TABLE [dbo].[product]  WITH CHECK ADD  CONSTRAINT [FK_product_product_type] FOREIGN KEY([prorduct_type_id])
REFERENCES [dbo].[product_type] ([product_type_id])
GO
ALTER TABLE [dbo].[product] CHECK CONSTRAINT [FK_product_product_type]
GO
ALTER TABLE [dbo].[product]  WITH CHECK ADD  CONSTRAINT [FK_product_trademark] FOREIGN KEY([trademark_id])
REFERENCES [dbo].[trademark] ([trademark_id])
GO
ALTER TABLE [dbo].[product] CHECK CONSTRAINT [FK_product_trademark]
GO
ALTER TABLE [dbo].[product_image]  WITH CHECK ADD  CONSTRAINT [FK_product_image_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[product_image] CHECK CONSTRAINT [FK_product_image_product]
GO
ALTER TABLE [dbo].[product_promotion]  WITH CHECK ADD  CONSTRAINT [FK_product_promotion_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[product_promotion] CHECK CONSTRAINT [FK_product_promotion_product]
GO
ALTER TABLE [dbo].[product_promotion]  WITH CHECK ADD  CONSTRAINT [FK_product_promotion_promotion_date] FOREIGN KEY([promotion_date_id])
REFERENCES [dbo].[promotion_date] ([promotion_date_id])
GO
ALTER TABLE [dbo].[product_promotion] CHECK CONSTRAINT [FK_product_promotion_promotion_date]
GO
ALTER TABLE [dbo].[voucher]  WITH CHECK ADD  CONSTRAINT [FK_voucher_account] FOREIGN KEY([customer_id])
REFERENCES [dbo].[account] ([account_id])
GO
ALTER TABLE [dbo].[voucher] CHECK CONSTRAINT [FK_voucher_account]
GO
USE [master]
GO
ALTER DATABASE [QuayLyBanMayTinhVaLinhKienMayTinh] SET  READ_WRITE 
GO
