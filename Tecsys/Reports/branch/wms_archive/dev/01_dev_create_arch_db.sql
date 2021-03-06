USE [master]
GO

CREATE DATABASE [dev_94x_w_arch]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dev_94x_w_arch', FILENAME = N'E:\SQLDATA\dev_94x_w_arch.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'dev_94x_w_arch_log', FILENAME = N'F:\SQLLOGS\dev_94x_w_arch_log.ldf' , SIZE = 13312KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [dev_94x_w_arch] SET COMPATIBILITY_LEVEL = 130
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dev_94x_w_arch].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [dev_94x_w_arch] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET ARITHABORT OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [dev_94x_w_arch] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [dev_94x_w_arch] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET  DISABLE_BROKER 
GO

ALTER DATABASE [dev_94x_w_arch] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [dev_94x_w_arch] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET RECOVERY FULL 
GO

ALTER DATABASE [dev_94x_w_arch] SET  MULTI_USER 
GO

ALTER DATABASE [dev_94x_w_arch] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [dev_94x_w_arch] SET DB_CHAINING OFF 
GO

ALTER DATABASE [dev_94x_w_arch] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [dev_94x_w_arch] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [dev_94x_w_arch] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [dev_94x_w_arch] SET QUERY_STORE = OFF
GO

USE [dev_94x_w_arch]
GO

ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

ALTER DATABASE [dev_94x_w_arch] SET  READ_WRITE 
GO
