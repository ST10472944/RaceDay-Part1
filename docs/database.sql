-- =============================================
-- RaceDay Database Schema (For SQL Server / SSMS)
-- =============================================
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'RaceDay')
    DROP DATABASE RaceDay;
GO
CREATE DATABASE RaceDay;
GO
USE RaceDay;
GO

-- 1. User table
CREATE TABLE [User] (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- 2. Category
CREATE TABLE Category (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);

-- 3. Event
CREATE TABLE [Event] (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    EventDate DATE NOT NULL,
    EventTime TIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Open' CHECK (Status IN ('Open', 'Closed')),
    OrganiserId INT NOT NULL FOREIGN KEY REFERENCES [User](UserId),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- 4. EventCategory (junction)
CREATE TABLE EventCategory (
    EventCategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL FOREIGN KEY REFERENCES [Event](EventId),
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryId),
    Price DECIMAL(10,2),
    MaxParticipants INT,
    CONSTRAINT UQ_EventCategory_EventCategory UNIQUE (EventId, CategoryId)
);

-- 5. Enrolment
CREATE TABLE Enrolment (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    EventCategoryId INT NOT NULL FOREIGN KEY REFERENCES EventCategory(EventCategoryId),
    ParticipantId INT NOT NULL FOREIGN KEY REFERENCES [User](UserId),
    EnrolmentDate DATETIME2 DEFAULT GETUTCDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')),
    CONSTRAINT UQ_Enrolment_ParticipantEventCategory UNIQUE (ParticipantId, EventCategoryId)
);

-- 6. Result
CREATE TABLE [Result] (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Enrolment(EnrolmentId),
    FinishTime TIME,
    [Position] INT,
    Status NVARCHAR(20) NOT NULL DEFAULT 'DNS' CHECK (Status IN ('DNS', 'DNF', 'Finished')),
    Notes NVARCHAR(500)
);

-- =============================================
-- Seed Data (2 Organisers, 2 Participants, 3 Events)
-- =============================================
INSERT INTO [User] (Email, PasswordHash, FullName, Role)
VALUES 
('organiser1@raceday.co.za', 'hashed_pw_1', 'Thabo Mokoena', 'Organiser'),
('organiser2@raceday.co.za', 'hashed_pw_2', 'Lindiwe Nkosi', 'Organiser'),
('participant1@raceday.co.za', 'hashed_pw_3', 'Sipho Zulu', 'Participant'),
('participant2@raceday.co.za', 'hashed_pw_4', 'Mary Smith', 'Participant');

INSERT INTO Category (Name, Description)
VALUES 
('5km', '5 kilometre run/walk'),
('10km', '10 kilometre run'),
('21km', 'Half marathon (21.1 km)'),
('42km', 'Full marathon (42.2 km)');

INSERT INTO [Event] (Title, Description, EventDate, EventTime, Location, OrganiserId)
VALUES 
('Soweto Marathon', 'Annual Soweto Marathon', '2026-11-15', '06:00', 'Soweto, Johannesburg', 1),
('Cape Town Cycle Tour', 'World''s largest timed cycle race', '2026-03-08', '07:00', 'Cape Town', 2),
('Durban Park Run', 'Community 5km run', '2026-09-20', '08:00', 'Durban', 1);

INSERT INTO EventCategory (EventId, CategoryId, Price, MaxParticipants)
VALUES 
(1, 3, 150.00, 1000),
(1, 4, 200.00, 500),
(2, 1, 50.00, 2000),
(2, 2, 80.00, 1500),
(3, 1, 0.00, 300);

INSERT INTO Enrolment (EventCategoryId, ParticipantId, Status)
VALUES 
(1, 3, 'Confirmed'),
(3, 3, 'Confirmed'),
(4, 4, 'Pending'),
(5, 4, 'Confirmed');

INSERT INTO [Result] (EnrolmentId, FinishTime, Position, Status, Notes)
VALUES 
(1, '02:15:30', 45, 'Finished', 'Good pace'),
(2, '00:32:10', 120, 'Finished', 'Personal best?'),
(4, '00:28:45', 15, 'Finished', 'Top 20');
