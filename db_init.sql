
IF NOT EXISTS
   (  SELECT [name]
      FROM sys.tables
      WHERE [name] = 'DetectedLanguages'
   )
BEGIN
    CREATE TABLE DetectedLanguages (
        ID int IDENTITY(1,1) not null primary key,
        CommentID nvarchar(20) not null,
        Language nvarchar(10) not null,
        CreatedAt datetime not null
    );
END;
GO

IF NOT EXISTS
   (  SELECT [name]
      FROM sys.tables
      WHERE [name] = 'MessageSentiments'
   )
BEGIN
    CREATE TABLE MessageSentiments (
        ID int IDENTITY(1,1) not null primary key,
        CommentID nvarchar(20) not null,
        Sentiment nvarchar(10) not null,
        CreatedAt datetime not null
    );
END;
GO

IF NOT EXISTS
   (  SELECT [name]
      FROM sys.tables
      WHERE [name] = 'MessageKeywords'
   )
BEGIN
    CREATE TABLE MessageKeywords (
        ID int IDENTITY(1,1) not null primary key,
        CommentID nvarchar(20) not null,
        Keyword nvarchar(250) not null,
        CreatedAt datetime not null
    );
END;
GO