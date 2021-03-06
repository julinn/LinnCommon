/*
  测试语句
  select * from core_NewID
  
  NewID:
  declare @i int, @s varchar(20)
  exec proc_NewID 'abc', @i out, 1, @s out, 15
  select @i, @s
  
  NewNo:
  declare @s varchar(20)
  exec proc_NewNo 'abc', @s out, '', 2
  select @s
*/
IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE name = 'core_NewID' AND type = 'U')
BEGIN
  CREATE TABLE core_NewID
  (
  	 TableName varchar(100) PRIMARY KEY,
  	 Value int DEFAULT 0,
  	 RecID int DEFAULT 0,
  	 RecDate datetime
  )	
END
GO

IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'proc_NewID' AND type = 'P')
  DROP PROC proc_NewID
GO
CREATE PROC proc_NewID
 @Table varchar(100)
,@ID int output
,@seed int = 1
,@CardNo varchar(20) = '' output
,@length int = 4
as
begin
  if not exists(select 1 from core_NewID where TableName = @Table)
    insert into core_NewID(TableName)values(@Table)
  select @ID = ISNULL(Value, 0) from core_NewID where TableName = @Table
  set @ID = ISNULL(@ID, 0) + @seed
  update core_NewID set Value = @ID where TableName = @Table
  SET @CardNo = CONVERT(varchar(20), @ID)
  IF LEN(@CardNo) < @length
    SET @CardNo = RIGHT('0000000000'+@CardNo, @length)
END
GO

IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'proc_NewNo' AND type = 'P')
  DROP PROC proc_NewNo
GO
CREATE proc proc_NewNo
 @Table varchar(100)
,@No varchar(100) output
,@prefix varchar(20) = ''
,@length int = 4
,@short int = 0
as
declare
  @RecID int,
  @NowDate datetime, @FlagDate datetime,
  @dateStr varchar(10), @Nostr varchar(20)
begin
  if @length > 9
  begin
    raiserror('最大编号长度不能超过9', 16, 1) with nowait
    return
  end  
  if not exists(select 1 from core_NewID where TableName = @Table)
    insert into core_NewID(TableName)values(@Table)
  set @NowDate = (Select CONVERT(varchar(10), GETDATE(), 121))
  select @RecID = ISNULL(RecID, 0), @FlagDate = ISNULL(RecDate, '2015-01-01 00:00:00.000') from core_NewID where TableName = @Table
  set @FlagDate = ISNULL(@FlagDate, '2015-01-01 00:00:00.000')
  if @NowDate > @FlagDate
  begin
    set @RecID = 0    
  end
  set @RecID = ISNULL(@RecID, 0) + 1
  --判断序列值是否超过长度限制的最大值
  declare @maxID int, @maxStr varchar(20)
  set @maxStr = '999999999'
  set @maxStr = SUBSTRING(@maxStr, 1, @length)
  set @maxID = CONVERT(int, @maxStr)
  if @RecID > @maxID
  begin
    raiserror('当前编号超过最大值！', 16, 1) with nowait
    return
  end
  --
  update core_NewID set RecID = @RecID, RecDate = @NowDate where TableName = @Table
  set @dateStr = (Select CONVERT(varchar(10), @NowDate, 121))
  set @dateStr = REPLACE(@dateStr, '-', '')
  if @short = 1
    set @dateStr = SUBSTRING(@dateStr, 3, 6) 
  set @Nostr = (CONVERT(varchar(20), @RecID))
  set @Nostr = RIGHT('0000000000'+@Nostr, @length)
  set @No = @prefix + @dateStr + @Nostr
end
GO