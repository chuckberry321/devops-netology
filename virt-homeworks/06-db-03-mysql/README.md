# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

  **Ответ:**

  Создаем docker-compose манифест:   
```sql
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-03-mysql# cat docker-compose.yml 
version: "3.5"

services:
  db:
    image: mysql:8
    container_name: myslq
    restart: always
    volumes:
      - ~/mysql_db:/var/lib/mysql
      - ~/mysql_backup:/etc/backup
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=test_db
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-03-mysql# 
```
  Подключаемся в контейнер,восстанавливаем базу, выводим список таблиц и статус БД:   
```text
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-03-mysql# docker-compose up -d
Creating myslq ... done
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-03-mysql# docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                 NAMES
dc1ef0a9d7ee   mysql:8   "docker-entrypoint.s…"   6 seconds ago   Up 4 seconds   3306/tcp, 33060/tcp   myslq
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-03-mysql# docker exec -ti dc1ef0a9d7ee bash
root@dc1ef0a9d7ee:/# mysql -u root -p root test_db < /etc/backup/test_dump.sql 
root@dc1ef0a9d7ee:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.27 MySQL Community Server - GPL

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          10
Current database:       test_db
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.27 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 4 min 34 sec

Threads: 2  Questions: 48  Slow queries: 0  Opens: 167  Flush tables: 3  Open tables: 85  Queries per second avg: 0.175
--------------

mysql> 
```
  Количество записей с price > 300   
```sql
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

mysql> 
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

  **Ответ:**
```sql
mysql> create user if not exists
    -> 'test'@'localhost' identified with mysql_native_password by 'test-pass'  
    -> require none
    -> with max_queries_per_hour 100
    -> failed_login_attempts 3
    -> password expire interval 180 day
    -> password history 5
    -> attribute '{"fname": "James","lname": "Pretty"}'; 
Query OK, 0 rows affected (0.00 sec)

mysql> grant select on test_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> select * from information_schema.user_attributes where user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

mysql> 
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

  **Ответ:*
```sql
mysql> set profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
Empty set, 1 warning (0.00 sec)


mysql> select engine from information_schema.tables where table_schema = 'test_db'; 
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+
1 row in set (0.00 sec)

mysql> update orders set price = 321 where id = 5;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> alter table orders engine = MyISAM;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> update orders set price = 333 where id = 5;  
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> show profiles;
+----------+------------+-----------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                       |
+----------+------------+-----------------------------------------------------------------------------+
|        1 | 0.00055850 | select * from information_schema.user_attributes where user = 'test'        |
|        2 | 0.00028200 | select * from orders                                                        |
|        3 | 0.00028625 | select * from orders where price > 100 and price < 300                      |
|        4 | 0.00020275 | SHOW TABLE STATUS FROM `database`                                           |
|        5 | 0.00526825 | SHOW TABLE STATUS FROM `test_db`                                            |
|        6 | 0.00177675 | select * from information_schema.tables where table_schema = 'test_db'      |
|        7 | 0.00168725 | select engine from information_schema.tables where table_schema = 'test_db' |
|        8 | 0.00374025 | update orders set price = 321 where id = 5                                  |
|        9 | 0.03036250 | alter table orders engine = MyISAM                                          |
|       10 | 0.00190350 | update orders set price = 333 where id = 5                                  |
+----------+------------+-----------------------------------------------------------------------------+
10 rows in set, 1 warning (0.00 sec)

mysql>
``` 
  Из результатов профайлинга видно, что при движке MyISAM запрос на изменение выполняется быстрее.   


## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

  **Ответ:**
```text
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 330K
innodb_log_file_size = 100M
```

---
