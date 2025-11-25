/*
 * HE QUAN TRI CO SO DU LIEU: Microsoft SQL Server 2019 (hoac cao hon)
 * 
 * HUONG DAN CHAY SCRIPT:
 * 1. Mo SQL Server Management Studio (SSMS)
 * 2. Ket noi voi SQL Server Instance (vi du: .\SQLEXPRESS)
 * 3. Mo file nay va chay toan bo script (F5)
 * 4. Script se tu dong tao database StudentManagement voi du lieu mau day du
 */

USE master
GO

-- Xoa database neu da ton tai
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'StudentManagement')
BEGIN
    ALTER DATABASE [StudentManagement] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [StudentManagement];
END
GO

-- Tao database moi
CREATE DATABASE [StudentManagement]
GO

USE [StudentManagement]
GO

-- TAO CAC BANG

CREATE TABLE OTP
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Code NVARCHAR(MAX),
    Time DATETIME DEFAULT GETDATE()
)
GO

CREATE TABLE UserRole
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Role NVARCHAR(MAX)
)
GO

CREATE TABLE DatabaseImageTable
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Image NVARCHAR(MAX)
)
GO

CREATE TABLE Users
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Username NVARCHAR(MAX),
    Password NVARCHAR(MAX),
    DisplayName NVARCHAR(MAX),
    Email NVARCHAR(MAX),
    IdOTP UNIQUEIDENTIFIER,
    Online BIT DEFAULT 0,
    IdUserRole UNIQUEIDENTIFIER NULL,
    IdAvatar UNIQUEIDENTIFIER NULL,
    FOREIGN KEY (IdAvatar) REFERENCES DatabaseImageTable(Id),
    FOREIGN KEY (IdUserRole) REFERENCES UserRole(Id),
    FOREIGN KEY (IdOTP) REFERENCES OTP(Id)
)
GO

CREATE TABLE UserRole_UserInfo
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdRole UNIQUEIDENTIFIER NULL,
    InfoName NVARCHAR(MAX) NOT NULL,
    Type INT,
    IsEnable BIT,
    IsDeleted BIT,
    FOREIGN KEY (IdRole) REFERENCES UserRole(Id)
)
GO

CREATE TABLE User_UserRole_UserInfo
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdUser UNIQUEIDENTIFIER NULL,
    IdUserRole_Info UNIQUEIDENTIFIER NULL,
    Content NVARCHAR(MAX),
    FOREIGN KEY (IdUser) REFERENCES Users(Id),
    FOREIGN KEY (IdUserRole_Info) REFERENCES UserRole_UserInfo(Id)
)
GO

CREATE TABLE UserRole_UserInfoItem
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdUserRole_Info UNIQUEIDENTIFIER NULL,
    Content NVARCHAR(MAX),
    FOREIGN KEY (IdUserRole_Info) REFERENCES UserRole_UserInfo(Id)
)
GO

CREATE TABLE Faculty
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    DisplayName NVARCHAR(MAX),
    IsDeleted BIT DEFAULT 0,
    FoundationDay DateTime
)
GO

CREATE TABLE TrainingForm
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    DisplayName NVARCHAR(MAX),
    IsDeleted BIT DEFAULT 0
)
GO

CREATE TABLE Faculty_TrainingForm
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdTrainingForm UNIQUEIDENTIFIER NULL,
    IdFaculty UNIQUEIDENTIFIER NULL,
    IsDeleted BIT DEFAULT 0,
    FOREIGN KEY(IdTrainingForm) REFERENCES TrainingForm(Id),
    FOREIGN KEY(IdFaculty) REFERENCES Faculty(Id)
)
GO

CREATE TABLE Student
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdTrainingForm UNIQUEIDENTIFIER NULL,
    IdFaculty UNIQUEIDENTIFIER NULL,
    Status INT DEFAULT 1,
    IdUsers UNIQUEIDENTIFIER,
    FOREIGN KEY(IdTrainingForm) REFERENCES TrainingForm(Id),
    FOREIGN KEY(IdUsers) REFERENCES Users(Id),
    FOREIGN KEY (IdFaculty) REFERENCES Faculty(Id)
)
GO

CREATE TABLE Teacher
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdFaculty UNIQUEIDENTIFIER NULL,
    IdUsers UNIQUEIDENTIFIER,
    FOREIGN KEY(IdUsers) REFERENCES Users(Id),
    FOREIGN KEY (IdFaculty) REFERENCES Faculty(Id)
)
GO

CREATE TABLE Admin
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdUsers UNIQUEIDENTIFIER,
    FOREIGN KEY(IdUsers) REFERENCES Users(Id)
)
GO

CREATE TABLE Class
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdTrainingForm UNIQUEIDENTIFIER NULL,
    IdFaculty UNIQUEIDENTIFIER NULL,
    DisplayName NVARCHAR(MAX),
    IdTeacher UNIQUEIDENTIFIER NULL,
    IsDeleted BIT DEFAULT 0,
    IdThumbnail UNIQUEIDENTIFIER NULL,
    FOREIGN KEY(IdTrainingForm) REFERENCES TrainingForm(Id),
    FOREIGN KEY(IdFaculty) REFERENCES Faculty(Id),
    FOREIGN KEY(IdTeacher) REFERENCES Teacher(Id),
    FOREIGN KEY(IdThumbnail) REFERENCES DatabaseImageTable(Id)
)
GO

CREATE TABLE Subject
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Credit INT,
    DisplayName NVARCHAR(MAX),
    Code NVARCHAR(MAX),
    Describe NVARCHAR(MAX),
    IsDeleted BIT DEFAULT 0
)
GO

CREATE TABLE Semester
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Batch NVARCHAR(MAX),
    DisplayName NVARCHAR(MAX),
    CourseRegisterStatus INT DEFAULT 0
)
GO

