# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.   
  **Ответ:**   
  some_fact имеет значение 12   
```linux
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.   
  **Ответ:**
```linux
vagrant@vagrant:~/netology-playbook$ cat group_vars/all/examp.yml
---
  some_fact: all default fact
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.   
  **Ответ:**   
```linux
vagrant@vagrant:~$ docker run --name centos7 -d pycontribs/centos:7 sleep 6000000000
Unable to find image 'pycontribs/centos:7' locally
7: Pulling from pycontribs/centos
2d473b07cdd5: Pull complete
43e1b1841fcc: Pull complete
85bf99ab446d: Pull complete
Digest: sha256:b3ce994016fd728998f8ebca21eb89bf4e88dbc01ec2603c04cc9c56ca964c69
Status: Downloaded newer image for pycontribs/centos:7
61ee974f0b23ff99482c108d16b94b398abc4db88c48680f4415abbffc2fa118
vagrant@vagrant:~$ docker ps
CONTAINER ID   IMAGE                 COMMAND              CREATED         STATUS         PORTS     NAMES
61ee974f0b23   pycontribs/centos:7   "sleep 6000000000"   8 seconds ago   Up 7 seconds             centos7
vagrant@vagrant:~$ docker run --name ubuntu -d pycontribs/ubuntu:latest sleep 6000000000
Unable to find image 'pycontribs/ubuntu:latest' locally
latest: Pulling from pycontribs/ubuntu
423ae2b273f4: Pull complete
de83a2304fa1: Pull complete
f9a83bce3af0: Pull complete
b6b53be908de: Pull complete
7378af08dad3: Pull complete
Digest: sha256:dcb590e80d10d1b55bd3d00aadf32de8c413531d5cc4d72d0849d43f45cb7ec4
Status: Downloaded newer image for pycontribs/ubuntu:latest
f68834cec4acdd93eb09b9651b6994362f210d32c5ab62fb067303807a15fae6
vagrant@vagrant:~$ docker ps
CONTAINER ID   IMAGE                      COMMAND              CREATED          STATUS         PORTS     NAMES
f68834cec4ac   pycontribs/ubuntu:latest   "sleep 6000000000"   13 seconds ago   Up 5 seconds             ubuntu
61ee974f0b23   pycontribs/centos:7        "sleep 6000000000"   2 minutes ago    Up 2 minutes             centos7
vagrant@vagrant:~$
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.   
  **Ответ:**   
  some_fact имеет значения - CentOS для centos7 и Ubuntu для ubuntu.
```linux
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.   
  **Ответ:**
```linux
vagrant@vagrant:~/netology-playbook$ cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact'"
vagrant@vagrant:~/netology-playbook$ cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
vagrant@vagrant:~/netology-playbook$
```
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.   
  **Ответ:**
```linux
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact'"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.   
  **Ответ:**
```linux
vagrant@vagrant:~/netology-playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
vagrant@vagrant:~/netology-playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
vagrant@vagrant:~/netology-playbook$ cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
63646633386230333365313562336365623135386330613735373130363830343939656139313764
6135666362353536643638613761323137393838346132610a396335663761356335616335656365
33636236306264323132363965393836613962306536633266353563616663396363396237396334
6137383839326330380a306439303834386335346663633837663435663362326439646263653538
65613331363636616638353931353366323865333832386434383235613033323935666366366233
3437643564613563643135303239646261383532666661643039
vagrant@vagrant:~/netology-playbook$ cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
37356438613462363862636164303361303032656166613635333935343232643961616435333938
3263316333333730313830373362663966623032366361330a323337643565613337643363313364
66643038336564613335643962366235373330363437653931373233353535373433643262313130
6635666134613666610a626637366362353831326364383438653065383562373437343964333939
64396364636538303935626365373364613532383035353465663234653966613465333763353230
3262663535323837623931343961306563326431316339376565
vagrant@vagrant:~/netology-playbook$
```   
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.   
  **Ответ:**
```linux
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
``` 
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.   
  **Ответ:**
```linux
vagrant@vagrant:~/netology-playbook$ ansible-doc -t connection -l
ansible.netcommon.httpapi      Use httpapi to run command on network appliances
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection
ansible.netcommon.napalm       Provides persistent connection using NAPALM
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
ansible.netcommon.network_cli  Use network_cli to run command on network appliances
ansible.netcommon.persistent   Use a persistent unix socket for connection
community.aws.aws_ssm          execute via AWS Systems Manager
community.docker.docker        Run tasks in docker containers
community.docker.docker_api    Run tasks in docker containers
community.docker.nsenter       execute on host running controller container
community.general.chroot       Interact with local chroot
community.general.funcd        Use funcd to connect to target
community.general.iocage       Run tasks in iocage jails
community.general.jail         Run tasks in jails
community.general.lxc          Run tasks in lxc containers via lxc python library
community.general.lxd          Run tasks in lxc containers via lxc CLI
community.general.qubes        Interact with an existing QubesOS AppVM
community.general.saltstack    Allow ansible to piggyback on salt minions
community.general.zone         Run tasks in a zone instance
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
community.okd.oc               Execute tasks in pods running on OpenShift
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
containers.podman.buildah      Interact with an existing buildah container
containers.podman.podman       Interact with an existing podman container
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes
local                          execute on controller
paramiko_ssh                   Run tasks via python ssh (paramiko)
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
ssh                            connect via SSH client binary
winrm                          Run tasks over Microsoft's WinRM
vagrant@vagrant:~/netology-playbook$
```
Подходящий тип подключения `local`.   
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.   
  **Ответ:**   
  Файл prod.yml:   
```linux
vagrant@vagrant:~/netology-playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
vagrant@vagrant:~/netology-playbook$
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.   
  **Ответ:**  
