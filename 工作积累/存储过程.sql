--定义存储过程
Create PROCEDURE proc1
AS  
DECLARE 
@proid INT
  begin try  
    begin tran 
   DECLARE youcurname CURSOR  FOR  
				SELECT pid from p_project where rdmark not in('d')  AND pid not in(
				SELECT projectid from p_application where projectid <> 0
				)
OPEN youcurname
fetch next from youcurname into @proid
while @@fetch_status<>-1
begin
--您要执行的操作写在这里

			INSERT INTO dbo.p_fxtousd (
			currency, 
			rate, 
			projectid
			)
	    SELECT 
		    currency, 
		    rate, 
		    @proid as projectid 
			FROM p_fxtousd WHERE projectid = 0;

			INSERT INTO dbo.p_dutyrate(
			name,
			value,
			projectid
			)
			SELECT  
				name,
				value,
				@proid as projectid
			FROM p_dutyrate WHERE projectid=0;


		INSERT INTO dbo.p_depreciation(
			size,
			value,
			times,
			depreciation,
			projectid
			)
			SELECT
					size,
				value,
				times,
				depreciation,
				@proid as projectid
			FROM p_depreciation WHERE projectid=0;

			INSERT INTO dbo.p_perstdhour (
			name, 
			labor, 
			oh, 
			tefficiency, 
			projectid
			)
				SELECT 
					name, 
				labor, 
				oh, 
				tefficiency, 
				@proid as projectid
			FROM p_perstdhour WHERE projectid=0;


			INSERT INTO dbo.p_csrecovery(
			name,
			val,
			projectid
			)
			SELECT
				name,
				val,
				@proid as projectid
			FROM p_csrecovery WHERE projectid=0;


			INSERT INTO dbo.p_copper (
      	alloy, segent, supplier, cu, zn, sn, ni, si, co, fe, zirconium, projectid
      )
			select alloy, segent, supplier, cu, zn, sn, ni, si, co, fe, zirconium,@proid as projectid
			from dbo.p_copper 
			where  projectid=0;

			INSERT INTO dbo.p_application(
			volume,
			packaging,
			packagingkey,
			imported,
			importedkey,
			projectid
			)
			SELECT 
				volume,
				packaging,
				packagingkey,
				imported,
				importedkey,
				@proid as projectid 
			FROM p_application WHERE projectid=0;

fetch next from youcurname into @proid
end
close youcurname
deallocate youcurname
COMMIT TRAN  
end try   
begin catch   
    ROLLBACK  
end catch
