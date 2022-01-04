# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

` **Ответ:**
- Dockerfile
```sql
FROM centos:latest

ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-darwin-x86_64.tar.gz /
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-darwin-x86_64.tar.gz.sha512 /

RUN yum update -y && \
    yum install -y perl-Digest-SHA && \
    yum install -y java-11-openjdk-devel && \
    shasum -a 512 -c elasticsearch-7.16.2-darwin-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.16.2-darwin-x86_64.tar.gz && \
    rm -rf elasticsearch-7.16.2-darwin-x86_64.tar.gz elasticsearch-7.16.2-darwin-x86_64.tar.gz.sha512 && \
    cd elasticsearch-7.16.2 && \
    groupadd elastic && \
    useradd -g elastic -p elastic elastic && \
    chown -R elastic:elastic /elasticsearch-7.16.2 && \
    chmod o+x /elasticsearch-7.16.2 && \
    mkdir -p /var/lib/elasticsearch/{data,logs} && \
    chown -R elastic:elastic /var/lib/elasticsearch && \
    mkdir -p /elasticsearch-7.16.2/snapshots && \
    chown -R elastic:elastic /elasticsearch-7.16.2/snapshots

USER elastic

ENV ES_JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH="$ES_JAVA_HOME/bin:${PATH}"

RUN echo "node.name: netology_test" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "path.data: /var/lib/elasticsearch/" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "network.host: 0.0.0.0" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "discovery.type: single-node" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "path.repo: /elasticsearch-7.16.2/snapshots" >> /elasticsearch-7.16.2/config/elasticsearch.yml  && \
    echo "xpack.ml.enabled: false" >> /elasticsearch-7.16.2/config/elasticsearch.yml

VOLUME /var/lib/elasticsearch/data
VOLUME /var/lib//elasticsearch/logs

EXPOSE 9200

CMD ["/elasticsearch-7.16.2/bin/elasticsearch"]
```
- Запуск
```
docker build -t chuckberry321/elasticsearch .
docker run -d --name elasticsearch -p 9200:9200 chuckberry321/elasticsearch
```
- Файл [elasticsearch.yml] (https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/06-db-05-elasticsearch/elasticsearch.yml)
- [Ссылка на образ в репозитории] (https://hub.docker.com/repository/docker/chuckberry321/elasticsearch)
- ответ elasticsearch на запрос пути / в json виде
```
[elastic@4a1bf2305b5b /]$ curl localhost:9200/
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "oOf6cYA1ScaO7B-HJ2-IlQ",
  "version" : {
    "number" : "7.16.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "2b937c44140b6559905130a8650c64dbd0879cfb",
    "build_date" : "2021-12-18T19:42:46.604893745Z",
    "build_snapshot" : false,
    "lucene_version" : "8.10.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
[elastic@4a1bf2305b5b /]$ exit
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

  **Ответ:**
- Создание индексов
```
[elastic@4a1bf2305b5b /]$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}' 
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
[elastic@4a1bf2305b5b /]$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}
[elastic@4a1bf2305b5b /]$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```

- Cписок индексов и их статусов
```
[elastic@4a1bf2305b5b /]$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases mfXEtPIyRS-n7dXAXYvFFQ   1   0         44            0     40.8mb         40.8mb
green  open   ind-1            PzYKPFTfQyiIJTWQ3u9n5g   1   0          0            0       226b           226b
yellow open   ind-3            wRQFlOfbRyiwESVh7V065w   4   2          0            0       904b           904b
yellow open   ind-2            3SgmyUwSTcCuAMPdrDyVDA   2   1          0            0       452b           452b
```

- Cсостояние кластера elasticsearch
```
[elastic@4a1bf2305b5b /]$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
[elastic@4a1bf2305b5b /]$
```

Статус кластера и индексов *yellow*, потому что у этих индексов количество реплик >0, а фактически у нас один сервер и реплецировать данные некуда. 

- Удаление индексов
```
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$
```  

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

  **Ответ:*

- Директория создаетя в Задании 1 в Dockerfile

- Регистрация директории
```
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$
```

- Создание индекса
```
[elastic@4a1bf2305b5b /]$ curl -X PUT localhost:9200/test?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[elastic@4a1bf2305b5b /]$ curl -X GET 'http://localhost:9200/test?pretty'
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1641313007469",
        "number_of_replicas" : "0",
        "uuid" : "XV35pyduSZiiYqMKQdE9xQ",
        "version" : {
          "created" : "7160299"
        }
      }
    }
  }
}
[elastic@4a1bf2305b5b /]$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases mfXEtPIyRS-n7dXAXYvFFQ   1   0         44            0     40.8mb         40.8mb
green  open   test             XV35pyduSZiiYqMKQdE9xQ   1   0          0            0       226b           226b
[elastic@4a1bf2305b5b /]$
```

- Создание снэпшота и список файлов в директории
```
[elastic@4a1bf2305b5b /]$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"6DpmM6ISSymmJFO3yP4X0Q","repository":"netology_backup","version_id":7160299,"version":"7.16.2","indices":[".ds-.logs-deprecation.elasticsearch-default-2022.01.04-000001",".geoip_databases",".ds-ilm-history-5-2022.01.04-000001","test"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-01-04T16:19:24.628Z","start_time_in_millis":1641313164628,"end_time":"2022-01-04T16:19:25.740Z","end_time_in_millis":1641313165740,"duration_in_millis":1112,"failures":[],"shards":{"total":4,"failed":0,"successful":4},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
[elastic@4a1bf2305b5b /]$ ls -lha /elasticsearch-7.16.2/snapshots/
total 56K
drwxr-xr-x 1 elastic elastic 4.0K Jan  4 16:19 .
drwxr-xr-x 1 elastic elastic 4.0K Jan  3 18:54 ..
-rw-r--r-- 1 elastic elastic 1.4K Jan  4 16:19 index-0
-rw-r--r-- 1 elastic elastic    8 Jan  4 16:19 index.latest
drwxr-xr-x 6 elastic elastic 4.0K Jan  4 16:19 indices
-rw-r--r-- 1 elastic elastic  23K Jan  4 16:19 meta-6DpmM6ISSymmJFO3yP4X0Q.dat
-rw-r--r-- 1 elastic elastic  712 Jan  4 16:19 snap-6DpmM6ISSymmJFO3yP4X0Q.dat
[elastic@4a1bf2305b5b /]$
```

- Удаление индекса и создание нового
```
[elastic@4a1bf2305b5b /]$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
[elastic@4a1bf2305b5b /]$ curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
[elastic@4a1bf2305b5b /]$
``` 

- Восстановление состояния кластера
```
[elastic@4a1bf2305b5b snapshots]$ curl -X POST "localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty" -H 'Content-Type: application/json' -d' { "indices": "test" }'
{
  "accepted" : true
}
[elastic@4a1bf2305b5b snapshots]$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2           QFojKuS7RtC-SEz7molNmw   1   0          0            0       226b           226b
green  open   .geoip_databases mfXEtPIyRS-n7dXAXYvFFQ   1   0         44            0     40.8mb         40.8mb
green  open   test             HycCy0PYTxSA0fl1KwBS8g   1   0          0            0       226b           226b
[elastic@4a1bf2305b5b snapshots]$
```

- 
Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
