 devops-netology

# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

### 1. ipvs. Если при запросе на VIP сделать подряд несколько запросов (например, `for i in {1..50}; do curl -I -s 172.28.128.200>/dev/null; done `), ответы будут получены почти мгновенно. Тем не менее, в выводе `ipvsadm -Ln` еще некоторое время будут висеть активные `InActConn`. Почему так происходит?
   В режиме LVS-NUT директор видит все пакеты между клиентом и реальным сервером, поэтому всегда знает точно состояние TCP-соединений. В режимах LVS-DR и LVS-Tun директор не видит пакеты от
   реального сервера к клиенту. Завершение TCP-соединения происходит, когда кто-либо из них отправит FIN и получит ACK. Затем последует FIN в обратную сторону и получит ACK от инициатора.
   Если инициирует завершение соединения реальный сервер, то директор сможет понять, что это произошло только по ACK от клиента. Так как директор понимает, что соединение закрыто из частичной 
   информации, то он будет использовать свою таблицу таймаутов, что объявить, что соединение разорвано. Таким образом в столбце InACtConn для режимов LVS-DR и LVS-Tun будет предпологаемым,
   а не реальным.
   Такие службы как http или ftp разрывают соединение, как только получат запрос. Соотвественно записи в столбце ActiveConn сразу уменьшаться, а Запись в столбце InActConn будет до тех пор, 
   пока не истечет время ожидания соединения.
   Обысно количество записей InActConn больше, чем количество AcctConn.
   
### 2. На лекции мы познакомились отдельно с ipvs и отдельно с keepalived. Воспользовавшись этими знаниями, совместите технологии вместе (VIP должен подниматься демоном keepalived). Приложите конфигурационные файлы, которые у вас получились, и продемонстрируйте работу получившейся конструкции. Используйте для директора отдельный хост, не совмещая его с риалом! Подобная схема возможна, но выходит за рамки рассмотренного на лекции.
   Схему сети сделал по варианту предложенному Андреем Вахутинским - клиент (адрес 172.28.128.10), два балансера (172.28.128.60 и 172.28.128.90) и два real-сервера (172.28.128.110 и 172.28.128.120). VIP - 172.28.128.200
   Все адреса в сети /24.
   Конфигурация 1-го балансера:
```
root@Balance1:~# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  172.28.128.200:80 rr
  -> 172.28.128.110:80            Route   1      0          25
  -> 172.28.128.120:80            Route   1      0          25
root@Balance1:~# ip -4 addr show eth1 | grep inet
    inet 172.28.128.60/24 scope global eth1
    inet 172.28.128.200/24 scope global secondary eth1
root@Balance1:~# cat /etc/keepalived/keepalived.conf
vrrp_script chk_keepalive {
 script "systemctl status keepalived"
 interval 2 }
vrrp_instance VI_1 {
 state MASTER
 interface eth1
 virtual_router_id 50
 priority 100
 advert_int 1
 authentication {
 auth_type PASS
 auth_pass netology_secret
 }
 virtual_ipaddress {
 172.28.128.200/24 dev eth1
 }
 track_script {
 chk_keepalive
 } }
root@Balance1:~# systemctl status keepalived
● keepalived.service - Keepalive Daemon (LVS and VRRP)
     Loaded: loaded (/lib/systemd/system/keepalived.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-07-16 18:48:11 UTC; 5min ago
   Main PID: 13098 (keepalived)
      Tasks: 2 (limit: 1072)
     Memory: 2.2M
     CGroup: /system.slice/keepalived.service
             ├─13098 /usr/sbin/keepalived --dont-fork
             └─13109 /usr/sbin/keepalived --dont-fork

Jul 16 18:48:11 Balance1 Keepalived_vrrp[13109]: (Line 12) Truncating auth_pass to 8 characters
Jul 16 18:48:11 Balance1 Keepalived_vrrp[13109]: WARNING - script `systemctl` resolved by path search to `/usr/bin/systemctl`. Please specify full path.
Jul 16 18:48:11 Balance1 Keepalived_vrrp[13109]: SECURITY VIOLATION - scripts are being executed but script_security not enabled.
Jul 16 18:48:11 Balance1 Keepalived_vrrp[13109]: Registering gratuitous ARP shared channel
Jul 16 18:48:11 Balance1 Keepalived_vrrp[13109]: VRRP_Script(chk_keepalive) succeeded
Jul 16 18:48:11 Balance1 Keepalived_vrrp[13109]: (VI_1) Entering BACKUP STATE
Jul 16 18:48:12 Balance1 Keepalived_vrrp[13109]: (VI_1) received lower priority (50) advert from 172.28.128.90 - discarding
Jul 16 18:48:13 Balance1 Keepalived_vrrp[13109]: (VI_1) received lower priority (50) advert from 172.28.128.90 - discarding
Jul 16 18:48:14 Balance1 Keepalived_vrrp[13109]: (VI_1) received lower priority (50) advert from 172.28.128.90 - discarding
Jul 16 18:48:15 Balance1 Keepalived_vrrp[13109]: (VI_1) Entering MASTER STATE
root@Balance1:~#
```
   Конфигурация 2-го балансера:
