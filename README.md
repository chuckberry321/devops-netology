 devops-netology

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

### 1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
	```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
	```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

  Пример с исправленными ошибками:
```{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
}
```
   Наличие горизонтального TABa в значении ключа "info" ошибкой, как мне кажется, не является.
 
### 2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

   Пример скрипта и вывод данных:

```
vagrant@vagrant:~/devops-netology$ cat lessson_4.3.py 
#!/usr/bin/env python3

import socket, os, json, yaml

servers_dict = list()
server_names = ['drive.google.com', 'mail.google.com', 'google.com']
# Проверяем есть ли файл, если нет, то создаем
f = open("servers.log", "a")
f.close()
# Открываем файл для чтения
with open("servers.log", "r+") as f:
# Проверяем размер файла, чтобы выяснить есть ли в нем данные или он только создан. 
   if os.path.getsize('servers.log') > 0:
# читаем данные из файла в массив
        old_addresses = f.readlines()       
        f.seek(0)
# Убираем \n
        for i in range(len(old_addresses)):
            old_addresses[i] = old_addresses[i].rstrip()
# Добавляем в список словари
            servers_dict.append({server_names[i]: old_addresses[i]})
# Для всех ip-адресов проводим сравнение старых и новых
        for i in range(len(servers_dict)):
# Если адреса не совпадают - выводим предупреждение, если совпадат выводим просто информацию
            ip_address = socket.gethostbyname(server_names[i])
            if old_addresses[i] != ip_address:
                print("[ERROR]", server_names[i], "IP mismatch:", old_addresses[i], ip_address)
            else:
                print(server_names[i], " - ", ip_address)
# Сохраняем адреса в файл
            print(ip_address, file=f)
# Если файл только создан, сохраняем адреса в файл
   else:
       f.seek(0)
       for i in server_names:
           print(i, " - ", socket.gethostbyname(i))
           print(socket.gethostbyname(i), file=f)
# Сохраняем данные json-формате
with open("servers.json", "w") as f:
    f.write(json.dumps(servers_dict))
# Сохраняем данные в yaml-формате
with open("servers.yml", "w") as f:
    f.write(yaml.dump(servers_dict))
vagrant@vagrant:~/devops-netology$ ./lessson_4.3.py 
drive.google.com  -  64.233.163.194
mail.google.com  -  142.251.1.18
google.com  -  173.194.73.113
vagrant@vagrant:~/devops-netology$ cat servers.json 
[{"drive.google.com": "64.233.163.194"}, {"mail.google.com": "142.251.1.18"}, {"google.com": "173.194.73.113"}]
vagrant@vagrant:~/devops-netology$ cat servers.yml 
- drive.google.com: 64.233.163.194
- mail.google.com: 142.251.1.18
- google.com: 173.194.73.113
vagrant@vagrant:~/devops-netology$ 
```
