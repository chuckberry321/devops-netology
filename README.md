 devops-netology

# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

### 1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:
###   * поместите его в автозагрузку,
###   * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
###   * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
   Создаем unit-файл:
```   vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ sudo nano /etc/systemd/system/node_exporter.service
     GNU nano 4.8                                                                    /etc/systemd/system/node_exporter.service                                                                              
   [Unit]
   Description=Node Exporter
   After=network.target

   [Service]
   User=node_exporter
   Group=node_exporter
   Type=simple
   ExecStart=/usr/local/bin/node_exporter

   [Install]
   WantedBy=multi-user.target
   

   vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$
```
   Помещаем в автозагрузку
```vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ ^C
vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ ^C
vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ sudo systemctl daemon-reload
vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ sudo systemctl start node_exporter
vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service в†’ /etc/systemd/system/node_exporter.service.
vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$ sudo systemctl status node_exporter
в—Џ node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-06-17 12:21:16 UTC; 15s ago
   Main PID: 1395 (node_exporter)
      Tasks: 4 (limit: 1072)
     Memory: 4.6M
     CGroup: /system.slice/node_exporter.service
             в””в”Ђ1395 /usr/local/bin/node_exporter

Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.477Z caller=node_exporter.go:113 collector=thermal_zone
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.477Z caller=node_exporter.go:113 collector=time
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:113 collector=timex
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:113 collector=udp_queues
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:113 collector=uname
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:113 collector=vmstat
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:113 collector=xfs
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:113 collector=zfs
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.478Z caller=node_exporter.go:195 msg="Listening on" address=:9100
Jun 17 12:21:16 vagrant node_exporter[1395]: level=info ts=2021-06-17T12:21:16.479Z caller=tls_config.go:191 msg="TLS is disabled." http2=false
vagrant@vagrant:/tmp/node_exporter-1.1.2.linux-386$
```

### 2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
   Я бы выбрал следующие опции - collector.cpu, сollector.diskstats, collector.meminfo, collector.netstat, collector.filesystem  


### 3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

   Добавляем проброс порта для Netdata:
```vagrant@vagrant:~/devops-netology$ sudo nano /etc/netdata/netdata.conf
  GNU nano 4.8                                                                                        

[global]
        run as user = netdata
        web files owner = root
        web files group = root
        # Netdata is not designed to be exposed to potentially hostile
        # networks. See https://github.com/netdata/netdata/issues/164
        bind socket to IP = 0.0.0.0  



        vagrant@vagrant:~/devops-netology$

```

### 4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
   Да, можно. Выберем все строчки из dmesg, содержащие слово virtual
```vagrant@vagrant:~/devops-netology$ dmesg | grep -i virtual
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.007783] CPU MTRRs all blank - virtualized system.
[    0.133356] Booting paravirtualized kernel on KVM
[    3.157562] systemd[1]: Detected virtualization oracle.
vagrant@vagrant:~/devops-netology$ dmesg | grep “Hypervisor detected”
```
Судя по всему ОС осознает, что загружена на системе виртуализации.

### 5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
   Посмотреть значение fs.nr_open можно двумя способами:
```vagrant@vagrant:~$ cat /proc/sys/fs/nr_open
1048576
vagrant@vagrant:~$ sysctl -n fs.nr_open
1048576
vagrant@vagrant:~$ 
```
   Это максимальное количество открытых дескрипторов в системе.
   Через ulimit мы можем посмотреть ограничения для текущей сессии для текущего пользователя испорльзуя команду *ulimit -a* (мягкие ограничения) или *ulimit -aH* (жесткие ограничения)
```file locks                      (-x) unlimited
vagrant@vagrant:~$ ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 3575
max locked memory       (kbytes, -l) 65536
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 3575
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
vagrant@vagrant:~$
```
   Параметр *open files* не даст возможности достичь числа открытых дескрипторов, установленных в параметре *fs.nr_open*.
   Изменить максимальное количество открытых файлов для пользователя можно комнадой ```ulimit -n``` указав кол-во файлов и имя пользователя.
   
### 6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
   Запускаем процесс *top*
```unshare -f --pid --mount-proc /bin/bash
```
   Из другого терминала пробуем посмотреть:
```root@vagrant:~# lsns
vagrant@vagrant:~$ sudo -i
root@vagrant:~# nsenter -t $(pidof top) -m -p ps ax
    PID TTY      STAT   TIME COMMAND
      1 pts/0    S+     0:00 top
      2 pts/1    R+     0:00 ps ax
root@vagrant:~#    
```
### 7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
   это функция, которая параллельно запускает два своих экземпляра. Каждый запускает ещё по два и т.д.
   Судя по вот этой записи в dmesg ```[ 2739.776188] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-4.scope```, стабилизации помог механизм cgrroup.
   Он ограничивает ресурсы (память, в том числе виртуальную), предоставляет возможности приоритезации, управления и тд и тп
   Число процессов можно ограничить используя команду ```ulimit -u```, она ограничит количество процессов пользователя или в файле ```/etc/security/limits.conf```.

