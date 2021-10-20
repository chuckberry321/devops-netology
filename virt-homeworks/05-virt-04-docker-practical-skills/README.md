# Домашнее задание к занятию "5.4. Практические навыки работы с Docker"

## Задача 1 

В данном задании вы научитесь изменять существующие Dockerfile, адаптируя их под нужный инфраструктурный стек.

Измените базовый образ предложенного Dockerfile на Arch Linux c сохранением его функциональности.

```text
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:vincent-c/ponysay && \
    apt-get update
 
RUN apt-get install -y ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```

Для получения зачета, вам необходимо предоставить:
- Написанный вами Dockerfile
- Скриншот вывода командной строки после запуска контейнера из вашего базового образа
- Ссылку на образ в вашем хранилище docker-hub

  **Ответ.**
  Dockerfile:
```text
FROM archlinux

RUN yes | pacman -Syu  && \
    yes | pacman -S ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```
  [скриншот вывода командной строки:](https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/05-virt-04-docker-practical-skills/lesson1/lesson1.png)

  Ссылка на образ: 
  https://hub.docker.com/r/chuckberry321/lesson1-ponysay/tags

## Задача 2

В данной задаче вы составите несколько разных Dockerfile для проекта Jenkins, опубликуем образ в `dockerhub.io` и посмотрим логи этих контейнеров.

- Составьте 2 Dockerfile:

    - Общие моменты:
        - Образ должен запускать [Jenkins server](https://www.jenkins.io/download/)
        
    - Спецификация первого образа:
        - Базовый образ - [amazoncorreto](https://hub.docker.com/_/amazoncorretto)
        - Присвоить образу тэг `ver1` 
    
    - Спецификация второго образа:
        - Базовый образ - [ubuntu:latest](https://hub.docker.com/_/ubuntu)
        - Присвоить образу тэг `ver2` 

- Соберите 2 образа по полученным Dockerfile
- Запустите и проверьте их работоспособность
- Опубликуйте образы в своём dockerhub.io хранилище

Для получения зачета, вам необходимо предоставить:
- Наполнения 2х Dockerfile из задания
- Скриншоты логов запущенных вами контейнеров (из командной строки)
- Скриншоты веб-интерфейса Jenkins запущенных вами контейнеров (достаточно 1 скриншота на контейнер)
- Ссылки на образы в вашем хранилище docker-hub

  **Ответ 2.1 Amazoncorretto**
  Dockerfile:
```text
FROM amazoncorretto

ADD https://pkg.jenkins.io/redhat-stable/jenkins.repo /etc/yum.repos.d/

RUN amazon-linux-extras install epel -y && \
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key && \
    yum install -y jenkins

EXPOSE 8080

CMD ["java", "-jar", "/usr/lib/jenkins/jenkins.war"]
```
  [Скриншот лога:](https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/05-virt-04-docker-practical-skills/lesson2/lesson2_log.png)
  [Скриншот веб-интерфейса] (https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/05-virt-04-docker-practical-skills/lesson2/lesson2.png)
  Ссылка на образ:
  https://hub.docker.com/repository/docker/chuckberry321/lesson2/tags

   **Ответ 2.2 Ubuntu**
   Dockerfile:
```text
FROM ubuntu:latest

ADD https://pkg.jenkins.io/debian-stable/jenkins.io.key /tmp/

RUN apt-get update && \
    apt-get install -y gnupg ca-certificates && \
    apt-key add /tmp/jenkins.io.key && \
    sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && \
    apt install -y default-jre && \
    apt-get install -y jenkins

EXPOSE 8080

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
```
  [Скриншот лога:](https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/05-virt-04-docker-practical-skills/lesson2.2/lesson2.2_log.png)
  [Скриншот веб-интерфейса] (https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/05-virt-04-docker-practical-skills/lesson2.2/lesson2.2.png)
  Ссылка на образ:
  https://hub.docker.com/repository/docker/chuckberry321/lesson2.2/tags 


## Задача 3 

В данном задании вы научитесь:
- объединять контейнеры в единую сеть
- исполнять команды "изнутри" контейнера

Для выполнения задания вам нужно:
- Написать Dockerfile: 
    - Использовать образ https://hub.docker.com/_/node как базовый
    - Установить необходимые зависимые библиотеки для запуска npm приложения https://github.com/simplicitesoftware/nodejs-demo
    - Выставить у приложения (и контейнера) порт 3000 для прослушки входящих запросов  
    - Соберите образ и запустите контейнер в фоновом режиме с публикацией порта

- Запустить второй контейнер из образа ubuntu:latest 
- Создайть `docker network` и добавьте в нее оба запущенных контейнера
- Используя `docker exec` запустить командную строку контейнера `ubuntu` в интерактивном режиме
- Используя утилиту `curl` вызвать путь `/` контейнера с npm приложением  

Для получения зачета, вам необходимо предоставить:
- Наполнение Dockerfile с npm приложением
- Скриншот вывода вызова команды списка docker сетей (docker network cli)
- Скриншот вызова утилиты curl с успешным ответом

  **Ответ**
  Dockerfile:
```text
FROM node

WORKDIR "/nodejs"

RUN git clone https://github.com/simplicitesoftware/nodejs-demo.git . && \
    apt-get update && \
    npm install


EXPOSE 3000

CMD ["npm", "start", "0.0.0.0"]
```
  Docker network:
```text
root@vagrant:/home/vagrant# docker network create -d bridge new_net
c8c85e8e42fa5d89978ec79a78087c86ea2eb1f4bb1be793cccb2204d374505d
root@vagrant:/home/vagrant# docker network connect new_net ubuntu
root@vagrant:/home/vagrant# docker network connect new_net nodejs
root@vagrant:/home/vagrant# docker network ls
NETWORK ID     NAME               DRIVER    SCOPE
dd407d006101   bridge             bridge    local
3e5206e0c53c   devstack_default   bridge    local
65d6b6a5d191   host               host      local
c8c85e8e42fa   new_net            bridge    local
9ccc92cb48f6   none               null      local
root@vagrant:/home/vagrant# docker network inspect new_net
[
    {
        "Name": "new_net",
        "Id": "c8c85e8e42fa5d89978ec79a78087c86ea2eb1f4bb1be793cccb2204d374505d",
        "Created": "2021-10-20T16:09:30.060390413+03:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.20.0.0/16",
                    "Gateway": "172.20.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "17b061d539c903cddd3d32fcebbcacac490c371d0df66125c4f5202666b734e6": {
                "Name": "ubuntu",
                "EndpointID": "a7cdeed6f2742d597183f4c0061ddfc1fb0c81dc58056c49b4863ef28a060851",
                "MacAddress": "02:42:ac:14:00:02",
                "IPv4Address": "172.20.0.2/16",
                "IPv6Address": ""
            },
            "fd0cfa65bb4016684b05dbcc500a4ed14c3901ccc9e59ddefaa318f592e6d131": {
                "Name": "nodejs",
                "EndpointID": "b98e85858af7d30d4ada44c921e24c875ff4d69d885af35e63445b859f6b5e79",
                "MacAddress": "02:42:ac:14:00:03",
                "IPv4Address": "172.20.0.3/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
``` 

  [Скриншот вызова утилиты curl:](https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/05-virt-04-docker-practical-skills/lesson3/lesson3.png)
