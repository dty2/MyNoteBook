下载数据库:  
`sudo apt install mysql-server`服务器端  
`sudo apt install mysql-client`客户端  

在ubuntu server上使用root登陆使用命令`mysql -u root -p`遇到的问题
[ERROR 1698 (28000): Access denied for user 'root'@'localhost'](https://stackoverflow.com/questions/39281594/error-1698-28000-access-denied-for-user-rootlocalhost)
解决方案:  
``` bash shell
sudo mysql -u root # I had to use "sudo" since it was a new installation

mysql> USE mysql;
mysql> CREATE USER 'YOUR_SYSTEM_USER'@'localhost' IDENTIFIED BY 'YOUR_PASSWD';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'YOUR_SYSTEM_USER'@'localhost';
mysql> UPDATE user SET plugin='auth_socket' WHERE User='YOUR_SYSTEM_USER';
mysql> FLUSH PRIVILEGES;
mysql> exit;

sudo service mysql restart
```

导入.sql到数据库中
`mysql -u username -p`登陆
`CREATE DATABASE databasename` databasename为要创建的数据库名
`USE databasename` 和 `SOURCE /path/to/xxx.sql` 导入成功
