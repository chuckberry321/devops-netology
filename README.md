 devops-netology

# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"
##     1. Какие ресурсы выделены по-умолчанию виртуальной машине?
          ОЗУ - 1024 Мб, видеопамять - 4 Мб, объем диска - 64 Гб

##     2. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
          При помощи утилиты VBoxManage, вызывая команду утилиты непосредственно перед загрузкой машины.
          Например:
            config.vm.provider "virtualbox" do |vb|
              имя виртуальной машины
              vb.name = "My virtual machine"
              объем оперативной памяти
              vb.memory = 4096
              количество ядер процессора
              vb.cpus = 2
              hostname виртуальной машины
              config.vm.hostname = "My host"
            end
          Меняем - имя вирутальной машины на "My virtual machine", объем ОЗУ на 4 Гб, кол-во ядер процессора на 2 и имя хоста на "My host" 

##     3. Ознакомиться с разделами man bash, почитать о настройках самого bash:
         - какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
         - что делает директива ignoreboth в bash?   
            Длина журнала задается переменной HISTIZE, это описывается на строчке 628:
              HISTSIZE
                     The number of commands to remember in the command history (see HISTORY below).  If the value is 0, commands are not saved in the history list.  Numeric values less than zero result  in  every
                     command being saved on the history list (there is no limit).  The shell sets the default value to 500 after reading any startup files.
            Директива 'ignoreboth' относится к опции HISTCONTROL и указвает использовать две директивы 'ignorespace' (строки, начинающиеся с пробела, не будут сохраняться в истории) 
            и 'ignoredups' ( строки, совпадающие с последней выполненной командой, не будут сохранться в истории)

##      4. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
            Скобки {} применяются в составных командах. Список заключенный в скобки {} выполняется в текущей среде текущего интерпретатора и должен заканчиваться новой строкой или ;
            В конструкции [ function ] name () { list; } список между скобками {} образует тело функции, этот список выполняется всегда, когда имя фнукции указывается как имя команды.
            Описано на строчке 205  в man bash.
               { list; }
                        list is simply executed in the current shell environment.  list must be terminated with a newline or semicolon.  This is known as a group command.  The return status is  the  exit  status  of
                        list.   Note that unlike the metacharacters ( and ), { and } are reserved words and must occur where a reserved word is permitted to be recognized.  Since they do not cause a word break, they
                        must be separated from list by whitespace or another shell metacharacter. 

##       5. Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000?
             touch file-{1..100000}.txt
             Создать 300000 не получается из-за ошибки 'Argument list too long'
##       6. Что делает конструкция [[ -d /tmp ]]?
             Эта конструкция проверяет существование директории /tmp, так как директория существует, то возвращает 1. Это расширенный вариант [] в части использования && и ||, что внутри [] приведет к ошибке. 

##       7. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы
##           рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке
             325  sudo nano README.md
             326  PATH=/tmp/my_bash:&PATH
             327  PATH=/tmp/my_bash:$PATH
             328  echo $PATH
             329  type -a bash
             330  history
             vagrant@vagrant:~/devops-netology$ type -a bash
             bash is /tmp/my_bash/bash
             bash is /usr/bin/bash
             bash is /bin/bash
             vagrant@vagrant:~/devops-netology$
##        8. Чем отличается планирование команд с помощью batch и at?    
           at позволяет пользователю планировать задачу
           batch позволяет запускать задание только в указанное время, если загрузка системы находится на определенном уровне
