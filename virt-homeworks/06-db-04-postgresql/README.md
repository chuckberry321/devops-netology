# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

  **Ответ:**
- вывод списка БД (\l)
```sql
postgres-# \l
                                  List of databases
    Name     |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-------------+----------+----------+------------+------------+-----------------------
 netology_db | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres    | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |          |            |            | postgres=CTc/postgres
 template1   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |          |            |            | postgres=CTc/postgres
(4 rows)
```
- подключения к БД (\c database_name)
```sql
postgres-# \c netology_db 
You are now connected to database "netology_db" as user "postgres".
```
- вывода списка таблиц (\dt) 
- вывода описания содержимого таблиц (S - системные объекты, + - дополнительные данные)
```sql
netology_db=# \dtS+
                                 List of relations
   Schema   |          Name           | Type  |  Owner   |    Size    | Description 
------------+-------------------------+-------+----------+------------+-------------
 pg_catalog | pg_aggregate            | table | postgres | 56 kB      | 
 pg_catalog | pg_am                   | table | postgres | 40 kB      | 
 pg_catalog | pg_amop                 | table | postgres | 80 kB      | 
 pg_catalog | pg_amproc               | table | postgres | 56 kB      | 
 pg_catalog | pg_attrdef              | table | postgres | 8192 bytes | 
 pg_catalog | pg_attribute            | table | postgres | 464 kB     | 
 pg_catalog | pg_auth_members         | table | postgres | 40 kB      | 
 pg_catalog | pg_authid               | table | postgres | 48 kB      | 
 pg_catalog | pg_cast                 | table | postgres | 48 kB      | 
 pg_catalog | pg_class                | table | postgres | 136 kB     | 
 pg_catalog | pg_collation            | table | postgres | 240 kB     | 
 pg_catalog | pg_constraint           | table | postgres | 48 kB      | 
 pg_catalog | pg_conversion           | table | postgres | 56 kB      | 
 pg_catalog | pg_database             | table | postgres | 48 kB      | 
 pg_catalog | pg_db_role_setting      | table | postgres | 8192 bytes | 
 pg_catalog | pg_default_acl          | table | postgres | 8192 bytes | 
 pg_catalog | pg_depend               | table | postgres | 480 kB     | 
 pg_catalog | pg_description          | table | postgres | 368 kB     | 
 pg_catalog | pg_enum                 | table | postgres | 0 bytes    | 
 pg_catalog | pg_event_trigger        | table | postgres | 8192 bytes | 
 pg_catalog | pg_extension            | table | postgres | 48 kB      | 
 pg_catalog | pg_foreign_data_wrapper | table | postgres | 8192 bytes | 
 pg_catalog | pg_foreign_server       | table | postgres | 8192 bytes | 
 pg_catalog | pg_foreign_table        | table | postgres | 8192 bytes | 
 pg_catalog | pg_index                | table | postgres | 64 kB      | 
 pg_catalog | pg_inherits             | table | postgres | 0 bytes    | 
 pg_catalog | pg_init_privs           | table | postgres | 56 kB      | 
 pg_catalog | pg_language             | table | postgres | 48 kB      | 
 pg_catalog | pg_largeobject          | table | postgres | 0 bytes    | 
 pg_catalog | pg_largeobject_metadata | table | postgres | 0 bytes    | 
 pg_catalog | pg_namespace            | table | postgres | 48 kB      | 
 pg_catalog | pg_opclass              | table | postgres | 48 kB      | 
 pg_catalog | pg_operator             | table | postgres | 144 kB     | 
 pg_catalog | pg_opfamily             | table | postgres | 48 kB      | 
 pg_catalog | pg_partitioned_table    | table | postgres | 8192 bytes | 
 pg_catalog | pg_pltemplate           | table | postgres | 48 kB      | 
 pg_catalog | pg_policy               | table | postgres | 8192 bytes | 
 pg_catalog | pg_proc                 | table | postgres | 672 kB     | 
 pg_catalog | pg_publication          | table | postgres | 0 bytes    | 
 pg_catalog | pg_publication_rel      | table | postgres | 0 bytes    | 
 pg_catalog | pg_range                | table | postgres | 40 kB      | 
 pg_catalog | pg_replication_origin   | table | postgres | 8192 bytes | 
 pg_catalog | pg_rewrite              | table | postgres | 632 kB     | 
 pg_catalog | pg_seclabel             | table | postgres | 8192 bytes | 
 pg_catalog | pg_sequence             | table | postgres | 0 bytes    | 
 pg_catalog | pg_shdepend             | table | postgres | 40 kB      | 
 pg_catalog | pg_shdescription        | table | postgres | 48 kB      | 
 pg_catalog | pg_shseclabel           | table | postgres | 8192 bytes | 
 pg_catalog | pg_statistic            | table | postgres | 256 kB     | 
 pg_catalog | pg_statistic_ext        | table | postgres | 8192 bytes | 
 pg_catalog | pg_statistic_ext_data   | table | postgres | 8192 bytes | 
 pg_catalog | pg_subscription         | table | postgres | 8192 bytes | 
 pg_catalog | pg_subscription_rel     | table | postgres | 0 bytes    | 
 pg_catalog | pg_tablespace           | table | postgres | 48 kB      | 
 pg_catalog | pg_transform            | table | postgres | 0 bytes    | 
 pg_catalog | pg_trigger              | table | postgres | 8192 bytes | 
 pg_catalog | pg_ts_config            | table | postgres | 40 kB      | 
 pg_catalog | pg_ts_config_map        | table | postgres | 56 kB      | 
 pg_catalog | pg_ts_dict              | table | postgres | 48 kB      | 
 pg_catalog | pg_ts_parser            | table | postgres | 40 kB      | 
 pg_catalog | pg_ts_template          | table | postgres | 40 kB      | 
 pg_catalog | pg_type                 | table | postgres | 120 kB     | 
 pg_catalog | pg_user_mapping         | table | postgres | 8192 bytes | 
(63 rows)
```
- выхода из psql (\q)
```sql
netology_db=# \q
root@cded484a915d:/#
```


## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

  **ОТвет.**
```sql
test_database=# ANALYZE orders;
ANALYZE
test_database=# SELECT attname, avg_width FROM pg_stats where tablename='orders';
 attname | avg_width 
---------+-----------
 price   |         4
 id      |         4
 title   |        16
(3 rows)

test_database=#
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

  **Ответ:**
  Так как приразбиении таблицы orders у нас не будут только столбцы, используемые в родительской таблице и_
  родительская таблица уже содержит данные, то будем использовать декларативное секционирование и создадим новую_
  родительскую таблицу (потому что невозможно превратить обычную таблицу в партиционированную или наоборот)_
  в которую перенесем данные из старой.
```sql 
BEGIN;
CREATE TABLE orders_new (LIKE orders INCLUDING DEFAULTS) PARTITION BY RANGE (price);
CREATE TABLE orders_1 PARTITION OF orders_new FOR VALUES FROM (500) TO (MAXVALUE);
CREATE TABLE orders_2 PARTITION OF orders_new FOR VALUES FROM (MINVALUE) TO (500);
INSERT INTO orders_new SELECT * FROM orders; ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE orders_new RENAME TO orders;
COMMIT;

postgres=# SELECT  *FROM orders; 
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100 
  3 | Adventure psql time  |   300 
  4 | Server gravity falls |   300 
  5 | Log gossips          |   123 
  7 | Me and my bash-pet   |   499 
  2 | My little database   |   500 
  6 | WAL never lies       |   900 
  8 | Dbiezdmin            |   501
(8 rows)

postgres=# SELECT * FROM orders_1;
 id | title              | price 
----+--------------------+------- 
  2 | My little database |   500 
  6 | WAL never lies     |   900 
  8 | Dbiezdmin          |   501
(3 rows)

postgres=# SELECT * FROM orders_2;
 id |        title         | price 
----+----------------------+------- 
  1 | War and peace        | 100
  3 | Adventure psql time  | 300 
  4 | Server gravity falls | 300 
  5 | Log gossips          | 123 
  7 | Me and my bash-pet   | 499
(5 rows)
postgres=#

```
  При проектировании можно было исключить "ручное" разбиение таблиц, если сразу создавать их партицированными, так как,_
  как было сказано выше, невозможно превратить обычную таблицу в партиционированную.


---
## Задача 4
Используя утилиту `pg_dump` создайте бекап БД `test_database`.
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
  **Ответ:**

```sql
root@cded484a915d:/# pg_dump -U postgres test_database > /backup/test_database_dump.sql
```
  Для доработки бэкапа, создадаим новый файлюэкапа из старого, в котором будет добавлен ключ уникальности для столбца title
```sql
root@cded484a915d:/# sed 's@title character varying(80)@title character varying(80) UNIQUE@g' /backup/test_database_dump.sql  > /backup/test_database_dump_title_uniqe.sql
```
