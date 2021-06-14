 devops-netology

# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

## 1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.
   ```
   vagrant@vagrant:~/devops-netology$ sudo strace -o trace.log /bin/bash -c 'cd /tmp/'
   vagrant@vagrant:~/devops-netology$ grep tmp trace.log
   execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp/"], 0x7fffc7fb1510 /* 14 vars */) = 0
   stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
   chdir("/tmp")                           = 0
   vagrant@vagrant:~/devops-netology$
   ```
   Сооствественно, системный вызов, который делает команда *cd* - это
   ```
   chdir("/tmp")                           = 0
   ```
## 1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе.
## 1. Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
   Команда file для получения данных из файла база данных должна его вначале открыть, поэтому логично искать в логах *strace* системный вызов *openat*
   ```
   vagrant@vagrant:~/devops-netology$ strace -o trace.log file /dev/tty
   /dev/tty: character special (5/0)
   vagrant@vagrant:~/devops-netology$ grep openat trace.log
   openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
   openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
   vagrant@vagrant:~/devops-netology$
   ```
   Логично предположить, что файл базы данных это */usr/share/misc/magic.mgc*. Этот файл явлется ссылкой:
   ```
   vagrant@vagrant:~/devops-netology$ ll /usr/share/misc/magic.mgc
   lrwxrwxrwx 1 root root 24 May 25 05:42 /usr/share/misc/magic.mgc -> ../../lib/file/magic.mgc
   vagrant@vagrant:~/devops-netology$
   ```
   То есть файл ,азы данных это - */usr/lib/file/magic.mgc*
## 1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
   Используем для проверки вывод в файл команды *glances*
```
vagrant@vagrant:~$ tty
/dev/pts/0
vagrant@vagrant:~$ glances | tee -a glances.log
```
   Далее работаем в  другом терминале
```
vagrant@vagrant:~$ tty
/dev/pts/1
vagrant@vagrant:~$ ll
total 736
drwxr-xr-x 7 vagrant vagrant 331776 Jun 14 15:44 ./
drwxr-xr-x 3 root    root      4096 May 25 05:47 ../
-rw------- 1 vagrant vagrant  16233 Jun 10 09:38 .bash_history
-rw-r--r-- 1 vagrant vagrant    220 May 25 05:47 .bash_logout
-rw-r--r-- 1 vagrant vagrant   3771 May 25 05:47 .bashrc
drwx------ 2 vagrant vagrant   4096 May 25 05:48 .cache/
drwx------ 4 vagrant vagrant   4096 Jun 14 15:41 .config/
drwxr-xr-x 8 vagrant vagrant 311296 Jun 14 15:49 devops-netology/
-rw-rw-r-- 1 vagrant vagrant     66 May 27 17:01 .gitconfig
-rw-rw-r-- 1 vagrant vagrant  43288 Jun 14 15:50 glances.log
-rw------- 1 vagrant vagrant    280 Jun 10 09:40 .lesshst
drwxrwxr-x 3 vagrant vagrant   4096 May 27 16:56 .local/
-rw-r--r-- 1 vagrant vagrant    807 May 25 05:47 .profile
drwx------ 2 vagrant root      4096 Jun  7 17:27 .ssh/
-rw-r--r-- 1 vagrant vagrant      0 May 25 05:48 .sudo_as_admin_successful
-rw-r--r-- 1 vagrant vagrant      6 May 25 05:48 .vbox_version
-rw-r--r-- 1 root    root       180 May 25 05:52 .wget-hsts
vagrant@vagrant:~$ rm glances.log
vagrant@vagrant:~$ ps -aux | grep tee
vagrant     4099  0.0  0.0   8088   596 pts/0    S+   15:50   0:00 tee -a glances.log
vagrant     4146  0.0  0.0   8900   672 pts/1    S+   15:51   0:00 grep --color=auto tee
vagrant@vagrant:~$ lsof -p 4099 | grep glances.log
lsof: WARNING: can't stat() tracefs file system /sys/kernel/debug/tracing
      Output information may be incomplete.
tee     4099 vagrant    3w   REG  253,0    80467  131344 /home/vagrant/glances.log (deleted)
```
   Удаляем содержимое файла
```
vagrant@vagrant:~$ cat /dev/null > /proc/4099/fd/3
```
   Проверяем размер лога
```vagrant@vagrant:~$ lsof -p 4099 | grep glances.log
lsof: WARNING: can't stat() tracefs file system /sys/kernel/debug/tracing
      Output information may be incomplete.
tee     4099 vagrant    3w   REG  253,0      286  131344 /home/vagrant/glances.log (deleted)
```
   Видим, что размер был 43288, а стал 286, значит содержимое было стёрто.

