# 数据库操作
#### 创建数据库
``` sql
create database test on primary(
	name = test,
	filename = 'D:\data\sqldata\test\test.mdf',
	size = 5,
	filegrowth = 10%	
)
log on(
	name = test_log,
	filename = 'D:\data\sqldata\test\test_log.ldf',
	size = 2,
	maxsize = 100,
	filegrowth = 2
)
```

#### 查看数据库
``` sql
-- 查看当前正在use的数据库
select db_name()
-- 查看所有数据库
select * from sys.databases
-- 查看数据库属性
exec sp_helpdb test
```
#### use数据库
``` sql
选择当前使的 master
use master
```
#### 删除数据库
``` sql
drop database test
```
#### 数据库改名
``` sql
alter database testing modify name = test
sp_renamedb 'test', 'testing'
/*
	修改完一个数据库名称后，不能立即进行再次修改，不然会报错
	消息 5030，级别 16，状态 2，第 20 行
	无法独占锁定数据库 testing 来执行此操作
	因为其他用户正在使用该数据库
	想要解决，使用use更换成其他数据库即可
*/
```

# 表操作
#### 表改名
``` sql
exec sp_rename 'log_info', 'loginfo'
```
#### 查看表
``` sql
-- 查看指定表
select * from loginfo
-- 查看所有表
select * from database_chat.sys.tables
```
#### 创建表
``` sql
-- 单表创建
create table loginfo(
	account nvarchar(100) not null primary key clustered,
	"password" nchar(8) not null
)
create table userinfo(
	account nvarchar not null primary key clustered,
	nickname nvarchar not null,
	foreign key(account) references loginfo(account)
)

-- ps: 创建主键时没有指定约束名称(被系统分配的)
--     想要删除该主键约束，需要先查询到该主键约束名字

-- 主键约束名称查询
exec sp_pkeys 'userinfo'
```

#### 表操作
``` sql
-- 对表操作之前要确定修改的列必须删除所有相关的索引和约束
-- 查看列属性
exec sp_columns 'loginfo'
-- 增加列
alter table loginfo
add account nvarchar(20) constraint account_main_key primary key clustered
-- 删除列
alter table loginfo
drop column account
-- 删除约束
alter table userinfo
drop constraint PK__userinfo__EA162E104913C60B
-- 修改列
alter table loginfo
alter column "password" nchar(8) not null
```

#### 操作表
``` sql
-- 插入数据
insert into loginfo (account, "password") values('hunter', 12345678)
-- 更新数据
update loginfo set "password" = 87654321 where account = 'xiaoming'
-- 删除数据
delete logoinfo where account = 'lihua'
```

#### 查询
``` sql
-- 查看表所有内容
select * from table_name
-- 查看所有列，有限行
select top 5 from table_name
-- 特定列
select column_name1 column_name2 from table_name
```

#### 操作结果
``` sql
-- 排序
select column_name1 column_name2 from table_name order by column_name desc
```