 devops-netology

# Домашнее задание к занятию "3.5. Файловые системы"

### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Нет, не могут. Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. 
Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.
Различаются только имена файлов. Фактически жесткая ссылка это еще одно имя для файла.

### 14. Прикрепите вывод `lsblk`.

```root@vagrant:~# lsblk
NAME                     MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                        8:0    0   64G  0 disk  
├─sda1                     8:1    0  512M  0 part  /boot/efi
├─sda2                     8:2    0    1K  0 part  
└─sda5                     8:5    0 63.5G  0 part  
  ├─vgvagrant-root       253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1     253:1    0  980M  0 lvm   [SWAP]
sdb                        8:16   0  2.5G  0 disk  
├─sdb1                     8:17   0    2G  0 part  
│ └─md0                    9:0    0    2G  0 raid1 
└─sdb2                     8:18   0  511M  0 part  
  └─md1                    9:1    0 1018M  0 raid0 
    └─vg_raid_0-lv_raid0 253:2    0  100M  0 lvm   /tmp/new
sdc                        8:32   0  2.5G  0 disk  
├─sdc1                     8:33   0    2G  0 part  
│ └─md0                    9:0    0    2G  0 raid1 
└─sdc2                     8:34   0  511M  0 part  
  └─md1                    9:1    0 1018M  0 raid0 
    └─vg_raid_0-lv_raid0 253:2    0  100M  0 lvm   /tmp/new
```

### 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

```[ 5743.325644] md/raid1:md0: not clean -- starting background reconstruction
[ 5743.325646] md/raid1:md0: active with 2 out of 2 mirrors
[ 5743.325663] md0: detected capacity change from 0 to 2144337920
[ 5743.332537] md: resync of RAID array md0
[ 5753.822147] md: md0: resync done.
[ 5761.558777] md1: detected capacity change from 0 to 1067450368
[ 7382.090673] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[ 7382.090678] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[ 8697.595722] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[ 8697.595727] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[11195.101264] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[11195.101270] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[11361.722217] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
root@vagrant:~# 
```

В последних строчках выода *dmesg* видно, что RAID1 работает в деградированном состоянии.
 
 ---