CREATE TABLE SubjectClass
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdSubject UNIQUEIDENTIFIER NULL,
    StartDate DateTime NULL,
    EndDate DateTime NULL,
    IdSemester UNIQUEIDENTIFIER NULL,
    Period NVARCHAR(MAX) NULL,
    WeekDay INT NULL,
    IdThumbnail UNIQUEIDENTIFIER NULL,
    IdTrainingForm UNIQUEIDENTIFIER NULL,
    Code NVARCHAR(MAX) NOT NULL,
    NumberOfStudents INT NOT NULL DEFAULT 0,
    MaxNumberOfStudents INT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (IdSubject) REFERENCES Subject(Id),
    FOREIGN KEY (IdSemester) REFERENCES Semester(Id),
    FOREIGN KEY(IdThumbnail) REFERENCES DatabaseImageTable(Id),
    FOREIGN KEY (IdTrainingForm) REFERENCES TrainingForm(Id)
)
GO

CREATE TABLE ComponentScore
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdSubjectClass UNIQUEIDENTIFIER NULL,
    DisplayName NVARCHAR(MAX),
    ContributePercent FLOAT,
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id)
)
GO

CREATE TABLE DetailScore
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdStudent UNIQUEIDENTIFIER NULL,
    IdComponentScore UNIQUEIDENTIFIER NULL,
    Score FLOAT,
    FOREIGN KEY (IdStudent) REFERENCES Student(Id),
    FOREIGN KEY (IdComponentScore) REFERENCES ComponentScore(Id)
)
GO

CREATE TABLE Examination
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdSubjectClass UNIQUEIDENTIFIER,
    ExamName NVARCHAR(MAX),
    WeekDay NVARCHAR(MAX) NOT NULL,
    Period NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id)
)
GO

CREATE TABLE Teacher_SubjectClass
(
    IdSubjectClass UNIQUEIDENTIFIER,
    IdTeacher UNIQUEIDENTIFIER,
    PRIMARY KEY (IdSubjectClass, IdTeacher),
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id),
    FOREIGN KEY (IdTeacher) REFERENCES Teacher(Id)
)
GO

CREATE TABLE CourseRegister
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Status INT DEFAULT 0,
    IdStudent UNIQUEIDENTIFIER NULL,
    IdSubjectClass UNIQUEIDENTIFIER NULL,
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id),
    FOREIGN KEY (IdStudent) REFERENCES Student(Id)
)
GO

CREATE TABLE TrainingScore
(
    Id UNIQUEIDENTIFIER PRIMARY KEY,
    Score FLOAT DEFAULT 0,
    IdSemester UNIQUEIDENTIFIER NULL,
    IdStudent UNIQUEIDENTIFIER NULL,
    FOREIGN KEY (IdStudent) REFERENCES Student(Id),
    FOREIGN KEY (IdSemester) REFERENCES Semester(Id)
)
GO

CREATE TABLE Folder
(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    DisplayName NVARCHAR(MAX),
    CreatedAt DateTime,
    IdSubjectClass UNIQUEIDENTIFIER NULL,
    IdPoster UNIQUEIDENTIFIER DEFAULT NEWID(),
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id),
    FOREIGN KEY (IdPoster) REFERENCES Users(Id)
)
GO

CREATE TABLE Document
(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    DisplayName NVARCHAR(MAX),
    Content NVARCHAR(MAX),
    CreatedAt DateTime,
    IdPoster UNIQUEIDENTIFIER NULL,
    IdFolder UNIQUEIDENTIFIER,
    IdSubjectClass UNIQUEIDENTIFIER NULL,
    Size BIGINT,
    FOREIGN KEY (IdPoster) REFERENCES Users(Id),
    FOREIGN KEY (IdFolder) REFERENCES Folder(Id),
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id)
)
GO

CREATE TABLE AbsentCalendar
(
    Id UNIQUEIDENTIFIER PRIMARY KEY,
    IdSubjectClass UNIQUEIDENTIFIER NULL,
    Period NVARCHAR(MAX) NULL,
    Date DateTime,
    Type INT,
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id)
)
GO

CREATE TABLE NotificationType
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Content NVARCHAR(MAX)
)
GO

CREATE TABLE Notification
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Topic NVARCHAR(MAX),
    Content NVARCHAR(MAX),
    Time DateTime,
    IdNotificationType UNIQUEIDENTIFIER,
    IdPoster UNIQUEIDENTIFIER NULL,
    IdSubjectClass UNIQUEIDENTIFIER,
    FOREIGN KEY (IdPoster) REFERENCES Users(Id),
    FOREIGN KEY (IdSubjectClass) REFERENCES SubjectClass(Id),
    FOREIGN KEY (IdNotificationType) REFERENCES NotificationType(Id)
)
GO

CREATE TABLE NotificationInfo
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdNotification UNIQUEIDENTIFIER NULL,
    IdUserReceiver UNIQUEIDENTIFIER NULL,
    IsRead BIT DEFAULT 0,
    FOREIGN KEY (IdNotification) REFERENCES Notification(Id),
    FOREIGN KEY (IdUserReceiver) REFERENCES Users(Id)
)
GO

CREATE TABLE NotificationComment
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdUserComment UNIQUEIDENTIFIER NULL,
    IdNotification UNIQUEIDENTIFIER NULL,
    Content NVARCHAR(MAX),
    Time DateTime,
    FOREIGN KEY (IdUserComment) REFERENCES Users(Id),
    FOREIGN KEY (IdNotification) REFERENCES Notification(Id)
)
GO

CREATE TABLE NotificationImages
(
    Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    IdNotification UNIQUEIDENTIFIER NULL,
    IdDatabaseImageTable UNIQUEIDENTIFIER NULL,
    FOREIGN KEY (IdNotification) REFERENCES Notification(Id),
    FOREIGN KEY (IdDatabaseImageTable) REFERENCES DatabaseImageTable(Id)
)
GO

-- TAO TRIGGER

