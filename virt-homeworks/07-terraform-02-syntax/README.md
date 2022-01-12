# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются. 

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. 

AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
1. Установите c aws-cli https://aws.amazon.com/cli/.
1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
1. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess
1. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

  **Ответ:**
```
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# yc iam service-account create --name chuckberry321 --folder-id b1gq4sejntiisjvcq7m4
id: aje74imcvvvk3cqch2gm
folder_id: b1gq4sejntiisjvcq7m4
created_at: "2022-01-08T13:29:30.395403708Z"
name: chuckberry321

root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# yc iam key create --service-account-name chuckberry321 --output key.json
id: aje53qf12ang16adu7s7
service_account_id: aje74imcvvvk3cqch2gm
created_at: "2022-01-08T13:44:41.405960673Z"
key_algorithm: RSA_2048

root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# export YC_CLOUD_ID='yc config get cloud-id'
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# export YC_FOLDER_ID='yc config get folder-id'
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# export YC_TOKEN='yc config get token'
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# export YC_ZONE='yc config get compute-default-zone'
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# yc config list
token: AQAAAABRrvZjAATuwSppXfDalUbCjt1DtaK5iA0
cloud-id: b1guvq2fdi6hehnnq8mg
folder-id: b1gq4sejntiisjvcq7m4
compute-default-zone: ru-central1-b
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform# cat main.tf
 terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.69.0"
    }
  }
}

provider "yandex" {
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"
}
root@vagrant:/home/vagrant/devops-netology/yandex-cloud-terraform#
```


## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.  

  **Ответ:**
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
```
  При помощи CloudFormation
```

2. Ссылка на репозиторий с исходной конфигурацией терраформа.

  <https://github.com/chuckberry321/devops-netology/tree/main/terraform/main.tf>

- main.tf 
```
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.69.0"
    }
  }
}

provider "yandex" {
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83klic6c8gfgi40urb"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("/home/vagrant/devops-netology/terraform/meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
```

- данные пользователя для доступа к ВМ. Файл meta.txt
```
#cloud-config
users:
  - name: vagrant
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6gDyT6NsUd9r4ac51FZvATxaIB0xxyqTUckMH6T7D0yibU7uWYbQ/8IJr1ildqHrY/eGWgiwSjgsCqVO7g1hc8CT7SJOiQgezElEhqbaA8dqzwxPQ/pjc+lWq59vrVgZwnRLFPMkgSIFsD84/gr7PDElrUGmGVZD8g39UMJaWlyizzOWlcEErxMWuN3shWcuqgoN0b0DonyqnSoNjLEme5RQEbZP2PVT5pjijY1xR2hf3nxXE7d0JS8u/mw08o35NxvU3UjYMchAak2hEa7+0/8xDPtU/1PooQE5DSINUqk0gzYD9NohYPMACDkthBU+lBMU0CUPo7bK0Q+kKBUXL vagrant@vagrant
root@vagrant:/home/vagrant/devops-netology/terraform#
```

- Результат выполнения terraform apply
  (https://github.com/chuckberry321/devops-netology/blob/main/virt-homeworks/07-terraform-02-syntax/screenshot.png)


### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
