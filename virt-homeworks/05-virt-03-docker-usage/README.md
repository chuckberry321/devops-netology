# Домашнее задание к занятию "5.3. Контейнеризация на примере Docker"

## Задача 1 

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование докера? Или лучше подойдет виртуальная машина, физическая машина? Или возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;\
  **Ответ.** Лучше использовать виртуальную машину или физический выделенный сервер. Докер не подойдет для высоконагруженных монолитных приложений. 

- Go-микросервис для генерации отчетов;\
  **Ответ.** Нужно использовать докер. Контейнеры хорошо вписываются в микросервисную архитектуру.

- Nodejs веб-приложение;\
  **Ответ.** Лучше использовать докер, но это в том случае если нет требований к повышенной производительности.

- Мобильное приложение c версиями для Android и iOS;\
  **Ответ.** Приложения с графическим интерфейсом не желательно использовать в докер-контейнерах.

- База данных postgresql используемая, как кэш;\
  **Ответ.** Так как СУБД испозьуется как кэш, значит требуется высокая производитекльность и скорость работы с СХД. Вывод - желателен физический сервер.

- Шина данных на базе Apache Kafka;\
  **Ответ.** Kafka - это масштабируемый брокер сообщений. Вполне можно использовать докер.

- Очередь для Logstash на базе Redis;\
  **Ответ.** Судя по описаниям, насколько я понял, Redis будет использоваться в качсетве брокера, значит можно использовать докер.

- Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;\
  **Ответ.** Так как веб-приложение продуктивное, то можно разделить - elasticsearch - на выделенный сервер или вм на сервере паравиртуализации, logstash и kibana в докерах.

- Мониторинг-стек на базе prometheus и grafana;\
  **Ответ.** Можно использовать докер.

- Mongodb, как основное хранилище данных для java-приложения;\
  **Ответ.** Мне кажется что в зависимости он нагрузки. При высокой нагрузке - сервер или ВМ, при не высокой - докер.

- Jenkins-сервер.\
  **Ответ.** Jenkins не хранит данные и сам является микросервисом. МОжно использовать докер.

## Задача 2 

Сценарий выполения задачи:

- создайте свой репозиторий на докерхаб; 
- выберете любой образ, который содержит апачи веб-сервер;
- создайте свой форк образа;
- реализуйте функциональность: 
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже: 
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m kinda DevOps now</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на докерхаб-репо.

  **Ответ.** Ссылка на репо https://hub.docker.com/repository/docker/chuckberry321/devops-netology

```
vagrant@vagrant:~$ sudo docker images
REPOSITORY                      TAG       IMAGE ID       CREATED       SIZE
chuckberry321/devops-netology   v.01      e91425f38618   9 hours ago   138MB
httpd                           latest    e91425f38618   9 hours ago   138MB
edxops/studio-frontend          latest    d788eb6b2c96   2 weeks ago   1.17GB
node                            8.11      8198006b2b57   3 years ago   673MB
vagrant@vagrant:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND              CREATED          STATUS          PORTS                               NAMES
ef4840951cf8   httpd     "httpd-foreground"   39 minutes ago   Up 39 minutes   0.0.0.0:88->80/tcp, :::88->80/tcp   httpd01
vagrant@vagrant:~$ curl localhost:88
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m kinda DevOps now</h1>
</body>
</html>
vagrant@vagrant:~$ 
```

## Задача 3 

- Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /share/info контейнера;
  
  **Ответ:**

```
root@vagrant:/home/vagrant# docker pull centos
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest
root@vagrant:/home/vagrant# mkdir info
root@vagrant:/home/vagrant# docker run -it --name centos-01 -v /home/vagrant/info/:/share/info/ -d centos
```

- Запустите второй контейнер из образа debian:latest в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /info контейнера;
  
  **Ответ.**

```root@vagrant:/home/vagrant# docker pull debian
Using default tag: latest
latest: Pulling from library/debian
df5590a8898b: Pull complete 
Digest: sha256:e68966e6b0c5e55ad80a5b6d0366245c086768c99e921317c1c1da6bc9e3c920
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest
root@vagrant:/home/vagrant# docker run -ti --name debian-01 -v /home/vagrant/info/:/info/ -d debian
2fccb4fdb230af83648c29931b13a8324d554aa516f68e3119299dc71ebdbc5c
root@vagrant:/home/vagrant#
```

- Подключитесь к первому контейнеру с помощью exec и создайте текстовый файл любого содержания в /share/info ;

  **Ответ.**

```
root@vagrant:/home/vagrant# docker exec -ti centos-01 bash
[root@a49f619bd1fd /]# echo "it's a test">/share/info/test.txt   
[root@a49f619bd1fd /]# cat /share/info/test.txt 
it's a test
[root@a49f619bd1fd /]# 
```

- Добавьте еще один файл в папку info на хостовой машине;

  **Ответ.**

```
root@vagrant:/home/vagrant# echo "it's another test" > info/test2.txt
root@vagrant:/home/vagrant# cat info/test2.txt 
it's another test
root@vagrant:/home/vagrant# 
```

- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /info контейнера.

  **Ответ.**

```
root@vagrant:/home/vagrant# docker exec -ti debian-01 bash
root@a5dcbecd2947:/# ls -lha info/
total 16K
drwxrwxr-x 2 1000 1000 4.0K Sep 28 16:51 .
drwxr-xr-x 1 root root 4.0K Sep 28 16:56 ..
-rw-r--r-- 1 root root   12 Sep 28 16:49 test.txt
-rw-r--r-- 1 root root   18 Sep 28 16:51 test2.txt
root@a5dcbecd2947:/# cat info/test.txt 
it's a test
root@a5dcbecd2947:/# cat info/test2.txt 
it's another test
root@a5dcbecd2947:/# 
```