CREATE TRIGGER UTG_CountNumberOfStudentsInClass
ON dbo.CourseRegister
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @NumberOfStudentsInClass INT
    DECLARE @MaxNumberOfStudentsInClass INT
    
    SET @NumberOfStudentsInClass = (
        SELECT NumberOfStudents 
        FROM SubjectClass AS a 
        WHERE Id IN (
            SELECT IdSubjectClass FROM DELETED 
            UNION  
            SELECT IdSubjectClass FROM INSERTED 
        )
    )

    SET @MaxNumberOfStudentsInClass = (
        SELECT MaxNumberOfStudents 
        FROM SubjectClass 
        WHERE Id IN (
            SELECT IdSubjectClass FROM DELETED 
            UNION  
            SELECT IdSubjectClass FROM INSERTED 
        )
    )

    IF (@MaxNumberOfStudentsInClass <= @NumberOfStudentsInClass)
    BEGIN 
        RAISERROR('SubjectClass is full', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        UPDATE b 
        SET NumberOfStudents = 1 + NumberOfStudents 
        FROM dbo.SubjectClass AS b 
        WHERE Id IN (SELECT IdSubjectClass FROM INSERTED)
        
        UPDATE b 
        SET NumberOfStudents = NumberOfStudents - 1 
        FROM dbo.SubjectClass AS b 
        WHERE Id IN (SELECT IdSubjectClass FROM DELETED)
    END
END
GO

-- CHEN DU LIEU MAU

-- Insert UserRole
INSERT INTO dbo.UserRole (Role)
VALUES 
    (N'Sinh viên'),
    (N'Giảng viên'),
    (N'Admin')
GO

-- Insert NotificationType
INSERT INTO dbo.NotificationType (Content)
VALUES 
    (N'Thông báo chung'),
    (N'Thông báo sinh viên'),
    (N'Thông báo Giảng viên'),
    (N'Thông báo Admin'),
    (N'Thông báo nghỉ bù'),
    (N'Thông báo bình luận')
GO

-- Insert DatabaseImageTable
INSERT INTO DatabaseImageTable (Image)
VALUES 
    (N'https://tuoitre.uit.edu.vn/wp-content/uploads/2015/07/logo-uit.png'),
    (N'https://i.imgur.com/avatar1.png'),
    (N'https://i.imgur.com/avatar2.png'),
    (N'https://i.imgur.com/avatar3.png'),
    (N'https://i.imgur.com/avatar4.png'),
    (N'https://i.imgur.com/avatar5.png')
GO

-- Insert Faculty
INSERT INTO Faculty (DisplayName, FoundationDay)
VALUES 
    (N'Khoa Công nghệ Phần mềm', '2000-09-01'),
    (N'Khoa Hệ thống Thông tin', '2000-09-01'),
    (N'Khoa Khoa học Máy tính', '2000-09-01'),
    (N'Khoa Mạng máy tính và Truyền thông', '2001-09-01'),
    (N'Khoa Kỹ thuật Máy tính', '2001-09-01')
GO

-- Insert TrainingForm
INSERT INTO TrainingForm (DisplayName)
VALUES 
    (N'Đại học chính quy'),
    (N'Đại học chất lượng cao'),
    (N'Liên thông'),
    (N'Văn bằng 2')
GO

-- Insert Faculty_TrainingForm
DECLARE @IdSE UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Công nghệ Phần mềm')
DECLARE @IdIS UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Hệ thống Thông tin')
DECLARE @IdCS UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Khoa học Máy tính')
DECLARE @IdNW UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Mạng máy tính và Truyền thông')
DECLARE @IdCE UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Kỹ thuật Máy tính')

DECLARE @IdDHCQ UNIQUEIDENTIFIER = (SELECT Id FROM TrainingForm WHERE DisplayName = N'Đại học chính quy')
DECLARE @IdDHCLC UNIQUEIDENTIFIER = (SELECT Id FROM TrainingForm WHERE DisplayName = N'Đại học chất lượng cao')

INSERT INTO Faculty_TrainingForm (IdFaculty, IdTrainingForm)
VALUES 
    (@IdSE, @IdDHCQ),
    (@IdSE, @IdDHCLC),
    (@IdIS, @IdDHCQ),
    (@IdIS, @IdDHCLC),
    (@IdCS, @IdDHCQ),
    (@IdCS, @IdDHCLC),
    (@IdNW, @IdDHCQ),
    (@IdCE, @IdDHCQ)
GO

-- Insert Semester
INSERT INTO Semester (Batch, DisplayName, CourseRegisterStatus)
VALUES 
    (N'2021', N'Học kỳ 1 năm học 2021-2022', 1),
    (N'2021', N'Học kỳ 2 năm học 2021-2022', 1),
    (N'2022', N'Học kỳ 1 năm học 2022-2023', 1),
    (N'2022', N'Học kỳ 2 năm học 2022-2023', 1),
    (N'2023', N'Học kỳ 1 năm học 2023-2024', 1),
    (N'2023', N'Học kỳ 2 năm học 2023-2024', 1)
GO

-- Insert Subject
INSERT INTO Subject (Code, DisplayName, Credit, Describe)
VALUES 
    (N'IT001', N'Nhập môn lập trình', 4, N'Học các khái niệm cơ bản về lập trình'),
    (N'IT002', N'Lập trình hướng đối tượng', 4, N'Học lập trình hướng đối tượng với C++'),
    (N'IT003', N'Cấu trúc dữ liệu và Giải thuật', 4, N'Học các cấu trúc dữ liệu cơ bản và giải thuật'),
    (N'IT004', N'Cơ sở dữ liệu', 4, N'Học thiết kế và quản trị cơ sở dữ liệu'),
    (N'IT005', N'Mạng máy tính', 4, N'Học các khái niệm cơ bản về mạng máy tính'),
    (N'IT006', N'Kiến trúc máy tính', 4, N'Học kiến trúc và tổ chức máy tính'),
    (N'IT007', N'Hệ điều hành', 4, N'Học các khái niệm về hệ điều hành'),
    (N'IT008', N'Công nghệ phần mềm', 4, N'Học quy trình phát triển phần mềm'),
    (N'IT009', N'Trí tuệ nhân tạo', 4, N'Học các khái niệm cơ bản về AI'),
    (N'IT010', N'Phát triển ứng dụng Web', 4, N'Học phát triển ứng dụng Web'),
    (N'IT011', N'Phát triển ứng dụng di động', 4, N'Học phát triển ứng dụng mobile'),
    (N'IT012', N'An toàn và bảo mật thông tin', 4, N'Học các khái niệm về bảo mật')
GO

-- Insert Admin account (username: admin, password: admin - SHA256 hashed)
DECLARE @IdRoleAdmin UNIQUEIDENTIFIER = (SELECT Id FROM UserRole WHERE Role = 'Admin')
DECLARE @IdAvatar1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM DatabaseImageTable)

INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES 
    ('29DF1714-C81F-42C2-8C64-6D744D787E0C', 'admin', N'Quản Trị Viên', 'admin@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleAdmin, @IdAvatar1, 0)

INSERT INTO Admin (IdUsers)
VALUES ('29DF1714-C81F-42C2-8C64-6D744D787E0C')
GO

-- Insert Teacher accounts
DECLARE @IdRoleTeacher UNIQUEIDENTIFIER = (SELECT Id FROM UserRole WHERE Role = N'Giảng viên')
DECLARE @IdFacultySE UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Công nghệ Phần mềm')
DECLARE @IdFacultyIS UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Hệ thống Thông tin')
DECLARE @IdFacultyCS UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Khoa học Máy tính')

DECLARE @IdAvatarBase UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM DatabaseImageTable WHERE Image LIKE '%avatar%')

-- Teacher 1
DECLARE @IdUser1 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdUser1, 'teacher01', N'Nguyễn Văn An', 'teacher01@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleTeacher, @IdAvatarBase, 0)
INSERT INTO Teacher (IdUsers, IdFaculty) VALUES (@IdUser1, @IdFacultySE)

-- Teacher 2
DECLARE @IdUser2 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdUser2, 'teacher02', N'Trần Thị Bình', 'teacher02@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleTeacher, @IdAvatarBase, 0)
INSERT INTO Teacher (IdUsers, IdFaculty) VALUES (@IdUser2, @IdFacultySE)

-- Teacher 3
DECLARE @IdUser3 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdUser3, 'teacher03', N'Lê Văn Cường', 'teacher03@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleTeacher, @IdAvatarBase, 0)
INSERT INTO Teacher (IdUsers, IdFaculty) VALUES (@IdUser3, @IdFacultyIS)

-- Teacher 4
DECLARE @IdUser4 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdUser4, 'teacher04', N'Phạm Thị Dung', 'teacher04@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleTeacher, @IdAvatarBase, 0)
INSERT INTO Teacher (IdUsers, IdFaculty) VALUES (@IdUser4, @IdFacultyIS)

-- Teacher 5
DECLARE @IdUser5 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdUser5, 'teacher05', N'Hoàng Văn Em', 'teacher05@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleTeacher, @IdAvatarBase, 0)
INSERT INTO Teacher (IdUsers, IdFaculty) VALUES (@IdUser5, @IdFacultyCS)

-- Teacher 6
DECLARE @IdUser6 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdUser6, 'teacher06', N'Đỗ Thị Giang', 'teacher06@gmail.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleTeacher, @IdAvatarBase, 0)
INSERT INTO Teacher (IdUsers, IdFaculty) VALUES (@IdUser6, @IdFacultyCS)
GO

-- Insert Student accounts
DECLARE @IdRoleStudent UNIQUEIDENTIFIER = (SELECT Id FROM UserRole WHERE Role = N'Sinh viên')
DECLARE @IdFacSE UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Công nghệ Phần mềm')
DECLARE @IdFacIS UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Hệ thống Thông tin')
DECLARE @IdFacCS UNIQUEIDENTIFIER = (SELECT Id FROM Faculty WHERE DisplayName = N'Khoa Khoa học Máy tính')
DECLARE @IdTFDHCQ UNIQUEIDENTIFIER = (SELECT Id FROM TrainingForm WHERE DisplayName = N'Đại học chính quy')
DECLARE @IdTFDHCLC UNIQUEIDENTIFIER = (SELECT Id FROM TrainingForm WHERE DisplayName = N'Đại học chất lượng cao')
DECLARE @IdAvt UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM DatabaseImageTable WHERE Image LIKE '%avatar%')

-- Student 1
DECLARE @IdStu1 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu1, '3121411078', N'Trịnh Việt Hoàng', '3121411078@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu1, @IdFacSE, @IdTFDHCQ, 1)

-- Student 2
DECLARE @IdStu2 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu2, '3121411222', N'Yên Bùi Thái Tuấn', '3121411222@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu2, @IdFacSE, @IdTFDHCQ, 1)

-- Student 3
DECLARE @IdStu3 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu3, '3121411150', N'Nguyễn Thị Thảo Nguyên', '3121411150@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu3, @IdFacSE, @IdTFDHCQ, 1)

-- Student 4-20 (Thêm nhiều sinh viên để test)
DECLARE @IdStu4 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu4, '3121410001', N'Nguyễn Văn Hùng', '3121410001@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu4, @IdFacSE, @IdTFDHCQ, 1)

DECLARE @IdStu5 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu5, '3121410002', N'Trần Thị Kim', '3121410002@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu5, @IdFacSE, @IdTFDHCQ, 1)

DECLARE @IdStu6 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu6, '3121410003', N'Lê Văn Long', '3121410003@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu6, @IdFacIS, @IdTFDHCQ, 1)

DECLARE @IdStu7 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu7, '3121410004', N'Phạm Thị Mai', '3121410004@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu7, @IdFacIS, @IdTFDHCQ, 1)

DECLARE @IdStu8 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu8, '3121410005', N'Hoàng Văn Nam', '3121410005@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu8, @IdFacCS, @IdTFDHCQ, 1)

DECLARE @IdStu9 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu9, '3121410006', N'Đỗ Thị Oanh', '3121410006@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu9, @IdFacCS, @IdTFDHCQ, 1)

DECLARE @IdStu10 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu10, '3121410007', N'Vũ Văn Phong', '3121410007@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu10, @IdFacSE, @IdTFDHCLC, 1)

DECLARE @IdStu11 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu11, '3121410008', N'Bùi Thị Quỳnh', '3121410008@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu11, @IdFacSE, @IdTFDHCLC, 1)

DECLARE @IdStu12 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu12, '3121410009', N'Ngô Văn Sang', '3121410009@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu12, @IdFacIS, @IdTFDHCLC, 1)

DECLARE @IdStu13 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu13, '3121410010', N'Đinh Thị Tâm', '3121410010@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu13, @IdFacIS, @IdTFDHCLC, 1)

DECLARE @IdStu14 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu14, '3121410011', N'Lý Văn Tuấn', '3121410011@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu14, @IdFacCS, @IdTFDHCLC, 1)