## 1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
   Зомби процессы не занимют ресурсы в операционной системе, как например процессы-сироты, но они блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.
   При достижения лимита записей все процессы пользователя, от имени которого выполняется зомби-процесс, не смогут создавать новые дочерние процессы и этот пользователь не сможет зайти на консоль или полнять
   команды в открытой уже консоли.
## 1. В iovisor BCC есть утилита `opensnoop`:
## На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
   opensnoop-bpfcc без использования ключей показывает вызовы open:
```
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
795    vminfo              4   0 /var/run/utmp
585    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
585    dbus-daemon        18   0 /usr/share/dbus-1/system-services
585    dbus-daemon        -1   2 /lib/dbus-1/system-services
585    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
612    irqbalance          6   0 /proc/interrupts
612    irqbalance          6   0 /proc/stat
612    irqbalance          6   0 /proc/irq/20/smp_affinity
612    irqbalance          6   0 /proc/irq/0/smp_affinity
612    irqbalance          6   0 /proc/irq/1/smp_affinity
612    irqbalance          6   0 /proc/irq/8/smp_affinity
612    irqbalance          6   0 /proc/irq/12/smp_affinity
612    irqbalance          6   0 /proc/irq/14/smp_affinity
612    irqbalance          6   0 /proc/irq/15/smp_affinity
795    vminfo              4   0 /var/run/utmp
585    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
585    dbus-daemon        18   0 /usr/share/dbus-1/system-services
585    dbus-daemon        -1   2 /lib/dbus-1/system-services
585    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
795    vminfo              4   0 /var/run/utmp
585    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
585    dbus-daemon        18   0 /usr/share/dbus-1/system-services
585    dbus-daemon        -1   2 /lib/dbus-1/system-services
585    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
^Cvagrant@vagrant:~$
```

## 1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
```
vagrant@vagrant:~$ strace -o uname.log uname -a
Linux vagrant 5.4.0-73-generic #82-Ubuntu SMP Wed Apr 14 17:39:42 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
vagrant@vagrant:~$ grep uname uname.log
execve("/usr/bin/uname", ["uname", "-a"], 0x7ffc3aae6f18 /* 24 vars */) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
```
   *uname -a* использует системный вызов *uname*. Информацию по нему можно получить по команде *man 2 uname*, предварительно установив пакет *manpages-dev*
   Цитата из man по этому вызову:
```
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
```
## 1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
##  Есть ли смысл использовать в bash `&&`, если применить `set -e`?
   Символ-оператор ; позволяет задать в командой строке последовательность команд, которые будут выполняться последовательно, одна за другой.
   && это управляющий оператор, служит для разделени команд в командной строке, но вторая команда, стоящая после &&, будет выполняться только в том случае,
   если статус выхода из первой команды будет равен нулю, что говорит о ее успешном завершении.
   В хелпе команды set про ключ -e сказано следующее *      -e  Exit immediately if a command exits with a non-zero status.*, то есть, в этом случае использолвать && нет смысла
## 1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
```
-o option-name
   Set the variable corresponding to option-name:
       pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
```
   Статусом выхода из конвейера, в том случае, если не включена опция pipefail, служит статус завершения последней команды конвейера.
   Если опция pipefail включена — статус выхода из конвейера является значением последней (самой правой) команды, завершённой с ненулевым статусом, или ноль — если работа всех команд завершена успешно.
   Причина использования pipefail заключается в том, что иначе команда, неожиданно завершившаяся с ошибкой и находящаяся где-нибудь в середине конвейера, обычно остаётся незамеченной.
   Она, если использовалась опция set -e, не приведёт к аварийному завершению скрипта.
## 1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   Используя *man ps* получаем информацию по статусам процессов:
```
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
```
   Смотрим какие статусы имеют процессы у нас:
```
vagrant@vagrant:~$ ps aexo pid,stat
    PID STAT
      1 Ss
      2 S
      3 I<
      4 I<
      6 I<
      9 I<
     10 S
     ...
   4424 T
   7034 I
   7511 I
   8036 I
   8105 I
   8136 I
   8277 S+
   8278 I
   8287 R+
```
   Видим, что у нас в данный момент 4 типа процессов S, I, T и R.
   Считаем количество процессов по статусу:
```
vagrant@vagrant:~$ ps aexo pid,stat | grep ' S' | wc -l
56
vagrant@vagrant:~$ ps aexo pid,stat | grep ' I' | wc -l
50
vagrant@vagrant:~$ ps aexo pid,stat | grep ' T' | wc -l
3
vagrant@vagrant:~$ ps aexo pid,stat | grep ' R' | wc -l
1
vagrant@vagrant:~$
```
   Соответсвенно наиболее часто встречающийся статус у процессов - это статус S (cпящий: ожидает завершения события)
