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

![Screenshot 2024-02-26 173922](https://github.com/artysleep/otus-proj-new/assets/7562889/830166b8-d8f5-4ae3-bb0d-41216de50ff8)

Для проверки работоспособности Filebeat и готовности его принимать **_Netflow, Syslog или CEF (пока только от Infotecs)_** можно проверить открытые порты в состоянии прослушивания заданные в файле .env: 
![Screenshot 2024-02-26 174309](https://github.com/artysleep/otus-proj-new/assets/7562889/82fb0d4a-67b3-4248-9935-fba82c6adc8f)

РК и восстановление проекта автоматизированы, можно посмотреть [здесь](https://github.com/artysleep/otus-proj-automatization/tree/main).