DECLARE @IdStu15 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Users (Id, Username, DisplayName, Email, Password, IdUserRole, IdAvatar, Online)
VALUES (@IdStu15, '3121410012', N'Hồ Thị Uyên', '3121410012@student.uit.edu.vn', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', @IdRoleStudent, @IdAvt, 0)
INSERT INTO Student (IdUsers, IdFaculty, IdTrainingForm, Status) VALUES (@IdStu15, @IdFacCS, @IdTFDHCLC, 1)
GO

-- Insert SubjectClass
DECLARE @IdSem1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Semester WHERE DisplayName = N'Học kỳ 1 năm học 2023-2024')
DECLARE @IdSubj1 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT001')
DECLARE @IdSubj2 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT002')
DECLARE @IdSubj3 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT003')
DECLARE @IdSubj4 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT004')
DECLARE @IdSubj5 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT008')
DECLARE @IdTForm1 UNIQUEIDENTIFIER = (SELECT Id FROM TrainingForm WHERE DisplayName = N'Đại học chính quy')

DECLARE @IdTeach1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Teacher WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = 'teacher01'))
DECLARE @IdTeach2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Teacher WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = 'teacher02'))
DECLARE @IdTeach3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Teacher WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = 'teacher03'))

-- SubjectClass 1
DECLARE @IdSubjClass1 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass1, @IdSubj1, @IdSem1, @IdTForm1, N'IT001.N01', '2023-09-01', '2023-12-15', N'1-3', 2, 50, 0)

INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach1, @IdSubjClass1)

-- SubjectClass 2
DECLARE @IdSubjClass2 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass2, @IdSubj2, @IdSem1, @IdTForm1, N'IT002.N01', '2023-09-01', '2023-12-15', N'4-6', 3, 50, 0)

INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach1, @IdSubjClass2)

-- SubjectClass 3
DECLARE @IdSubjClass3 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass3, @IdSubj3, @IdSem1, @IdTForm1, N'IT003.N01', '2023-09-01', '2023-12-15', N'7-9', 4, 50, 0)

INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach2, @IdSubjClass3)

-- SubjectClass 4
DECLARE @IdSubjClass4 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass4, @IdSubj4, @IdSem1, @IdTForm1, N'IT004.N01', '2023-09-01', '2023-12-15', N'1-3', 5, 50, 0)

INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach3, @IdSubjClass4)

-- SubjectClass 5
DECLARE @IdSubjClass5 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass5, @IdSubj5, @IdSem1, @IdTForm1, N'IT008.N01', '2023-09-01', '2023-12-15', N'4-6', 6, 50, 0)

INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach2, @IdSubjClass5)

-- SubjectClass 6-10 (Thêm lớp môn học đa dạng hơn)
DECLARE @IdSubj6 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT005')
DECLARE @IdSubj7 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT006')
DECLARE @IdSubj8 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT007')
DECLARE @IdSubj9 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT009')
DECLARE @IdSubj10 UNIQUEIDENTIFIER = (SELECT Id FROM Subject WHERE Code = N'IT010')

DECLARE @IdTeach4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Teacher WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = 'teacher04'))
DECLARE @IdTeach5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Teacher WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = 'teacher05'))
DECLARE @IdTeach6 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Teacher WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = 'teacher06'))

DECLARE @IdSubjClass6 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass6, @IdSubj6, @IdSem1, @IdTForm1, N'IT005.N01', '2023-09-01', '2023-12-15', N'7-9', 2, 45, 0)
INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach3, @IdSubjClass6)

DECLARE @IdSubjClass7 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass7, @IdSubj7, @IdSem1, @IdTForm1, N'IT006.N01', '2023-09-01', '2023-12-15', N'10-12', 3, 40, 0)
INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach4, @IdSubjClass7)

DECLARE @IdSubjClass8 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass8, @IdSubj8, @IdSem1, @IdTForm1, N'IT007.N01', '2023-09-01', '2023-12-15', N'1-3', 4, 45, 0)
INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach5, @IdSubjClass8)

DECLARE @IdSubjClass9 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass9, @IdSubj9, @IdSem1, @IdTForm1, N'IT009.N01', '2023-09-01', '2023-12-15', N'4-6', 5, 35, 0)
INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach6, @IdSubjClass9)

DECLARE @IdSubjClass10 UNIQUEIDENTIFIER = NEWID()
INSERT INTO SubjectClass (Id, IdSubject, IdSemester, IdTrainingForm, Code, StartDate, EndDate, Period, WeekDay, MaxNumberOfStudents, NumberOfStudents)
VALUES (@IdSubjClass10, @IdSubj10, @IdSem1, @IdTForm1, N'IT010.N01', '2023-09-01', '2023-12-15', N'7-9', 6, 40, 0)
INSERT INTO Teacher_SubjectClass (IdTeacher, IdSubjectClass) VALUES (@IdTeach1, @IdSubjClass10)
GO

-- Insert CourseRegister (Đăng ký môn học)
DECLARE @StdId1 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411078'))
DECLARE @StdId2 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411222'))
DECLARE @StdId3 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411150'))
DECLARE @StdId4 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410001'))
DECLARE @StdId5 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410002'))
DECLARE @StdId6 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410003'))

DECLARE @SubjClsId1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT001.N01')
DECLARE @SubjClsId2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT002.N01')
DECLARE @SubjClsId3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT003.N01')
DECLARE @SubjClsId4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT004.N01')

-- Student 1 đăng ký 3 môn
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId1, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId1, @SubjClsId2, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId1, @SubjClsId3, 1)

-- Student 2 đăng ký 4 môn
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId2, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId2, @SubjClsId2, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId2, @SubjClsId3, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId2, @SubjClsId4, 1)

-- Student 3 đăng ký 3 môn
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId3, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId3, @SubjClsId2, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId3, @SubjClsId4, 1)

-- Student 4-6 đăng ký các môn
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId4, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId4, @SubjClsId3, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId5, @SubjClsId2, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId5, @SubjClsId4, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId6, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId6, @SubjClsId2, 1)

-- Thêm đăng ký cho các sinh viên khác
DECLARE @StdId7 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410004'))
DECLARE @StdId8 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410005'))
DECLARE @StdId9 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410006'))
DECLARE @StdId10 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410007'))

