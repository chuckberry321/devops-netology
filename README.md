 devops-netology

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

### 1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
   Переменной с не будет присвоенно никакое значение, так как переменные a и b разного типа. Попытка выполнения операции сложения вызовет ошибку *unsupported operand type(s) for +: 'int' and 'str'*.
	* Как получить для переменной c значение 12?
   Значение с равное 12, можно получить сложением текстовых переменных со значениями '1' и '2' и переводом резльтат в тип int. Скрипт будет выглядеть следующим образом:
```
vagrant@vagrant:~/devops-netology$ cat lessson_4.2.py 
#!/usr/bin/env python3
a = 1
b = '2'
c = int(str(a) + b)
print(c)
vagrant@vagrant:~/devops-netology$ chmod 744 lessson_4.2.py
vagrant@vagrant:~/devops-netology$ ./lessson_4.2.py 
12
vagrant@vagrant:~/devops-netology$ 
``` 
	* Как получить для переменной c значение 3?
   Значение c равное 3 можно получить путем сложения переменных переменных a и b со значениями 1 и 2 соответсвенно, для чего необходимо привести значение b к типу int. Пример крипта:
```
vagrant@vagrant:~/devops-netology$ cat lessson_4.2.py 
#!/usr/bin/env python3
a = 1
b = '2'
c = a + int(b)
print(c)
vagrant@vagrant:~/devops-netology$ ./lessson_4.2.py 
3
vagrant@vagrant:~/devops-netology$
```
   

### 2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```
   Не выводятся все измененные файлы из-за опертаора break, который прерывает цикл for при первом же слове *modified* в выоде команды *git status*. Путь к файлу можно втсаивть вместо слова *modified:*
   Пример скрипта и результата его работы:
```
root@vagrant:/home/vagrant/devops-netology# cat lessson_4.2.py 
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
       if result.find('modified') != -1:
           prepare_result = result.replace('\tmodified:   ', '~/netology/sysadm-homeworks/')
           print(prepare_result)
root@vagrant:/home/vagrant/devops-netology# ./lessson_4.2.py 
~/netology/sysadm-homeworks/02-git-04-tools/README.md
~/netology/sysadm-homeworks/README.md
root@vagrant:/home/vagrant/devops-netology#
```

### 3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
   Пример доработанного срипта и результат его работы:
```
root@vagrant:/home/vagrant/devops-netology# cat lessson_4.2.py 
#!/usr/bin/env python3

import os, sys

bash_command = ["cd " + sys.argv[1], "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
       if result.find('modified') != -1:
           prepare_result = result.replace('\tmodified:   ', sys.argv[1])
           print(prepare_result)
root@vagrant:/home/vagrant/devops-netology# ./lessson_4.2.py  ~/netology/sysadm-homeworks
/root/netology/sysadm-homeworks02-git-04-tools/README.md
/root/netology/sysadm-homeworksREADME.md
root@vagrant:/home/vagrant/devops-netology# ./lessson_4.2.py  /home/vagrant/devops-netology/
/home/vagrant/devops-netology/README.md
root@vagrant:/home/vagrant/devops-netology#
```

### 4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
    Пример скрипта и результат его работы. Пояснения в тексте скрипта:
```root@vagrant:/home/vagrant/devops-netology# cat lessson_4.2.3.py 
#!/usr/bin/env python3

import socket, os

server_names = ['drive.google.com', 'mail.google.com', 'google.com']
# Проверяем есть ли файл, если нет, то создаем
f = open("servers.log", "a")
f.close()
# Открываем файл для чтения и записи
with open("servers.log", "r+") as f:
# Проверяем размер файла, чтобы выяснить есть ли в нем данные или он только создан. 
   if os.path.getsize('servers.log') > 0:
# читаем данные из файла в массив
        old_addresses = f.readlines()
        f.seek(0)
# Для всех ip-адресов проводим сравнение старых и новых
        for i in range(len(server_names)):
# Если адреса не совпадают - выводим предупреждение, если совпадат выводим просто информацию
            if old_addresses[i].rstrip() != socket.gethostbyname(server_names[i]):
                print("[ERROR]", server_names[i], "IP mismatch:", old_addresses[i].rstrip(), socket.gethostbyname(server_names[i]))
            else:
                print(server_names[i], " - ", socket.gethostbyname(server_names[i]))
# Сохраняем адреса в файл
            print(socket.gethostbyname(server_names[i]), file=f)
# Если файл только создан, сохраняем адреса в файл
   else:
       f.seek(0)
       for i in server_names:
           print(i, " - ", socket.gethostbyname(i))
           print(socket.gethostbyname(i), file=f) 
root@vagrant:/home/vagrant/devops-netology# 
root@vagrant:/home/vagrant/devops-netology# ./lessson_4.2.3.py 
drive.google.com  -  64.233.162.194
mail.google.com  -  173.194.222.18
google.com  -  142.251.1.113
root@vagrant:/home/vagrant/devops-netology# ./lessson_4.2.3.py 
drive.google.com  -  64.233.162.194
[ERROR] mail.google.com IP mismatch: 173.194.222.17 173.194.222.18
google.com  -  142.251.1.113
root@vagrant:/home/vagrant/devops-netology#
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

