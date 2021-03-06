#!/usr/bin/env python3

import socket, os

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
# Для всех ip-адресов проводим сравнение старых и новых
        for i in range(len(server_names)):
# Если адреса не совпадают - выводим предупреждение, если совпадат выводим просто информацию
            ip_address = socket.gethostbyname(server_names[i])
            if old_addresses[i].rstrip() != ip_address:
                print("[ERROR]", server_names[i], "IP mismatch:", old_addresses[i].rstrip(), ip_address)
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