DECLARE @SubjClsId5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT008.N01')
DECLARE @SubjClsId6 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT005.N01')
DECLARE @SubjClsId7 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT006.N01')

INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId7, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId7, @SubjClsId5, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId7, @SubjClsId6, 1)

INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId8, @SubjClsId2, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId8, @SubjClsId3, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId8, @SubjClsId7, 1)

INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId9, @SubjClsId1, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId9, @SubjClsId4, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId9, @SubjClsId5, 1)

INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId10, @SubjClsId2, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId10, @SubjClsId6, 1)
INSERT INTO CourseRegister (IdStudent, IdSubjectClass, Status) VALUES (@StdId10, @SubjClsId7, 1)
GO

-- Insert ComponentScore (Các thành phần điểm)
DECLARE @SCId1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT001.N01')
DECLARE @SCId2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT002.N01')
DECLARE @SCId3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT003.N01')

-- Môn IT001
DECLARE @CompId1 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId1, @SCId1, N'Điểm chuyên cần', 0.1)
DECLARE @CompId2 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId2, @SCId1, N'Điểm giữa kỳ', 0.3)
DECLARE @CompId3 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId3, @SCId1, N'Điểm cuối kỳ', 0.6)

-- Môn IT002
DECLARE @CompId4 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId4, @SCId2, N'Điểm chuyên cần', 0.1)
DECLARE @CompId5 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId5, @SCId2, N'Điểm giữa kỳ', 0.3)
DECLARE @CompId6 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId6, @SCId2, N'Điểm cuối kỳ', 0.6)

-- Môn IT003
DECLARE @CompId7 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId7, @SCId3, N'Điểm chuyên cần', 0.1)
DECLARE @CompId8 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId8, @SCId3, N'Điểm giữa kỳ', 0.3)
DECLARE @CompId9 UNIQUEIDENTIFIER = NEWID()
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (@CompId9, @SCId3, N'Điểm cuối kỳ', 0.6)

-- Thêm thành phần điểm cho các môn khác
DECLARE @SCId4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT004.N01')
DECLARE @SCId5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT008.N01')
DECLARE @SCId6 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT005.N01')

-- Môn IT004
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId4, N'Điểm chuyên cần', 0.1)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId4, N'Điểm thực hành', 0.2)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId4, N'Điểm giữa kỳ', 0.3)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId4, N'Điểm cuối kỳ', 0.4)

-- Môn IT008
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId5, N'Điểm chuyên cần', 0.1)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId5, N'Điểm đồ án', 0.4)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId5, N'Điểm cuối kỳ', 0.5)

-- Môn IT005
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId6, N'Điểm chuyên cần', 0.1)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId6, N'Điểm bài tập', 0.2)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId6, N'Điểm giữa kỳ', 0.3)
INSERT INTO ComponentScore (Id, IdSubjectClass, DisplayName, ContributePercent) VALUES (NEWID(), @SCId6, N'Điểm cuối kỳ', 0.4)
GO

-- Insert DetailScore (Điểm chi tiết của sinh viên)
DECLARE @Student1 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411078'))
DECLARE @Student2 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411222'))
DECLARE @Student3 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411150'))

DECLARE @Comp1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm chuyên cần' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT001.N01'))
DECLARE @Comp2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm giữa kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT001.N01'))
DECLARE @Comp3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm cuối kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT001.N01'))

-- Điểm sinh viên 1 - môn IT001
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp1, 9.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp2, 8.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp3, 9.0)

-- Điểm sinh viên 2 - môn IT001
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student2, @Comp1, 8.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student2, @Comp2, 7.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student2, @Comp3, 8.5)

-- Điểm sinh viên 3 - môn IT001
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student3, @Comp1, 9.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student3, @Comp2, 9.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student3, @Comp3, 9.5)

-- Thêm điểm cho các sinh viên khác và các môn khác
DECLARE @Student4 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410001'))
DECLARE @Student5 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410002'))

DECLARE @Comp4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm chuyên cần' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT002.N01'))
DECLARE @Comp5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm giữa kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT002.N01'))
DECLARE @Comp6 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm cuối kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT002.N01'))

-- Điểm sinh viên 1 - môn IT002
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp4, 8.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp5, 8.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp6, 8.5)

-- Điểm sinh viên 2 - môn IT002
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student2, @Comp4, 9.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student2, @Comp5, 8.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student2, @Comp6, 9.0)

DECLARE @Comp7 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm chuyên cần' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT003.N01'))
DECLARE @Comp8 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm giữa kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT003.N01'))
DECLARE @Comp9 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm cuối kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT003.N01'))

-- Điểm sinh viên 1 - môn IT003
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp7, 7.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp8, 8.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student1, @Comp9, 7.5)

-- Điểm sinh viên 4 - môn IT003
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student4, @Comp7, 8.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student4, @Comp8, 8.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student4, @Comp9, 8.5)

-- Điểm sinh viên 5 - môn IT004
DECLARE @Comp10 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm chuyên cần' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT004.N01'))
DECLARE @Comp11 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm thực hành' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT004.N01'))
DECLARE @Comp12 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm giữa kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT004.N01'))
DECLARE @Comp13 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ComponentScore WHERE DisplayName = N'Điểm cuối kỳ' AND IdSubjectClass IN (SELECT Id FROM SubjectClass WHERE Code = N'IT004.N01'))

INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student5, @Comp10, 9.0)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student5, @Comp11, 9.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student5, @Comp12, 8.5)
INSERT INTO DetailScore (IdStudent, IdComponentScore, Score) VALUES (@Student5, @Comp13, 9.0)
GO

-- Insert Examination (Lịch thi)
DECLARE @SubjClass1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT001.N01')
DECLARE @SubjClass2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT002.N01')
DECLARE @SubjClass3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT003.N01')
DECLARE @SubjClass4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT004.N01')
DECLARE @SubjClass5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT008.N01')
DECLARE @SubjClass6 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT005.N01')