```linux
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```   
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.   
  **Ответ:**  
```linux
vagrant@vagrant:~/netology-playbook$ ansible-vault decrypt group_vars/el/examp.yml
Vault password:
Decryption successful
vagrant@vagrant:~/netology-playbook$ ansible-vault decrypt group_vars/deb/examp.yml
Vault password:
Decryption successful
cat: decrypt: No such file or directory
---
  some_fact: "el default fact"
vagrant@vagrant:~/netology-playbook$ cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
vagrant@vagrant:~/netology-playbook$ cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
vagrant@vagrant:~/netology-playbook$
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.   
  **Ответ:**  
```linux
vagrant@vagrant:~/netology-playbook$ ansible-vault encrypt_string
New Vault password:
Confirm New Vault password:
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          31633762666634313033336265333061366361363535333031343839316137353738353336393239
          6634336130616638386564383539346433353535646530630a393033613436366366303966643039
          62393531396365336162333061313338616435663466656633396138666139313764623733643861
          3233343434313762340a656636303065366138616363626533643131346636623736313630313965
          3765
Encryption successful
vagrant@vagrant:~/netology-playbook$ cat group_vars/
all/ deb/ el/
vagrant@vagrant:~/netology-playbook$ cat group_vars/all/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          31633762666634313033336265333061366361363535333031343839316137353738353336393239
          6634336130616638386564383539346433353535646530630a393033613436366366303966643039
          62393531396365336162333061313338616435663466656633396138666139313764623733643861
          3233343434313762340a656636303065366138616363626533643131346636623736313630313965
          3765
vagrant@vagrant:~/netology-playbook$
```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.   
  **Ответ:**   
```linux
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).   
  **Ответ:**   
```linux
vagrant@vagrant:~/netology-playbook$ docker run --name fedora -d pycontribs/fedora:latest sleep 6000000000
Unable to find image 'pycontribs/fedora:latest' locally
latest: Pulling from pycontribs/fedora
588cf1704268: Pull complete
49425a0e12c7: Pull complete
Digest: sha256:20eeb45ef6e394947058dc24dc2bd98dfb7a8fecbbe6363d14ab3170f10a27ab
Status: Downloaded newer image for pycontribs/fedora:latest
f4c2a62564a5473e128a44e99bb214c9e7ca9e0ccb198f93b586505bf928fcf0
vagrant@vagrant:~/netology-playbook$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS         PORTS                 NAMES
f4c2a62564a5   pycontribs/fedora:latest   "sleep 6000000000"       5 seconds ago   Up 4 seconds                         fedora
e8cf6ef45f96   pycontribs/ubuntu:latest   "sleep 6000000000"       22 hours ago    Up 22 hours                          ubuntu
ccf2c2ef995c   pycontribs/centos:7        "sleep 6000000000"       22 hours ago    Up 22 hours                          centos7
dc1ef0a9d7ee   mysql:8                    "docker-entrypoint.s…"   2 months ago    Up 22 hours    3306/tcp, 33060/tcp   myslq
vagrant@vagrant:~/netology-playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  stage:
    hosts:
      fedora:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
vagrant@vagrant:~/netology-playbook$ cat group_vars/
all/   deb/   el/    stage/
vagrant@vagrant:~/netology-playbook$ cat group_vars/stage/examp.yml
---
  some_fact: "stage default facts"
vagrant@vagrant:~/netology-playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [fedora] => {
    "msg": "stage default facts"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

vagrant@vagrant:~/netology-playbook$
```   
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.   
  **Ответ:**   
  Скрипт:
```linux
vagrant@vagrant:~/netology-playbook$ cat script.sh
#!/bin/bash

# Проевряем запущены или нет контейнеры и запускаем их

if [ `docker ps | grep -c -i -e "fedora"` -eq 0 ] ; then
  docker start fedora
fi
if [ `docker ps | grep -c -i -e "ubuntu"` -eq 0 ] ; then
  docker start ubuntu
fi
if [ `docker ps | grep -c -i -e "centos7"` -eq 0 ] ; then
  docker start centos7
fi

# Выполняем playbook

ansible-playbook -i inventory/prod.yml site.yml --vault-id pass.txt

# Останавливаем контейнеры

docker stop fedora ubuntu centos7
vagrant@vagrant:~/netology-playbook$
```  

  Результат работы скрипта:   
```linux
vagrant@vagrant:~/netology-playbook$ sh script.sh
fedora
centos7

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "stage default facts"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

fedora
ubuntu
centos7
vagrant@vagrant:~/netology-playbook$
```
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---
