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
Используемые pipline указаны в reqs.txt. Для запуска можно сразу скопировать nf-app.service в /etc/systemd/system и в дальнейшем запускать:
```sh
systemctl start nf-app

```
Запуск проекта через docker-compose:
```sh
✔ ~/docker/otus-proj [master|✚ 4…2] 
11:12 $ docker-compose up -d
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

Добавлено логирование компонентов приложения:
```sh
[artys@otus-proj nf-app]$ ls -lah
total 640K
drwxrwxrwx.  2 root  root  4.0K Feb 27 11:40 .
drwxr-xr-x. 22 root  root  4.0K Feb 27 10:23 ..
-rw-r--r--.  1 root  root     0 Feb 27 11:07 error.log
-rw-rw-r--.  1 artys root  165K Feb 27 11:40 gc.log
-rw-rw-r--.  1 artys root  2.3K Feb 27 11:16 gc.log.00
-rw-rw-r--.  1 artys root  2.3K Feb 27 11:16 gc.log.01
-rw-rw-r--.  1 artys root   42K Feb 27 11:17 gc.log.02
-rw-rw-r--.  1 artys root  2.3K Feb 27 11:17 gc.log.03
-rw-rw-r--.  1 artys root  2.3K Feb 27 11:17 gc.log.04
-rw-rw-r--.  1 artys root   98K Feb 27 11:24 gc.log.05
-rw-rw-r--.  1 artys root  2.3K Feb 27 11:24 gc.log.06
-rw-rw-r--.  1 artys root  2.3K Feb 27 11:24 gc.log.07
-rw-rw-r--.  1 artys root     0 Feb 27 11:17 nf-elastic_audit.json
-rw-rw-r--.  1 artys root  3.3K Feb 27 11:26 nf-elastic_deprecation.json
-rw-rw-r--.  1 artys root     0 Feb 27 11:17 nf-elastic_index_indexing_slowlog.json
-rw-rw-r--.  1 artys root     0 Feb 27 11:17 nf-elastic_index_search_slowlog.json
-rw-rw-r--.  1 artys root   41K Feb 27 11:24 nf-elastic.log
-rw-rw-r--.  1 artys root  113K Feb 27 11:24 nf-elastic_server.json
-rw-r-----.  1 artys artys 5.5K Feb 27 11:39 nf-filebeat-20240227-75.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:39 nf-filebeat-20240227-76.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:39 nf-filebeat-20240227-77.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:39 nf-filebeat-20240227-78.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:40 nf-filebeat-20240227-79.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:40 nf-filebeat-20240227-80.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:40 nf-filebeat-20240227-81.ndjson
-rw-r-----.  1 artys artys 5.5K Feb 27 11:40 nf-filebeat-20240227-82.ndjson
-rw-rw-r--.  1 artys artys  27K Feb 27 11:26 nf-kibana.log
-rw-r--r--.  1 root  root  4.9K Feb 27 11:40 nf-nginx-access.log
-rw-r--r--.  1 root  root   11K Feb 27 11:26 nf-nginx-error.log
```

В config есть logrotate, который можно применить для данных логов.

РК и восстановление проекта автоматизированы, можно посмотреть [здесь](https://github.com/artysleep/otus-proj-automatization/tree/main).