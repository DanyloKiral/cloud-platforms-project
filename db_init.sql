CREATE TABLE DetectedLanguages (
    ID int IDENTITY(1,1) not null primary key,
    CommentID nvarchar(20) not null,
    Language nvarchar(10) not null,
    DetectedAt datetime not null
);