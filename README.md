 devops-netology
# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

   * Ответ на доп. задание. Скрипт ниже.

```
vagrant@vagrant:~/devops-netology$ cat lessson_4.2-add.py 
#!/usr/bin/env python3

import sys, github
from github import Github
if len(sys.argv) > 1 and sys.argv[1] != "":
    pull_request = sys.argv[1]
else:
    print("Pell Request message is not defined!")
    exit(-1)
repo = "devops-netology"
git = Github("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")
repo = git.get_user().get_repo(repo)
print("Pull request " + str(repo) + ". Message: " + pull_request)     
repo.create_pull(title="Pull Request", body=pull_request, head="HW4.3", base="main")
vagrant@vagrant:~/devops-netology$ ./lessson_4.2-add.py PR
Pull request Repository(full_name="chuckberry321/devops-netology"). Message: PR
vagrant@vagrant:~/devops-netology$ 
```