INSERT INTO Examination (IdSubjectClass, ExamName, WeekDay, Period)
VALUES 
    (@SubjClass1, N'Thi giữa kỳ', N'Thứ 3', N'7-9'),
    (@SubjClass1, N'Thi cuối kỳ', N'Thứ 6', N'13-15'),
    (@SubjClass2, N'Thi giữa kỳ', N'Thứ 4', N'7-9'),
    (@SubjClass2, N'Thi cuối kỳ', N'Thứ 2', N'13-15'),
    (@SubjClass3, N'Thi giữa kỳ', N'Thứ 5', N'7-9'),
    (@SubjClass3, N'Thi cuối kỳ', N'Thứ 3', N'13-15'),
    (@SubjClass4, N'Thi giữa kỳ', N'Thứ 2', N'7-9'),
    (@SubjClass4, N'Thi cuối kỳ', N'Thứ 4', N'13-15'),
    (@SubjClass5, N'Thi cuối kỳ', N'Thứ 5', N'13-15'),
    (@SubjClass6, N'Thi giữa kỳ', N'Thứ 6', N'7-9'),
    (@SubjClass6, N'Thi cuối kỳ', N'Thứ 7', N'9-11')
GO

-- Insert Notification (Thông báo)
DECLARE @NotifType1 UNIQUEIDENTIFIER = (SELECT Id FROM NotificationType WHERE Content = N'Thông báo chung')
DECLARE @NotifType2 UNIQUEIDENTIFIER = (SELECT Id FROM NotificationType WHERE Content = N'Thông báo sinh viên')
DECLARE @NotifType3 UNIQUEIDENTIFIER = (SELECT Id FROM NotificationType WHERE Content = N'Thông báo Giảng viên')
DECLARE @AdminUser UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = 'admin')
DECLARE @Teacher1User UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = 'teacher01')
DECLARE @Teacher2User UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = 'teacher02')
DECLARE @SubClass1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT001.N01')
DECLARE @SubClass2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT002.N01')
DECLARE @SubClass3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT003.N01')

-- Thông báo 1
DECLARE @Notif1 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif1, N'Thông báo về lịch thi giữa kỳ', N'Lịch thi giữa kỳ môn Nhập môn lập trình sẽ được tổ chức vào thứ 3 tuần sau.', '2023-10-15 10:00:00', @NotifType2, @Teacher1User, @SubClass1)

-- Thông báo 2
DECLARE @Notif2 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif2, N'Thông báo nghỉ bù', N'Lớp sẽ nghỉ vào thứ 2 tuần này và sẽ học bù vào thứ 7.', '2023-10-16 08:00:00', @NotifType2, @Teacher1User, @SubClass1)

-- Thông báo 3
DECLARE @Notif3 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif3, N'Hướng dẫn nộp bài tập', N'Sinh viên nộp bài tập qua hệ thống trước ngày 20/10/2023.', '2023-10-10 14:00:00', @NotifType2, @Teacher1User, @SubClass1)

-- Thông báo 4-7 (Thêm thông báo đa dạng)
DECLARE @Notif4 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif4, N'Thông báo về đề tài đồ án', N'Danh sách đề tài đồ án đã được cập nhật. Sinh viên vui lòng chọn đề tài trước ngày 25/10/2023.', '2023-10-18 09:00:00', @NotifType2, @Teacher1User, @SubClass2)

DECLARE @Notif5 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif5, N'Lịch học bù', N'Lớp IT003.N01 học bù vào sáng thứ 7 tuần sau, tiết 1-3, phòng A101.', '2023-10-20 15:00:00', @NotifType2, @Teacher2User, @SubClass3)

DECLARE @Notif6 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif6, N'Thông báo điểm giữa kỳ', N'Điểm giữa kỳ đã được cập nhật. Sinh viên có thắc mắc vui lòng liên hệ giảng viên trong tuần này.', '2023-11-05 14:00:00', @NotifType2, @Teacher1User, @SubClass1)

DECLARE @Notif7 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster)
VALUES (@Notif7, N'Thông báo chung về học phí', N'Nhà trường thông báo về việc đóng học phí học kỳ 1. Hạn cuối: 30/11/2023.', '2023-11-01 08:00:00', @NotifType1, @AdminUser)

DECLARE @Notif8 UNIQUEIDENTIFIER = NEWID()
INSERT INTO Notification (Id, Topic, Content, Time, IdNotificationType, IdPoster, IdSubjectClass)
VALUES (@Notif8, N'Tài liệu ôn tập cuối kỳ', N'Tài liệu ôn tập đã được upload lên hệ thống. Sinh viên download và chuẩn bị thi cuối kỳ.', '2023-11-20 10:00:00', @NotifType2, @Teacher2User, @SubClass3)
GO

-- Insert NotificationInfo (Thông tin thông báo cho từng sinh viên)
DECLARE @Notification1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Thông báo về lịch thi giữa kỳ')
DECLARE @Notification4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Thông báo về đề tài đồ án')
DECLARE @Notification6 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Thông báo điểm giữa kỳ')
DECLARE @Notification7 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Thông báo chung về học phí')

DECLARE @Stu1 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121411078')
DECLARE @Stu2 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121411222')
DECLARE @Stu3 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121411150')
DECLARE @Stu4 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121410001')
DECLARE @Stu5 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121410002')
DECLARE @Stu6 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121410003')

INSERT INTO NotificationInfo (IdNotification, IdUserReceiver, IsRead)
VALUES 
    (@Notification1, @Stu1, 1),
    (@Notification1, @Stu2, 0),
    (@Notification1, @Stu3, 1),
    (@Notification1, @Stu4, 1),
    (@Notification1, @Stu5, 0),
    (@Notification4, @Stu1, 1),
    (@Notification4, @Stu2, 1),
    (@Notification4, @Stu3, 0),
    (@Notification6, @Stu1, 1),
    (@Notification6, @Stu2, 1),
    (@Notification6, @Stu3, 1),
    (@Notification6, @Stu4, 0),
    (@Notification7, @Stu1, 0),
    (@Notification7, @Stu2, 0),
    (@Notification7, @Stu3, 0),
    (@Notification7, @Stu4, 1),
    (@Notification7, @Stu5, 1),
    (@Notification7, @Stu6, 0)
GO

-- Insert NotificationComment (Bình luận thông báo)
DECLARE @Noti1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Thông báo về lịch thi giữa kỳ')
DECLARE @Noti4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Thông báo về đề tài đồ án')
DECLARE @Noti5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Notification WHERE Topic = N'Lịch học bù')

