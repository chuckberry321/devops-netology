# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

  **Ответ:**  
  docker-compose.yml
```text
version: "3.3"

services:
    db:
        image: postgres:12
        container_name: postgres_db
        volumes:
            - postgres_data:/var/lib/postgresql/data
            - postgres_backup:/backup
        environment:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: 123456
            POSTGRES_DB: netology_db
        ports:
            - 5432:5432
volumes:
    postgres_data:
    postgres_backup:
```

  Команда запуска:
```text
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker-compose up --build -d
```


## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,  
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

  **Ответ:**
- итоговый список БД  
```text
test_db=# \list
                                      List of databases
    Name     |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-------------+----------+----------+------------+------------+--------------------------------
 netology_db | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres    | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
             |          |          |            |            | postgres=CTc/postgres
 template1   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
             |          |          |            |            | postgres=CTc/postgres
 test_db     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
             |          |          |            |            | postgres=CTc/postgres         +
             |          |          |            |            | "test-admin-user"=CTc/postgres
```  
- описание таблиц (describe)  
```text
test_db=# \d clients
                                         Table "public.clients"
      Column       |          Type          | Collation | Nullable |               Default               
-------------------+------------------------+-----------+----------+-------------------------------------
 id                | integer                |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(255) |           |          | 
 страна проживания | character varying(255) |           |          | 
 заказ             | integer                |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d orders
                                       Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default               
--------------+------------------------+-----------+----------+------------------------------------
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(255) |           |          | 
 цена         | integer                |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# 
```  
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db  
```text
select * from information_schema.table_privileges where table_name='clients' or table_name = 'orders';
```  
- список пользователей с правами над таблицами test_db
```text
test_db=# select * from information_schema.table_privileges where table_name='clients' or table_name = 'orders';
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | test_db       | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | postgres         | test_db       | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(36 rows)

test_db=# 
```



## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

  **Ответ:**
```text
test_db=# insert into orders (наименование, цена) values ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
INSERT 0 5
test_db=# insert into  clients (фамилия, "страна проживания") values ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');                          
INSERT 0 5
```
```text
test_db=# select * from orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# select * from clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |      
  2 | Петров Петр Петрович | Canada            |      
  3 | Иоганн Себастьян Бах | Japan             |      
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
(5 rows)

test_db=# 
```
```text
test_db=# SELECT count(*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# SELECT count(*) FROM clients;
 count 
-------
     5
(1 row)

test_db=#
```
  Ну и следует переименовать столбец фамилия в ФИО:
```text
test_db=# alter table clients rename column фамилия to ФИО;
ALTER TABLE
test_db=# 
```


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

  **Ответ:**
```text
test_db=# update  clients set заказ = (select id from orders where наименование = 'Книга') where ФИО = 'Иванов Иван Иванович';
UPDATE 1
test_db=# update  clients set заказ = (select id from orders where наименование = 'Монитор') where ФИО = 'Петров Петр Петрович';     
UPDATE 1
test_db=# update  clients set заказ = (select id from orders where наименование = 'Гитара') where ФИО = 'Иоганн Себастьян Бах';       
UPDATE 1
test_db=#
```

```text
test_db=# select * from clients;
 id |         ФИО          | страна проживания | заказ 
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)

test_db=# select * from clients where заказ is not null;
 id |         ФИО          | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)

test_db=# 
```


## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

  **Ответ:**  
```text
test_db=# explain select * from clients where заказ is not null;
                         QUERY PLAN                         
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..10.70 rows=70 width=1040)
   Filter: ("заказ" IS NOT NULL)
(2 rows)

test_db=#
```
  _Здесь всего одна операция - последовательное сканирование таблицы clients._  
  _**cost** -  абстрактная величина оценивающая затраты, единица измерения – «извлечение одной страницы в последовательном (sequential) порядке». Первая величина  - Затраты на строку начала операции_  
  _вторая величина - затраты на получение всех строк (под всеми имеются в виду возвращенные этой операцией, а не все, имеющиеся в таблице)._  
  _**rows** -  это приблизительное количество строк, которое, как считает PostgreSQL, эта операция способна вернуть._  
  _**width** - это оценка PostgreSQL того, сколько, в среднем, байт содержится в одной строке, возвращенной в рамках данной операции._  


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

  **Ответ:**
  - делаем бекап
```text
root@5f2f8a9ab53e:/# pg_dump -U postgres test_db > /backup/test_db_backup.sql        
root@5f2f8a9ab53e:/# ls -lha /backup/
total 16K
drwxr-xr-x 2 root root 4.0K Nov  8 12:36 .
drwxr-xr-x 1 root root 4.0K Nov  8 09:39 ..
-rw-r--r-- 1 root root 4.3K Nov  8 12:36 test_db_backup.sql
root@5f2f8a9ab53e:/# 
```
  - останавливаем контейнер  
```text
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS       PORTS                                       NAMES
5f2f8a9ab53e   postgres:12   "docker-entrypoint.s…"   3 hours ago   Up 3 hours   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres_db
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker stop postgres_db
postgres_db
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# 
```
  - поднимаем новый пустой контейнер с PostgreSQL
```text
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker volume ls
DRIVER    VOLUME NAME
local     6aaa23551dd0b73122dee05790d1e93e20f4d1467124b322cd1d4bddfdb80d2e
local     06-db-02-sql_postgres_backup
local     06-db-02-sql_postgres_data
local     014e55ae331fab2f42825ac97422346d927f9fcaa97430dc9c26b85f4cec95e0
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker run --rm -d --name postgres_new -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v 06-db-02-sql_postgres_backup:/backup/ postgres:12
a8b8d2e4fa8d394c04e01b1bee31a09d6a4186559d84ab2caf3eacb9d95b205d
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
a8b8d2e4fa8d   postgres:12   "docker-entrypoint.s…"   4 seconds ago   Up 3 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres_new
root@vagrant:/home/vagrant/devops-netology/virt-homeworks/06-db-02-sql# docker exec -ti postgres_new bash
root@a8b8d2e4fa8d:/# ls /backup/
test_db_backup.sql
root@a8b8d2e4fa8d:/#
```
  - восстанавливаем БД в новом контейнере
```text
root@9d9b75c98dec:/# su - postgres -c "createdb test_db"
root@9d9b75c98dec:/# psql -U postgres -d test_db < /backup/test_db_backup.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval 
--------
      5
(1 row)

 setval 
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
```
  Также вручную будет необходимо создать роли test-admin-user и test-simple-user, как делали в Задании 2.
