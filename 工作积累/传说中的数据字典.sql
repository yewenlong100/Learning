
SELECT 
		coltablename    = case when a.colorder=1 then d.name else '' end,
    coltabledesc     = case when a.colorder=1 then isnull(f.value,'') else '' end,
    colordernums   = a.colorder,
    colname     = a.name,
    colidentity       = case when COLUMNPROPERTY( a.id,a.name,'IsIdentity')=1 then '1'else '' end,
    colpk       = case when exists(SELECT 1 FROM sysobjects where xtype='PK' and parent_obj=a.id and name in (
                     SELECT name FROM sysindexes WHERE indid in( SELECT indid FROM sysindexkeys WHERE id = a.id AND colid=a.colid))) then '1' else '' end,
    coltype       = b.name,
    collength = a.length,
    collogn       = COLUMNPROPERTY(a.id,a.name,'PRECISION'),
    colprintbit   = isnull(COLUMNPROPERTY(a.id,a.name,'Scale'),0),
    colallownull     = case when a.isnullable=1 then '1'else '' end,
    coldefault     = isnull(e.text,''),
    coldesc   = isnull(g.[value],'')
FROM
    syscolumns a
left join
    systypes b
on
    a.xusertype=b.xusertype
inner join
    sysobjects d
on
    a.id=d.id  and d.xtype='U' and  d.name<>'dtproperties'
left join
    syscomments e
on
    a.cdefault=e.id
left join
sys.extended_properties   g
on
    a.id=G.major_id and a.colid=g.minor_id
left join

sys.extended_properties f
on
    d.id=f.major_id and f.minor_id=0
 where d.name='p_mwpiece'    --如果只查询指定表,加上此条件
order by
    d.name,a.id,a.colorder