DECLARE @Stud1 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121411078')
DECLARE @Stud2 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121411222')
DECLARE @Stud3 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121411150')
DECLARE @Stud4 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = '3121410001')
DECLARE @Teach1 UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE Username = 'teacher01')

INSERT INTO NotificationComment (IdUserComment, IdNotification, Content, Time)
VALUES 
    (@Stud1, @Noti1, N'Em đã hiểu ạ, cảm ơn thầy!', '2023-10-15 11:00:00'),
    (@Stud2, @Noti1, N'Thầy cho em hỏi thi ở phòng nào ạ?', '2023-10-15 11:30:00'),
    (@Teach1, @Noti1, N'Phòng thi sẽ được thông báo sau, các em chú ý theo dõi nhé.', '2023-10-15 12:00:00'),
    (@Stud1, @Noti4, N'Em đã chọn đề tài số 3 ạ.', '2023-10-18 10:30:00'),
    (@Stud3, @Noti4, N'Thầy ơi, em có thể đổi đề tài không ạ?', '2023-10-18 14:00:00'),
    (@Stud4, @Noti5, N'Dạ em xin phép nghỉ buổi học bù vì có việc gia đình.', '2023-10-20 16:00:00'),
    (@Stud2, @Noti5, N'Em sẽ đến đúng giờ ạ!', '2023-10-20 16:30:00')
GO

-- Insert TrainingScore (Điểm rèn luyện)
DECLARE @Sem1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Semester WHERE DisplayName = N'Học kỳ 1 năm học 2023-2024')
DECLARE @Sem2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Semester WHERE DisplayName = N'Học kỳ 2 năm học 2022-2023')

DECLARE @Std1 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411078'))
DECLARE @Std2 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411222'))
DECLARE @Std3 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121411150'))
DECLARE @Std4 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410001'))
DECLARE @Std5 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410002'))
DECLARE @Std6 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410003'))
DECLARE @Std7 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410004'))
DECLARE @Std8 UNIQUEIDENTIFIER = (SELECT Id FROM Student WHERE IdUsers IN (SELECT Id FROM Users WHERE Username = '3121410005'))

-- Điểm rèn luyện học kỳ 1 năm 2023-2024
INSERT INTO TrainingScore (Id, Score, IdSemester, IdStudent)
VALUES 
    (NEWID(), 95, @Sem1, @Std1),
    (NEWID(), 90, @Sem1, @Std2),
    (NEWID(), 98, @Sem1, @Std3),
    (NEWID(), 85, @Sem1, @Std4),
    (NEWID(), 92, @Sem1, @Std5),
    (NEWID(), 88, @Sem1, @Std6),
    (NEWID(), 93, @Sem1, @Std7),
    (NEWID(), 87, @Sem1, @Std8)

-- Điểm rèn luyện học kỳ 2 năm 2022-2023
INSERT INTO TrainingScore (Id, Score, IdSemester, IdStudent)
VALUES 
    (NEWID(), 92, @Sem2, @Std1),
    (NEWID(), 88, @Sem2, @Std2),
    (NEWID(), 96, @Sem2, @Std3),
    (NEWID(), 83, @Sem2, @Std4),
    (NEWID(), 90, @Sem2, @Std5)
GO

-- Insert AbsentCalendar (Lịch nghỉ học)
DECLARE @SbjClass1 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT001.N01')
DECLARE @SbjClass2 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT002.N01')
DECLARE @SbjClass3 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT003.N01')
DECLARE @SbjClass4 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT004.N01')
DECLARE @SbjClass5 UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM SubjectClass WHERE Code = N'IT008.N01')

INSERT INTO AbsentCalendar (Id, IdSubjectClass, Period, Date, Type)
VALUES 
    (NEWID(), @SbjClass1, N'1-3', '2023-10-17', 1),
    (NEWID(), @SbjClass2, N'4-6', '2023-10-24', 1),
    (NEWID(), @SbjClass3, N'7-9', '2023-10-19', 1),
    (NEWID(), @SbjClass4, N'1-3', '2023-11-02', 1),
    (NEWID(), @SbjClass5, N'4-6', '2023-11-07', 1),
    (NEWID(), @SbjClass1, N'1-3', '2023-11-14', 0),
    (NEWID(), @SbjClass2, N'4-6', '2023-11-16', 0)
GO

PRINT 'HOAN THANH TAO DATABASE VA CHEN DU LIEU MAU'
PRINT ''
PRINT 'THONG TIN TAI KHOAN TEST:'
PRINT '-------------------------'
PRINT 'Admin:'
PRINT '  Username: admin'
PRINT '  Password: admin'
PRINT ''
PRINT 'Giao vien (Teacher):'
PRINT '  Username: teacher01 -> teacher06'
PRINT '  Password: admin'
PRINT ''
PRINT 'Sinh vien (Student):'
PRINT '  Username: 3121411078 (Trinh Viet Hoang)'
PRINT '  Username: 3121411222 (Yen Bui Thai Tuan)'
PRINT '  Username: 3121411150 (Nguyen Thi Thao Nguyen)'
PRINT '  Username: 3121410001 -> 3121410012 (cac sinh vien khac)'
PRINT '  Password: admin'
PRINT ''
PRINT 'Da tao:'
PRINT '- 5 Khoa (Faculty)'
PRINT '- 4 Hinh thuc dao tao (TrainingForm)'
PRINT '- 6 Hoc ky (Semester)'
PRINT '- 12 Mon hoc (Subject)'
PRINT '- 10 Lop mon hoc (SubjectClass)'
PRINT '- 1 Admin, 6 Giao vien, 15 Sinh vien'
PRINT '- 28 Dang ky mon hoc (CourseRegister)'
PRINT '- 30+ Thanh phan diem (ComponentScore)'
PRINT '- 20+ Diem chi tiet (DetailScore)'
PRINT '- 11 Lich thi (Examination)'
PRINT '- 8 Thong bao (Notification)'
PRINT '- 18 Thong tin thong bao (NotificationInfo)'
PRINT '- 7 Binh luan (NotificationComment)'
PRINT '- 13 Diem ren luyen (TrainingScore)'
PRINT '- 7 Lich nghi hoc (AbsentCalendar)'
GO
