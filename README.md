# КриптоПро в Linux контейнере для использования КЭП от ФНС

Описанный подход позволяет пользоваться КЭП от ФНС под любым дистрибутивом Linux.
Тестировалось с Рутокен ЭЦП 3.0

Потребуется:
- Установить всё необходимое для работы токена на хост системе, обычно это pcsc и библиотеки к нему (смотреть на сайте производителя)
- Скачать все необходимые пакеты в папку с Dockerfile
- Собрать образ docker `docker build ./ -t cryptopro-in-container:first`
- Разрешить открыть окна в wm приложениям со стороны `xhost +local:`
- Запустить контейнер из полученного образа 
```
docker run --rm -ti -v `pwd`/:/something -v /run/pcscd/pcscd.comm:/run/pcscd/pcscd.comm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix"$DISPLAY" cryptopro-in-container:20221213 /bin/bash -i
# Где /run/pcsсd/pcscd.comm сокет для обращений
# /tmp/.X11-unix доступ к активной сессии
# DISPLAY переменная определяющая где открывать окна
# something папка внутри контейнера с содержимым той папки из которой запускаете
```
- Найти имя своего криптоконтейнера  `csptest -keyset -enum_cont -fqcn -verifyc`
```
root@d66b9560c771:/# csptest -keyset -enum_cont -fqcn -verifyc
CSP (Type:80) v5.0.10010 KC1 Release Ver:5.0.12455 OS:Linux CPU:AMD64 FastCode:READY:AVX.
AcquireContext: OK. HCRYPTPROV: 17693171
\\.\Aktiv Rutoken ECP 00 00\0c686f35c-328c-0cf8-e404-900dcf68a53
OK.
Total: SYS: 0.010 sec USR: 0.040 sec UTC: 0.820 sec
[ErrorCode: 0x00000000]
```
- Копировать публичный сертификат с токена в файл `certmgr -export -dest mine.crt -container '\\.\Aktiv Rutoken ECP 00 00\0c686f35c-328c-0cf8-e404-900dcf68a53'`
- Установить свой сертификат внутри контейнера `certmgr -install -store uMy -file mine.crt -cont '\\.\Aktiv Rutoken ECP 00 00\0c686f35c-328c-0cf8-e404-900dcf68a53'`
- Запустить браузер `firefox`