```
root@Balance2:~# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  172.28.128.200:80 rr
  -> 172.28.128.110:80            Route   1      0          0
  -> 172.28.128.120:80            Route   1      0          0
root@Balance2:~# ip -4 addr show eth1 | grep inet
    inet 172.28.128.90/24 scope global eth1
root@Balance2:~# cat /etc/keepalived/keepalived.conf
vrrp_script chk_keepalive {
 script "systemctl status keepalived"
 interval 2 }
vrrp_instance VI_1 {
 state BACKUP
 interface eth1
 virtual_router_id 50
 priority 50
 advert_int 1
 authentication {
 auth_type PASS
 auth_pass netology_secret
 }
 virtual_ipaddress {
 172.28.128.200/24 dev eth1
 }
 track_script {
 chk_keepalive
 } }

root@Balance2:~# systemctl status keepalived
● keepalived.service - Keepalive Daemon (LVS and VRRP)
     Loaded: loaded (/lib/systemd/system/keepalived.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-07-16 18:54:44 UTC; 1min 48s ago
   Main PID: 31679 (keepalived)
      Tasks: 2 (limit: 1072)
     Memory: 2.0M
     CGroup: /system.slice/keepalived.service
             ├─31679 /usr/sbin/keepalived --dont-fork
             └─31690 /usr/sbin/keepalived --dont-fork

Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: Registering Kernel netlink reflector
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: Registering Kernel netlink command channel
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: Opening file '/etc/keepalived/keepalived.conf'.
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: WARNING - default user 'keepalived_script' for script execution does not exist - please create.
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: (Line 12) Truncating auth_pass to 8 characters
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: WARNING - script `systemctl` resolved by path search to `/usr/bin/systemctl`. Please specify full path.
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: SECURITY VIOLATION - scripts are being executed but script_security not enabled.
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: Registering gratuitous ARP shared channel
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: VRRP_Script(chk_keepalive) succeeded
Jul 16 18:54:44 Balance2 Keepalived_vrrp[31690]: (VI_1) Entering BACKUP STATE
root@Balance2:~#
```
   На обоих балансерах потребовалось включить маршрутизацию между интерфейсами
```
root@Balance1:~# sysctl -w net.ipv4.ip_forward=1
root@Balance1:~# sysctl -w net.ipv4.ip_forward=1

```
   1-й real-клиент
```
root@Real1:~# iptables -t nat -A PREROUTING -p tcp -d 172.28.128.200 --dport  80 -j REDIRECT
root@Real1:~# wc -l /var/log/nginx/access.log
80 /var/log/nginx/access.log
root@Real1:~#
```
  2-й real клиент
```
root@Real2:~# iptables -t nat -A PREROUTING -p tcp -d 172.28.128.200 --dport  80 -j REDIRECT
root@Real2:~# wc -l /var/log/nginx/access.log
79 /var/log/nginx/access.log
root@Real2:~#
```
   На обоих клиентах не добавлял адрес VIR на интерфейс, а воспользовался правилами iptables.
   Проверял работоспособность cхемы запуская на машине клиенте:
```
root@Client:~# curl -I -s 172.28.128.200:80 | grep HTTP
HTTP/1.1 200 OK
root@Client:~# for i in {1..50}; do curl -I -s 172.28.128.200>/dev/null; done
root@Client:~# for i in {1..50}; do curl -I -s 172.28.128.200>/dev/null; done
root@Client:~#
```
   При остановке сервиса keepalived на первом балансере или полном его отключении, все продолжало работать и запросы доходили до клиентов. Не знаю как это показать ((

### 3. В лекции мы использовали только 1 VIP адрес для балансировки. У такого подхода несколько отрицательных моментов, один из которых – невозможность активного использования нескольких хостов (1 адрес может только переехать с master на standby). Подумайте, сколько адресов оптимально использовать, если мы хотим без какой-либо деградации выдерживать потерю 1 из 3 хостов при входящем трафике 1.5 Гбит/с и физических линках хостов в 1 Гбит/с? Предполагается, что мы хотим задействовать 3 балансировщика в активном режиме (то есть не 2 адреса на 3 хоста, один из которых в обычное время простаивает).

   Если используется три балансировщика и три VIP, то при входящем трафике в 1,5 Гбит/с при потере одного из них один из балансировщиков возьмет на себя дополнительно 1.5/3=0.5 Гбит/с и при
   физических линках хостов в 1 Гбит/с один линков будет загружен на 100%, что несомненно вызовет деградацию. Исходя из вышеизложенного, при добавлении 4-го балансировщика и использовании 4 VIP,
   при потере одного из них загрузка одного из балансировщиков вырастет на 1.5/4=0.375 Гбит/с и составит 0.375+0.375=0.75 Гбит/с, что при пропускной способности канала в 1.5 Гбит/с вполне допустимо.
   Соотвественно оптимально использовать 4 адреса и 4 балансировщика.
