# otus-proj-new

## Это завершающая проектная работа по курсу **"Расширенное администрирование РЕД ОС"** от **OTUS**.
Это сборщик _syslog_, _журнала IP-пакетов (Infotecs)_ и _Netflow_ с активного сетевого оборудования.
Все компоненты запущены в отдельных контейнерах:
1. **nf-elastic** - Elasticsearch - масштабируемое нереляционное хранилище данных с открытым исходным кодом, аналитическая NoSQL-СУБД с широким набором функций полнотекстового поиска;
2. **nf-kibana** - Kibana - программная панель визуализации данных;
3. **nf-filebeat** - Filebeat - плагин, который позволяет собирать и передавать логи в Elasticsearch (использовны input syslog, netflow и модуль cef). Для контейнера используется host network;
4. **nf-nginx** - HTTP-сервер и обратный прокси-сервер, используется поскольку связь между компонентами организована посредством http, а не https, а так же позволяет реализовать простую аутентификацию пользователя. Из созданного docker-bridge наружу во вне слушает только nginx).

Немного скриншотов дашбордов **_Kibana_**:
<img width="953" alt="Screenshot 2024-02-26 210605" src="https://github.com/artysleep/otus-proj-new/assets/7562889/bf7a7f9e-d386-476d-bb95-99163570e82c">
![Screenshot 2024-02-26 174625](https://github.com/artysleep/otus-proj-new/assets/7562889/90ee5c7e-50cb-4c77-b29c-087515c2e0b9)
![Screenshot 2024-02-26 174532](https://github.com/artysleep/otus-proj-new/assets/7562889/fda3612a-42e0-4a6c-954d-748b7264ac37)

Перед началом работы необходимо скорректировать .env по примеру example_env, а так же если запуск осуществляется в первый раз необходимо подготовить (настроить Data Stream в Elasticsearch, загрузить дефолтные Dashboards Filebeat с интересующим индексом).
Запуск проекта через docker-compose:
```sh
✔ ~/docker/otus-proj [master|✚ 4…2] 
11:12 $ docker compose up -d
[+] Running 6/6
 ⠿ Network nf-net          Created                                                                                                                                                                                          0.2s
 ⠿ Volume "nf-log-volume"  Created                                                                                                                                                                                          0.0s
 ⠿ Container nf-elastic    Healthy                                                                                                                                                                                        126.5s
 ⠿ Container nf-kibana     Healthy                                                                                                                                                                                        126.4s
 ⠿ Container nf-filebeat   Healthy                                                                                                                                                                                        136.8s
 ⠿ Container nf-nginx      Started  
```

Для проверки работоспособности Filebeat и готовности его принимать **_Netflow, Syslog или CEF (пока только от Infotecs)_** можно проверить открытые порты в состоянии прослушивания заданные в файле .env: 
```sh
[artys@otus-proj nf-app]$ ss -ulpn
State     Recv-Q     Send-Q         Local Address:Port          Peer Address:Port    Process
UNCONN    0          0                    0.0.0.0:5353               0.0.0.0:*
UNCONN    0          0              192.168.88.37:6044               0.0.0.0:*        users:(("filebeat",pid=115884,fd=19))
UNCONN    0          0              192.168.88.37:6055               0.0.0.0:*        users:(("filebeat",pid=115884,fd=17))
UNCONN    0          0              192.168.88.37:6514               0.0.0.0:*        users:(("filebeat",pid=115884,fd=18))
UNCONN    0          0                    0.0.0.0:40275              0.0.0.0:*
UNCONN    0          0                  127.0.0.1:323                0.0.0.0:*
```

Добавлено логирование компонентов приложения в journald, просмотр логов осуществляется следующим образом:
```sh
journalctl -b CONTAINER_NAME=nf-elastic
journalctl -b CONTAINER_NAME=nf-kibana
journalctl -b CONTAINER_NAME=nf-filebeat
journalctl -b CONTAINER_NAME=nf-nginx
```
Например:
```sh
12:13 $ journalctl -b CONTAINER_NAME=nf-nginx 
-- Logs begin at Fri 2024-02-09 18:37:36 MSK, end at Wed 2024-02-28 15:07:58 MSK. --
Feb 28 12:08:20 otus-proj.lab.local 164b8be13eaa[840]: /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
Feb 28 12:08:20 otus-proj.lab.local 164b8be13eaa[840]: /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
```
Посмотреть логи всех компонентов:
```sh
journalctl -b -xu docker.service
```

РК и восстановление проекта автоматизированы, можно посмотреть [здесь](https://github.com/artysleep/otus-proj-automatization/tree/main).